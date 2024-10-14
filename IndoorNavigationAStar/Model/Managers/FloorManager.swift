//
//  FloorManager.swift
//  IndoorNavigationAStar
//
//  Created by Ivan Coppola on 14/10/24.
//


import Foundation
import IndoorNavigation

@available(iOS 13.0, *)
public class FloorManager {
    private var floors: [Floor] = []

    // Initialize the FloorManager by loading the floors from a JSON file
    public init(jsonFileName: String) {
        loadFloors(from: jsonFileName)
    }

    // Load floors from a JSON file
    private func loadFloors(from jsonFileName: String) {
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
            print("Failed to find JSON file.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            floors = try decoder.decode([Floor].self, from: data)
        } catch {
            print("Failed to decode JSON: \(error)")
        }
    }

    // Function to get endLocations and obstacles for a given floor ID
    public func getFloorData(for floorId: String) -> (endLocations: [Point], obstacles: [RectangleObstacle]?)? {
        guard let floor = floors.first(where: { $0.floorId == floorId }) else {
            print("No floor found with ID: \(floorId)")
            return nil
        }
        return (floor.endLocations, floor.obstacles)
    }
}
