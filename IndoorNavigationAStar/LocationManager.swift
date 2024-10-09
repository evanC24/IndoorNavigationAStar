//
//  LocationManager.swift
//  IndoorNavigationAStar
//
//  Created by Ivan Coppola on 05/10/24.
//

import Foundation
import Combine
import CoreLocation
import UIKit
import PositioningLibrary
import RealityKit

class LocationManager: ObservableObject, LocationObserver {
    
    @Published var headingDifference: CGFloat?
    @Published var proximity: Float?
    @Published var currentBuilding: String?
    @Published var currentFloor: String?
    
// camera ivan
//    @Published var width: Float = 2.9
//    @Published var height: Float = 2.9
    
// camera rebecca
//    @Published var width: Float = 2.75
//    @Published var height: Float = 5
    
    @Published var width: Float = 7.69
    @Published var height: Float = 3.73
    
    private var locationProvider: LocationProvider!
    private var arView: ARView?
    
    @Published var currentLocation: Point?
//    @Published var endLocation: Point = Point(x: 2.9, y: 2.9)
//    @Published var endLocation: Point = Point(x: 5, y: 2.75 - 0.56 )
    @Published var endLocation: Point = Point( x: 5.285, y: 3.73 )
    
    @Published var path: [Point]?
    @Published var isArrived: Bool = false

    private var anchorEntities: [AnchorEntity] = []
    private var endAnchorEntity: AnchorEntity?
    
    func startLocationUpdates(arView: ARView) {
        let myMarkers = loadDynamicData()
        self.locationProvider = LocationProvider(arView: arView, markers: myMarkers)
        self.locationProvider.addLocationObserver(locationObserver: self)
        
        let margin: CGFloat = 32
        let floorMapRect = CGRect(
            x: margin,
            y: margin,
            width: 150,
            height: 150
        )
        
        self.arView = arView
        self.locationProvider.showFloorMap(floorMapRect)
        self.locationProvider.start()
    }
    
    
    func onLocationUpdate(_ newLocation: ApproxLocation) {
        self.currentLocation = Point(
            x: Float(newLocation.coordinates.x),
            y: Float(newLocation.coordinates.y),
            heading: newLocation.heading
        )
        
//        centerToUserPosition()
        
        if let path = self.path, path.count > 0 {
//                var pathPoints: [Point] = []
//                for (i, pathPoint) in path.enumerated() {
//                    if i % 10 == 0 || i == path.count - 1 {
//                        print("#\(i): (\(pathPoint.x),\(pathPoint.y))")
//                        pathPoints.append(pathPoint)
//                    }
//                }
//                guideUser(from: currentLocation!, to: pathPoints.first!)
//
            guideUser(from: currentLocation!, to: path.first!)
        } else {
            guideUser(from: currentLocation!, to: endLocation )
        }
    }
    
    func createPath() {
        guard let currentLocation else { return }
        guard let arView else { return  }
        
        var obstacles: [Obstacle] = []
        
        // IVAN camera
//        var bedObstacles: Obstacle = Obstacle(topLeft: Point(x: 0, y: 1.4), bottomRight: Point(x: 2.2, y: 2.5))
//        obstacles.append(contentsOf: bedObstacles.points)
//        var deskObstacles: Obstacle = Obstacle(topLeft: Point(x: width - 1.41, y: 0), bottomRight: Point(x: width, y: 0.66))
//        obstacles.append(contentsOf: deskObstacles.points)
        
        // IVAN veranda
        var table1: Obstacle = Obstacle(topLeft: Point(x: 1.03, y: 0), bottomRight: Point(x: 1.03+0.94, y: 1.70))
        var table2: Obstacle = Obstacle(topLeft: Point(x: 2.74, y: 1.10), bottomRight: Point(x: 2.74+0.94, y: 7.69))
        var chairs: Obstacle = Obstacle(topLeft: Point(x: 2.74+0.94, y: 1.10), bottomRight: Point(x: width - 2, y: 1.10+0.60))
        obstacles.append(table1)
        obstacles.append(table2)
        obstacles.append(chairs)
        

        // REBECCA
        //        var bedOstacle: Obstacle = Obstacle(topLeft: Point(x: height, y: width - 0.56), bottomRight: Point(x: height - 1.32, y: width))
        
        let map = Map(width: width, height: height, obstacles: obstacles)
        
        path = map.findPath( start: currentLocation,
                             goal: endLocation)
        
        addDestinationAnchorToARView(arView: arView, goalPoint: endLocation)
//        addPoints()
        
    }
    
    func addPoints() {
        guard let currentLocation else { return }
        guard let arView else { return  }
        
        if let path = self.path {
            var pointsToRender: [Point] = []
            for (i, pathPoint) in path.enumerated() {
                if i % 10 == 0 || i == path.count - 1 {
                    print("#\(i): (\(pathPoint.x),\(pathPoint.y))")
                    pointsToRender.append(pathPoint)
                }
            }
            
            removeAllAnchors(arView: arView)
            addPointsToARViewWithGradient(arView: arView, points: pointsToRender, startPoint: currentLocation, goalPoint: endLocation)
            
            //        guideUserToGoal(currentLocation: currentLocation, goalLocation: self.goalLocation)
            //            guideUserToGoal(currentLocation: currentLocation, goalLocation: path.first!)
        }
    }
    
    func resetPath(arView: ARView) {
        removeAllAnchors(arView: arView)
        self.path = nil
        print(path ?? "vuoto")
    }
    
    func onBuildingChanged(_ newBuilding: Building) {
        currentBuilding = newBuilding.name
        print("Building changed: \(newBuilding.name)")
    }
    
    func onFloorChanged(_ newFloor: Floor) {
        currentFloor = "\(newFloor.number)°"
        print("Floor changed: \(newFloor.number)")
    }
    
    
    private func guideUser(from currentLocation: Point, to goalLocation: Point) {
        let bearingToGoal = calculateBearing(from: currentLocation, to: goalLocation)
        let headingDiff = bearingToGoal + currentLocation.heading
        let normalizedHeadingDiff = normalizeAngleToPi(headingDiff)
        
        self.headingDifference = CGFloat(normalizedHeadingDiff)
        self.proximity = calculateProximity(from: currentLocation, to: goalLocation)
        
        // If user is close enough to the goal location, move to the next path point
        if calculateProximity(from: currentLocation, to: endLocation) < 0.5 {
            isArrived = true
            return
        } else if goalLocation != endLocation && proximity! < 0.5 {
            print("Removed: \(String(describing: self.path?.first!))")
            self.path?.removeFirst()
            print("Path size: \(String(describing: self.path?.count))")
        }
        isArrived = false
    }
    
    
    func centerToUserPosition() {
        self.locationProvider.centerToUserPosition()
    }
    
    
    private func loadDynamicData() -> [Marker] {

        let b1 = Building(
            id: "b1", name: "Casa",
            coord: CLLocationCoordinate2D(
                latitude: 45.47908247767321, longitude: 9.227200675127934))
        let b2 = Building(
            id: "b2", name: "Casa Rebecca",
            coord: CLLocationCoordinate2D(
                latitude: 45.47908247767321, longitude: 9.227200675127934))

        
        let floor0 = Floor(
            id: "f1_1", name: "piano terra", number: 0, building: b1,
            maxWidth: 2.90, maxHeight: 2.90, floorMap: UIImage(named: "piano0")!
        )
        let floor1 = Floor(
            id: "f1_2", name: "veranda", number: 1, building: b1,
            maxWidth: 7.69, maxHeight: 3.74, floorMap: UIImage(named: "veranda")!
        )
        
        let floor4 = Floor(
            id: "f2_4", name: "piano 4", number: 4, building: b2,
            maxWidth: 5, maxHeight: 2.75, floorMap: UIImage(named: "piano4")!
        )
        
        
        let m0 = Marker(
            id: "CO1",
            image: UIImage(named: "co1")!,
            physicalWidth: 0.054,
            location: Location(coordinates: CGPoint(x: 1.5, y: 0), heading: 0, floor: floor0)
        )
        let m1 = Marker(
            id: "CR1",
            image: UIImage(named: "cr1")!,
            physicalWidth: 0.21,
            location: Location(coordinates: CGPoint(x: 0, y: 1.15), heading: -1.57, floor: floor0)
        )
        let m2 = Marker(
            id: "CR2",
            image: UIImage(named: "cr2")!,
            physicalWidth:  0.054,
            location: Location(coordinates: CGPoint(x: 2.13, y: 2.9), heading: 3.14, floor: floor0)
        )
        
        let m_r1 = Marker(
            id: "R1",
            image: UIImage(named: "r1")!,
            physicalWidth: 0.12,
            location: Location(coordinates: CGPoint(x: 3.24, y: 0), heading: 0, floor: floor4)
        )
        
        let m_r2 = Marker(
            id: "R2",
            image: UIImage(named: "r2")!,
            physicalWidth: 0.49,
            location: Location(coordinates: CGPoint(x: 5 - 0.56, y: 2.75 - 0.56), heading: 3.14, floor: floor4)
        )
        let m_r3 = Marker(
            id: "R3",
            image: UIImage(named: "r3")!,
            physicalWidth: 0.20,
            location: Location(coordinates: CGPoint(x: 1.44 - 0.20/2, y: 2.75 - 0.6), heading: 3.14, floor: floor4)
        )
        
        let m_r4 = Marker(
            id: "R4",
            image: UIImage(named: "r4")!,
            physicalWidth: 0.22,
            location: Location(coordinates: CGPoint(x: 0, y: 2.75 - 0.91), heading: -1.57, floor: floor4)
        )
        
        let v1 = Marker(
            id: "v1",
            image: UIImage(named: "v1")!,
            physicalWidth: 0.193,
            location: Location(coordinates: CGPoint(x: 0.62, y: 0), heading: 0, floor: floor1)
        )
        let v2 = Marker(
            id: "v2",
            image: UIImage(named: "v2")!,
            physicalWidth: 0.135,
            location: Location(coordinates: CGPoint(x: 1.855+0.8+0.135/2, y: 2.82), heading: 3.14, floor: floor1)
        )
        let v3 = Marker(
            id: "v3",
            image: UIImage(named: "v3")!,
            physicalWidth: 0.135,
            location: Location(coordinates: CGPoint(x: 2.615+1.85+0.135/2, y: 0), heading: 0, floor: floor1)
        )
        let v4 = Marker(
            id: "v4",
            image: UIImage(named: "v4")!,
            physicalWidth: 0.13,
            location: Location(coordinates: CGPoint(x: 7.69-1.145, y: 1.49+0.13/2), heading: 1.57, floor: floor1)
        )
        
        
        return [m0, m1, m2, m_r1, m_r2, m_r3, m_r4, v1, v2, v3, v4]
    }
    
    
    
    
// MARK: - ARVIEW MANAGER
    
    func addPointsToARView(arView: ARView, points: [Point]) {
        for point in points {
            let modelEntity = getPointEntity()
            modelEntity.position = SIMD3(x: point.x, y: 0, z: point.y)
            
            let anchorEntity = AnchorEntity(world: modelEntity.position)
            anchorEntity.addChild(modelEntity)
            arView.scene.addAnchor(anchorEntity)
            
            anchorEntities.append(anchorEntity)
        }
    }
    
    func addDestinationAnchorToARView(arView: ARView, goalPoint: Point) {
        let size: Float = 0.2
        let mesh = MeshResource.generateSphere(radius: size)
        let material = SimpleMaterial(color: .blue, isMetallic: false)
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        
        if let endAnchorEntity {
            DispatchQueue.main.async {
                arView.scene.removeAnchor(endAnchorEntity)
            }
            self.endAnchorEntity = nil
            print("End anchor removed.")
        }

        if let currentLocation {
            modelEntity.position = SIMD3(x: goalPoint.x - currentLocation.x, y: 0.5, z: goalPoint.y - currentLocation.y)
//            modelEntity.position = SIMD3(x: goalPoint.x, y: 0.5, z: goalPoint.y)
            let anchorEntity = AnchorEntity(world: modelEntity.position)
            anchorEntity.addChild(modelEntity)
            endAnchorEntity = anchorEntity
            arView.scene.addAnchor(anchorEntity)
        }
    }

    
    func removeAllAnchors(arView: ARView) {
        DispatchQueue.main.async {
            for anchor in self.anchorEntities {
                arView.scene.removeAnchor(anchor)
                print("removed: \(anchor)")
            }
            self.anchorEntities.removeAll()
            print("All anchors removed.")
        }
    }

    
    var pointEntityPool: [ModelEntity] = []
    
    func getPointEntity() -> ModelEntity {
        if let entity = pointEntityPool.popLast() {
            return entity
        } else {
            let size: Float = 0.05
            let mesh = MeshResource.generateSphere(radius: size)
            let material = SimpleMaterial(color: .red, isMetallic: false)
            return ModelEntity(mesh: mesh, materials: [material])
        }
    }
    
    func interpolateColor(from start: UIColor, to end: UIColor, fraction: CGFloat) -> UIColor {
        var startRed: CGFloat = 0
        var startGreen: CGFloat = 0
        var startBlue: CGFloat = 0
        var startAlpha: CGFloat = 0
        start.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        
        var endRed: CGFloat = 0
        var endGreen: CGFloat = 0
        var endBlue: CGFloat = 0
        var endAlpha: CGFloat = 0
        end.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
        
        let red = startRed + (endRed - startRed) * fraction
        let green = startGreen + (endGreen - startGreen) * fraction
        let blue = startBlue + (endBlue - startBlue) * fraction
        let alpha = startAlpha + (endAlpha - startAlpha) * fraction
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func addPointsToARViewWithGradient(arView: ARView, points: [Point], startPoint: Point, goalPoint: Point) {
        DispatchQueue.main.async { [self] in
            let startColor = UIColor.red
            let goalColor = UIColor.green

            let totalDistance = hypot(goalPoint.x - startPoint.x, goalPoint.y - startPoint.y)

            for point in points {
                let distanceFromStart = hypot(point.x - startPoint.x, point.y - startPoint.y)
                let fraction = distanceFromStart / totalDistance

                let color = self.interpolateColor(from: startColor, to: goalColor, fraction: CGFloat(fraction))

                let size: Float = 0.1
                let mesh = MeshResource.generateSphere(radius: size)
                let material = SimpleMaterial(color: color, isMetallic: false)
                let modelEntity = ModelEntity(mesh: mesh, materials: [material])

                
                let cameraPosition = arView.cameraTransform.translation
                
                let adjustedX = abs(startPoint.x - point.x)
                let adjustedZ = abs(startPoint.y - point.y)
                
                modelEntity.position = SIMD3(x: adjustedX, y: 0, z: adjustedZ)

                print(modelEntity.position)

                let anchorEntity = AnchorEntity(world: modelEntity.position)
                anchorEntity.addChild(modelEntity)
                arView.scene.addAnchor(anchorEntity)

                self.anchorEntities.append(anchorEntity)
            }
        }
    }



    
    
    
}


