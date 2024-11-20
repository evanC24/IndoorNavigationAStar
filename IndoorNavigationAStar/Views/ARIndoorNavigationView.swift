//
//  ContentView.swift
//  IndoorNavigationAStar
//
//  Created by Ivan Coppola on 05/10/24.
//

import SwiftUI
import RealityKit

import SwiftUI
import RealityKit

import IndoorNavigation

struct ARIndoorNavigationView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var arView = ARView()
    
    var disableButton: Bool {
        return locationManager.currentLocation == nil
    }
    
    @State private var pathRecalculationTimer: Timer?
    
    @State private var bouncingValue = 0.8
    
    var body: some View {
        ZStack {
            
            ARViewContainer(arView: arView)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                if let map = locationManager.map {
                    MapView(
                        pathPoints: locationManager.originalPath ?? [],
                        endLocation: locationManager.endLocation,
                        currentLocation: locationManager.currentLocation,
                        obstacles: map.obstacles,
                        maxWidth: CGFloat(map.width),
                        maxHeight: CGFloat(map.height),
                        viewWidth: 200,
                        viewHeight: 200
                    )
                }
                
                Spacer()
                
                if locationManager.currentLocation != nil {
                    
                    if locationManager.originalPath != nil && !locationManager.originalPath!.isEmpty {
                        if locationManager.isArrived {
                            Image(systemName: "flag.checkered.circle" )
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.green)
                                .rotationEffect(.zero)
                                .padding()
                            Text(locationManager.isArrived ? "Destination arrived" : "")
                                .font(.title2)
                                .bold()
                        } else {
                            if let headingDifference = locationManager.headingDifference {
                                Image(systemName: "location.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.black)
                                    .rotationEffect(
                                        .radians(headingDifference + CGFloat.pi / 4)
                                    )
                                    .padding()
                                DirectionHint(headingDifference: headingDifference)
                                    .padding()
                            }
                        }

                    }

                } else {
                    StartNavigationView
                    Spacer()
                }
                
                HStack(alignment: .center) {
                    
                    Button("Reset", systemImage: "multiply.circle") {
                        locationManager.resetPath(arView: arView)
                        stopPathRecalculation()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .disabled(self.disableButton)
                    
                    Menu {
                        ForEach(locationManager.endLocations, id: \.self) { endLocation in
                            Button(endLocation.name ?? "Point located at (\(endLocation.x),\(endLocation.y))") {
                                locationManager.createPath(to: endLocation)
                                startPathRecalculation()
                            }
                        }
                    } label: {
                        Label("Start", systemImage: "figure.walk.departure")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(self.disableButton)
                }
                
            }
            .padding()
        }
        .onAppear {
            locationManager.startLocationUpdates(arView: arView)
            //            locationManager.showFloorMap(CGRect(x: 20, y: 60, width: 147, height: 223)) // Call the method here
        }
    }
}



// MARK: - TIMER

extension ARIndoorNavigationView {

    private func startPathRecalculation() {

        stopPathRecalculation()
        
        guard !locationManager.isArrived else {
            stopPathRecalculation()
            return
        }
        
        pathRecalculationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if let endLocation = locationManager.endLocation {
                
                locationManager.createPath(to: endLocation) // Recalculate path
                print("Path recalculated")
            }
        }
    }

    /// Stop path recalculation by invalidating the timer.
    private func stopPathRecalculation() {
        pathRecalculationTimer?.invalidate()
        pathRecalculationTimer = nil
    }
}


// MARK: - SubViews
extension ARIndoorNavigationView {
    var StartNavigationView: some View {
        VStack {
            Image(systemName: "camera.viewfinder")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("Start scanning saved markers to get your location")
                .bold()
        }
    }
}









//                        Text("Heading to origin: \(currentLocation.heading, specifier: "%.2f") radians")
//                        Text("Heading Difference: \(locationManager.headingDifference!, specifier: "%.2f") radians")
//                        Text("Proximity: \(locationManager.proximity, specifier: "%.2f")")
//                        Text("Building: \(locationManager.currentBuilding ?? "N/A")")
//                        Text("Floor: \(locationManager.currentFloor ?? "N/A")")
