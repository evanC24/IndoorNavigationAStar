//
//  Graph.swift
//  IndoorNavigationAStar
//
//  Created by Ivan Coppola on 05/10/24.
//

import Foundation

struct Graph {
    let neighbors: (Point) -> [Point]
    let cost: (Point, Point) -> Float
    
    // A* Search using Point
    func aStarSearch(start: Point, goal: Point, heuristic: (Point, Point) -> Float) -> ([Point: Point?], [Point: Float]) {
        var frontier = PriorityQueue<Point>()
        frontier.put(start, priority: 0)
        
        var cameFrom = [Point: Point?]()
        var costSoFar = [Point: Float]()
        
        cameFrom[start] = nil
        costSoFar[start] = 0
        
        while !frontier.isEmpty {
            guard let current = frontier.get() else { break }
            
            if current == goal {
                break
            }
    //        let epsilon: Float = 0.5
    //        if abs(current.x - goal.x) < epsilon && abs(current.y - goal.y) < epsilon {
    //            break
    //        }
            
            for next in self.neighbors(current) {
                if !next.isWalkable { continue }  // Skip non-walkable points (obstacles)
                
                let newCost = costSoFar[current]! + self.cost(current, next)
                if costSoFar[next] == nil || newCost < costSoFar[next]! {
                    costSoFar[next] = newCost
    //                costSoFar.updateValue(newCost, forKey: next)
                    let priority = newCost + heuristic(goal, next)
                    frontier.put(next, priority: priority)
                    cameFrom[next] = current
                }
            }
        }
        
        return (cameFrom, costSoFar)
    }
}
//
//// A* Search using Point
//func aStarSearch( graph: Graph, start: Point, goal: Point, heuristic: (Point, Point) -> Float) -> ([Point: Point?], [Point: Float]) {
//    var frontier = PriorityQueue<Point>()
//    frontier.put(start, priority: 0)
//    
//    var cameFrom = [Point: Point?]()
//    var costSoFar = [Point: Float]()
//    
//    cameFrom[start] = nil
//    costSoFar[start] = 0
//    
//    while !frontier.isEmpty {
//        guard let current = frontier.get() else { break }
//        
//        if current == goal {
//            break
//        }
////        let epsilon: Float = 0.5
////        if abs(current.x - goal.x) < epsilon && abs(current.y - goal.y) < epsilon {
////            break
////        }
//        
//        for next in graph.neighbors(current) {
//            if !next.isWalkable { continue }  // Skip non-walkable points (obstacles)
//            
//            let newCost = costSoFar[current]! + graph.cost(current, next)
//            if costSoFar[next] == nil || newCost < costSoFar[next]! {
//                costSoFar[next] = newCost
////                costSoFar.updateValue(newCost, forKey: next)
//                let priority = newCost + heuristic(goal, next)
//                frontier.put(next, priority: priority)
//                cameFrom[next] = current
//            }
//        }
//    }
//    
//    return (cameFrom, costSoFar)
//}

// Heuristic function (Euclidean distance between points)
func euclideanDistance(_ a: Point, _ b: Point) -> Float {
    let dx = a.x - b.x
    let dy = a.y - b.y
    return sqrt(dx * dx + dy * dy)
}

func reconstructPath(cameFrom: [Point: Point?], start: Point, goal: Point) -> [Point] {
    var current = goal
    var path = [Point]()
    
    // Backtrack from goal to start
    while current != start {
        path.append(current)
        if let previous = cameFrom[current] {
            current = previous!
        } else {
            // No valid path exists
            print("No path found!")
            return []
        }
    }
    
    // Add the start point at the end
//    path.append(start)
    
    // Since we backtracked, we need to reverse the path
    return path.reversed()
}











