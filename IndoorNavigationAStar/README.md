# Indoor AR AStar Pathfinding Algorithm

Swift AR project developed for Mobile Development course '23/'24 at University of Milan (UniMi).

## Project Description

The objective of this project is to implement a Augmented Reality pathfinding algorithm in Swift, using a grid structure to represent a search space. The algorithm is designed to explore different movement possibilities and find the optimal path between a starting point and a destination within the grid. The current user indoor position is retrieved by an external library, developed in the preovious years by an alumni of the course. This app is an upgrade of PositioningLibrary demo app developed by Rosario Galioto.
- PositioningLibrary: https://github.com/tirannosario/PositioningLibrary
- Demo app: https://github.com/tirannosario/TestPositioningLibrary

## Key Features

- **Pathfinding Algorithm**: Identifies the optimal path between two points in a grid using AStar algorithm.
- **Grid Configuration**: The grid is customizable in terms of size (width, height).
- **Collision avoidance**: Obstacles (walls, tables, ecc...) can be placed to increase the complexity of the search and avoid any collision.
- **Customizable Search Parameters**: Users can modify the algorithm's parameters, such as the maximum step and offset distance from any obstacles.
- **Dynamic Path Visualization**: Graphical representation, such as an directional arrow, can guide the user towards the goal location suggesting the heading and the direction to get there
  
## Requirements

- **Language**: Swift
- **Platform**: iOS/macOS
- **Libraries Used**: PositioningLibrary.

## Project Structure


## Usage



## Author

- **Author Name**: Ivan Coppola
- **University**: University of Milan
- **Course**: MobiDev

## License

This project is distributed under the MIT License.

---
