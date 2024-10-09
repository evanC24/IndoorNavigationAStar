//
//  Map.swift
//  IndoorNavigationAStar
//
//  Created by Ivan Coppola on 08/10/24.
//

import Foundation

struct Map {
    var width: Float
    var height: Float
    var obstacles: [Obstacle]
    var step: Float
    
    var points: [[Point]] = []

    mutating func generatePoints() {
        var y: Float = 0
        while y <= height {
            var row = [Point]()
            var x: Float = 0
            while x <= width {
                let roundedX = roundToDecimal(x, places: 2)
                let roundedY = roundToDecimal(y, places: 2)
                
                // Check if the point is not inside any obstacle using the contains method.
                let isWalkable = !obstacles.contains { $0.contains(point: Point(x: roundedX, y: roundedY)) }
                
                row.append(Point(x: roundedX, y: roundedY, heading: nil, isWalkable: isWalkable))
                x += step
            }
            points.append(row)
            y += step
        }
    }

    init(width: Float, height: Float, obstacles: [Obstacle], step: Float = 0.1) {
        self.width = width
        self.height = height
        self.obstacles = obstacles
        self.step = step
        self.generatePoints()
    }

    func getNeighbors(point: Point) -> [Point] {
        let xIndex = Int(round(point.x / step))
        let yIndex = Int(round(point.y / step))

        var neighbors = [Point]()

        let width = points[0].count
        let height = points.count

        let bufferDistance: Float = 0.2

        func isPointTooCloseToObstacle(_ point: Point) -> Bool {
            return obstacles.contains { obstacle in
                let closestX = max(obstacle.topLeft.x, min(point.x, obstacle.bottomRight.x))
                let closestY = max(obstacle.topLeft.y, min(point.y, obstacle.bottomRight.y))
                
                let distance = euclideanDistance(Point(x: closestX, y: closestY), point)
                return distance < bufferDistance
            }
        }


        for neighbor in [(0, -1), (0, 1), (-1, 0), (1, 0)] {
            let newYIndex = yIndex + neighbor.0
            let newXIndex = xIndex + neighbor.1

            if newYIndex >= 0, newYIndex < height, newXIndex >= 0, newXIndex < width {
                let potentialNeighbor = points[newYIndex][newXIndex]
                if potentialNeighbor.isWalkable && !isPointTooCloseToObstacle(potentialNeighbor) {
                    neighbors.append(potentialNeighbor)
                }
            }
        }

        return neighbors
    }
    
    func findPath(start: Point, goal: Point) -> [Point] {
        let graph = Graph(
            neighbors: { return self.getNeighbors(point: $0) },
            cost: { return euclideanDistance($0, $1) }
        )
        
        let (cameFrom, _) = graph.aStarSearch(start: start, goal: goal, heuristic: euclideanDistance)
        
        return reconstructPath(cameFrom: cameFrom, start: start, goal: goal)
    }
}


//struct Map {
//    var width: Float
//    var height: Float
//    var obstacles: [(Float, Float)]
//    var step: Float
//    
//    var points: [[Point]] = []
//
//    mutating func generatePoints() {
//        var y: Float = 0
//        while y <= height {
//            var row = [Point]()
//            var x: Float = 0
//            while x <= width {
//                let roundedX = roundToDecimal(x, places: 2)
//                let roundedY = roundToDecimal(y, places: 2)
//                let isWalkable = !obstacles.contains { $0.0 == roundedX && $0.1 == roundedY }
//                row.append(Point(x: roundedX, y: roundedY, heading: nil, isWalkable: isWalkable))
//                x += step
//            }
//            points.append(row)
//            y += step
//        }
//    }
//
////    mutating func generatePoints() {
////        var y: Float = 0
////        while y <= height {
////            var row = [Point]()
////            var x: Float = 0
////            while x <= width {
////                let roundedX = roundToDecimal(x, places: 2)
////                let roundedY = roundToDecimal(y, places: 2)
////                let isWalkable = !obstacles.contains { $0.0 == roundedX && $0.1 == roundedY }
////                row.append(Point(x: roundedX, y: roundedY, heading: nil, isWalkable: isWalkable))
////                if step > 0.1 && x + step > width {
////                    x = width
////                    break
////                }
////            }
////            points.append(row)
////            if step > 0.1 && y + step > height {
////                y = height
////                break
////            }
////        }
////    }
//
//    init(width: Float, height: Float, obstacles: [(Float, Float)], step: Float = 0.1) {
//        self.width = width
//        self.height = height
//        self.obstacles = obstacles
//        self.step = step
//        self.generatePoints()
//    }
//
//    
//    func getNeighbors(point: Point) -> [Point] {
//        let xIndex = Int(round(point.x / step))
//        let yIndex = Int(round(point.y / step))
//
//        var neighbors = [Point]()
//
//        let width = points[0].count
//        let height = points.count
//
//        let bufferDistance: Float = 0.3
//
//        func isPointTooCloseToObstacle(_ point: Point) -> Bool {
//            return obstacles.contains { obstacle in
//                let distance = euclideanDistance(Point(x: obstacle.0, y: obstacle.1), point)
//                return distance < bufferDistance
//            }
//        }
//
//        for neighbor in [(0, -1), (0, 1), (-1, 0), (1, 0)] {
//            let newYIndex = yIndex + neighbor.0
//            let newXIndex = xIndex + neighbor.1
//
//            if newYIndex >= 0, newYIndex < height, newXIndex >= 0, newXIndex < width {
//                let potentialNeighbor = points[newYIndex][newXIndex]
//                if potentialNeighbor.isWalkable && !isPointTooCloseToObstacle(potentialNeighbor) {
//                    neighbors.append(potentialNeighbor)
//                }
//            }
//        }
//
//        return neighbors
//    }
//
//
//    
//    func findPath( start: Point,
//                   goal: Point) -> [Point] {
//
//        let graph = Graph( neighbors: { return self.getNeighbors(point: $0) },
//                           cost: { return euclideanDistance($0, $1)})
//        
//        let (cameFrom, _) = graph.aStarSearch(start: start, goal: goal, heuristic: euclideanDistance)
//        
//        return reconstructPath(cameFrom: cameFrom, start: start, goal: goal)
//    }
//    
//}
