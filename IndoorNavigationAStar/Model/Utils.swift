////
////  Utils.swift
////  IndoorNavigationAStar
////
////  Created by Ivan Coppola on 08/10/24.
////
//
//import Foundation
//
//func roundToDecimal(_ number: Float, places: Int) -> Float {
//    let divisor = pow(10.0, Float(places))
//    return (number * divisor).rounded() / divisor
//}
//
//func radiansToDegrees(_ radians: Float) -> Float {
//    return radians * (180.0 / Float.pi)
//}
//
//
//func normalizeAngleToPi(_ angle: Float) -> Float {
//    var normalizedAngle = angle.truncatingRemainder(dividingBy: 2 * Float.pi)
//    if normalizedAngle > Float.pi {
//        normalizedAngle -= 2 * Float.pi
//    } else if normalizedAngle < -Float.pi {
//        normalizedAngle += 2 * Float.pi
//    }
//    return normalizedAngle
//}
//
//func calculateBearing(from start: Point, to end: Point) -> Float {
//    let deltaX = end.x - start.x
//    let deltaY = end.y - start.y
//    return atan2(deltaY, deltaX)
//}
//
//func euclideanDistance(from start: Point, to end: Point) -> Float {
//    let deltaX = end.x - start.x
//    let deltaY = end.y - start.y
//    return hypot(deltaX, deltaY)
//}
//
//func findClosestPathPoint(from path: [Point], to currentLocation: Point) -> Point? {
//    guard !path.isEmpty else { return nil }
//    
//    return path.min(by: { euclideanDistance(from: $0, to: currentLocation) < euclideanDistance(from: $1, to: currentLocation) })
//}
