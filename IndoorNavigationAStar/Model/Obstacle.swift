import Foundation


struct Obstacle {
    let topLeft: Point
    let bottomRight: Point
    
    init(topLeft: Point, bottomRight: Point) {
        self.topLeft = topLeft
        self.bottomRight = bottomRight
    }
    
    func contains(point: Point) -> Bool {
        return point.x >= topLeft.x && point.x <= bottomRight.x &&
               point.y >= topLeft.y && point.y <= bottomRight.y
    }
}


//struct Obstacle {
//    private let topLeft: Point
//    private let bottomRight: Point
//    private let step: Float = 0.1
//    
//    lazy var points: [(Float, Float)] = {
//        var points: [(Float, Float)] = []
//        var y: Float = topLeft.y
//        while y <= bottomRight.y {
//            var x: Float = topLeft.x
//            while x <= bottomRight.x {
//                let roundedX = roundToDecimal(x, places: 2)
//                let roundedY = roundToDecimal(y, places: 2)
//                points.append((roundedX, roundedY))
//                x += step
//            }
//            y += step
//        }
//        return points
//    }()
//    
//    init(topLeft: Point, bottomRight: Point) {
//        self.topLeft = topLeft
//        self.bottomRight = bottomRight
//    }
//    
//    func contains(point: Point) -> Bool {
//        return point.x >= topLeft.x && point.x <= bottomRight.x &&
//               point.y >= topLeft.y && point.y <= bottomRight.y
//    }
//}
