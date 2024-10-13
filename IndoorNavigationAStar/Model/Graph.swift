////
////  Graph.swift
////  IndoorNavigationAStar
////
////  Created by Ivan Coppola on 05/10/24.
////
//
//import Foundation
//
//struct Graph {
//    let neighbors: (Point) -> [Point]
//    let cost: (Point, Point) -> Float
//    
////    func aStarSearch(start: Point, goal: Point, heuristic: (Point, Point) -> Float) -> ([Point: Point?], [Point: Float]) {
////        var frontier = PriorityQueue<Point>()
////        frontier.put(start, priority: 0)
////        
////        var cameFrom = [Point: Point?]()
////        var costSoFar = [Point: Float]()
////        
////        cameFrom[start] = nil
////        costSoFar[start] = 0
////        
////        while !frontier.isEmpty {
////            guard let current = frontier.get() else { break }
////            
////            if current == goal {
////                break
////            }
////            
////            for next in self.neighbors(current) {
////                if !next.isWalkable { continue }  // Skip non-walkable points (obstacles)
////                let newCost = costSoFar[current]! + self.cost(current, next)
////                if costSoFar[next] == nil || newCost < costSoFar[next]! {
////                    costSoFar[next] = newCost
////                    let priority = newCost + heuristic(goal, next)
////                    frontier.put(next, priority: priority)
////                    cameFrom[next] = current
////                }
////            }
////        }
////        
////        return (cameFrom, costSoFar)
////    }
//    func aStarSearch(start: Point, goal: Point, heuristic: (Point, Point) -> Float) -> ([Point: Point?], [Point: Float]) {
//            var frontier = PriorityQueue<Point>()
//            frontier.put(start, priority: 0)
//
//            var cameFrom = [Point: Point?]()
//            var costSoFar = [Point: Float]()
//            
//            cameFrom[start] = nil
//            costSoFar[start] = 0
//            
//            while !frontier.isEmpty {
//                guard let current = frontier.get() else { break }
//                
//                if current == goal {
//                    break
//                }
//                
//                for next in self.neighbors(current) {
//                    if !next.isWalkable { continue }  // Skip non-walkable points (obstacles)
//                    
//                    let newCost = costSoFar[current]! + self.cost(current, next)
//                    if costSoFar[next] == nil || newCost < costSoFar[next]! {
//                        costSoFar[next] = newCost
//                        let priority = newCost + heuristic(goal, next)
//                        frontier.put(next, priority: priority)
//                        cameFrom[next] = current
//                    }
//                }
//            }
//            
//            return (cameFrom, costSoFar)
//        }
//    
//    func nearestEdgeDistance(_ point: Point) -> Float {
//        var minDistance: Float = .greatestFiniteMagnitude
//        
//        for neighbor in self.neighbors(point) {
//            if !neighbor.isWalkable {
//                continue
//            }
//            
//            // Check if the neighbor is next to a non-walkable point (i.e., it is an edge)
//            for adjacent in self.neighbors(neighbor) {
//                if !adjacent.isWalkable {
//                    let distance = hypot(point.x - neighbor.x, point.y - neighbor.y)
//                    minDistance = min(minDistance, distance)
//                }
//            }
//        }
//        
//        return minDistance == .greatestFiniteMagnitude ? 0 : minDistance
//    }
//    
//    func heuristic(_ goal: Point, _ current: Point) -> Float {
//        let euclideanDistance = hypot(goal.x - current.x, goal.y - current.y)
//        let edgeDistance = nearestEdgeDistance(current)
//        
//        let alpha: Float = 0.3 // Weight for Euclidean distance
//        let beta: Float = 1 - alpha // Weight for edge distance
//        
//        return alpha * euclideanDistance + beta * edgeDistance
//    }
//}
//
//
//
//
////
////// A* Search using Point
////func aStarSearch( graph: Graph, start: Point, goal: Point, heuristic: (Point, Point) -> Float) -> ([Point: Point?], [Point: Float]) {
////    var frontier = PriorityQueue<Point>()
////    frontier.put(start, priority: 0)
////    
////    var cameFrom = [Point: Point?]()
////    var costSoFar = [Point: Float]()
////    
////    cameFrom[start] = nil
////    costSoFar[start] = 0
////    
////    while !frontier.isEmpty {
////        guard let current = frontier.get() else { break }
////        
////        if current == goal {
////            break
////        }
//////        let epsilon: Float = 0.5
//////        if abs(current.x - goal.x) < epsilon && abs(current.y - goal.y) < epsilon {
//////            break
//////        }
////        
////        for next in graph.neighbors(current) {
////            if !next.isWalkable { continue }  // Skip non-walkable points (obstacles)
////            
////            let newCost = costSoFar[current]! + graph.cost(current, next)
////            if costSoFar[next] == nil || newCost < costSoFar[next]! {
////                costSoFar[next] = newCost
//////                costSoFar.updateValue(newCost, forKey: next)
////                let priority = newCost + heuristic(goal, next)
////                frontier.put(next, priority: priority)
////                cameFrom[next] = current
////            }
////        }
////    }
////    
////    return (cameFrom, costSoFar)
////}
//
//func reconstructPath(cameFrom: [Point: Point?], start: Point, goal: Point) -> [Point] {
//    var current = goal
//    var path = [Point]()
//    
//    // Backtrack from goal to start
//    while current != start {
//        path.append(current)
//        if let previous = cameFrom[current] {
//            current = previous!
//        } else {
//            // No valid path exists
//            print("No path found!")
//            return []
//        }
//    }
//    
//    // Add the start point at the end
////    path.append(start)
//    
//    // Since we backtracked, we need to reverse the path
//    return path.reversed()
//}
//
//
//
//
//
//
//
//
//
//
//
