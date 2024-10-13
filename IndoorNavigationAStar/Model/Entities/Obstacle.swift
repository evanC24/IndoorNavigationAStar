//import Foundation
//
//
//protocol Obstacle: Identifiable, Equatable {
//    func contains(point: Point) -> Bool
//    func getClosestEdgePoint(of point: Point) -> Point
//}
//
//
//class RectangleObstacle: Obstacle {
//    
//    let id: UUID = UUID()
//    let topLeft: Point
//    let bottomRight: Point
//    private let offset: Float = 0.2
//    
//    init(topLeft: Point, bottomRight: Point) {
//        self.topLeft = topLeft
//        self.bottomRight = bottomRight
//    }
//    
//    func contains(point: Point) -> Bool {
//        return  point.x >= topLeft.x - offset && point.x <= bottomRight.x + offset &&
//                point.y >= topLeft.y - offset && point.y <= bottomRight.y + offset
//    }
//    
//    static func == (lhs: RectangleObstacle, rhs: RectangleObstacle) -> Bool {
//        return  lhs.contains(point: rhs.topLeft) && lhs.contains(point: rhs.bottomRight) ||
//        rhs.contains(point: lhs.topLeft) && rhs.contains(point: lhs.bottomRight)
//    }
//    
//    func getClosestEdgePoint(of point: Point) -> Point {
//        let closestX = max(self.topLeft.x, min(point.x, self.bottomRight.x))
//        let closestY = max(self.topLeft.y, min(point.y, self.bottomRight.y))
//        return Point(x: closestX, y: closestY)
//    }
//    
//}
//
//class Table: RectangleObstacle {
//    
//}
//
//class Wall: RectangleObstacle {
//    
//}
//
//
////struct Obstacle {
////    private let topLeft: Point
////    private let bottomRight: Point
////    private let step: Float = 0.1
////    
////    lazy var points: [(Float, Float)] = {
////        var points: [(Float, Float)] = []
////        var y: Float = topLeft.y
////        while y <= bottomRight.y {
////            var x: Float = topLeft.x
////            while x <= bottomRight.x {
////                let roundedX = roundToDecimal(x, places: 2)
////                let roundedY = roundToDecimal(y, places: 2)
////                points.append((roundedX, roundedY))
////                x += step
////            }
////            y += step
////        }
////        return points
////    }()
////    
////    init(topLeft: Point, bottomRight: Point) {
////        self.topLeft = topLeft
////        self.bottomRight = bottomRight
////    }
////    
////    func contains(point: Point) -> Bool {
////        return point.x >= topLeft.x && point.x <= bottomRight.x &&
////               point.y >= topLeft.y && point.y <= bottomRight.y
////    }
////}
