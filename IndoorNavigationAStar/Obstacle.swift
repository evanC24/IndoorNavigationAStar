//
//  Obstacle.swift
//  IndoorNavigationAStar
//
//  Created by Ivan Coppola on 07/10/24.
//


import Foundation

struct Obstacle {
    let topLeft: Point
    let bottomRight: Point
    
    
    func contains(point: Point) -> Bool {
        return  point.x >= topLeft.x && point.x <= bottomRight.x &&
                point.y >= topLeft.y && point.y <= bottomRight.y
    }
}
