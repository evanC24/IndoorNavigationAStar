//
//  Point.swift
//  IndoorNavigationAStar
//
//  Created by Ivan Coppola on 05/10/24.
//

import Foundation

struct Point: Hashable {
    private var _x: Float  // Valore effettivo di x
    private var _y: Float  // Valore effettivo di y
    private var _heading: Float?  // Valore effettivo di heading
    var isWalkable: Bool  // Indicates if the point is walkable
    
    // Tolerance for comparing floating-point coordinates
    private static let epsilon: Float = 0.1
    
    var x: Float {
        return round(_x * 10) / 10  // Arrotonda automaticamente ai decimi di metro
    }
    
    var y: Float {
        return round(_y * 10) / 10  // Arrotonda automaticamente ai decimi di metro
    }
    
    var heading: Float {
        return round((_heading ?? 0) * 10) / 10  // Arrotonda automaticamente ai decimi di metro
    }
    
    init(x: Float, y: Float, heading: Float? = nil, isWalkable: Bool = true) {
        self._x = x
        self._y = y
        self._heading = heading
        self.isWalkable = isWalkable
    }
    
    var description: String {
        return "(\(x), \(y), \(heading))"
    }
    
    // Custom equality using epsilon to account for floating-point precision
    static func == (lhs: Point, rhs: Point) -> Bool {
//        return abs(lhs.x - rhs.x) < epsilon && abs(lhs.y - rhs.y) < epsilon
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    // Hash function must also handle floating-point precision
    func hash(into hasher: inout Hasher) {
        hasher.combine(Int(round(_x * 10)))
        hasher.combine(Int(round(_y * 10)))
    }
}
