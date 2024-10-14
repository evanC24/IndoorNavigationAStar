//
//  ContentView.swift
//  IndoorNavigationAStar
//
//  Created by Ivan Coppola on 05/10/24.
//

import SwiftUI
import RealityKit

import SwiftUI
import RealityKit

struct ARIndoorNavigationView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var arView = ARView()
    
    var body: some View {
        ZStack {
            
            ARViewContainer(arView: arView)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Spacer()
                
                if let currentLocation = locationManager.currentLocation {
                    
                    //Text("\(calculateBearing(from: locationManager.currentLocation!, to: path.first!))°")
                    
//                    LocationMarkerView(isArrived: locationManager.isArrived, headingDifference: locationManager.headingDifference)
                    
                    if locationManager.pathToVisit != nil && !locationManager.pathToVisit!.isEmpty || locationManager.isArrived {
                        Image(systemName: locationManager.isArrived ? "mappin.and.ellipse.circle" : "location.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(locationManager.isArrived ? .green : .black)
                            .rotationEffect(
                                locationManager.isArrived ? .zero : .radians((locationManager.headingDifference ?? .zero) + CGFloat.pi / 2))
//                            .animation(.default, value: locationManager.headingDifference ?? .zero)
//                            .animation(.easeOut, value: (locationManager.headingDifference  ?? .zero) + CGFloat.pi / 2 )
                            .padding()
                        if let nextPoint = locationManager.nextPoint {
                            Text(String(format: "Next Point: [%.2f, %.2f]", nextPoint.x, nextPoint.y))
                        }
                    }

                    
                    Text(String(format: "[%.2f, %.2f], heading: %.2f", currentLocation.x, currentLocation.y, currentLocation.heading))
                        .bold()
                        .font(.title3)
                    
                    
                    if locationManager.isArrived {
                        Text("Arrived at destination")
                            .bold()
                    } else {
                        Button("Recenter", systemImage: "location.viewfinder") {
                            locationManager.centerToUserPosition()
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    VStack(alignment: .leading) {
//                        Text("Heading to origin: \(currentLocation.heading, specifier: "%.2f") radians")
//                        Text("Heading Difference: \(locationManager.headingDifference!, specifier: "%.2f") radians")
//                        Text("Proximity: \(locationManager.proximity, specifier: "%.2f")")
//                        Text("Building: \(locationManager.currentBuilding ?? "N/A")")
//                        Text("Floor: \(locationManager.currentFloor ?? "N/A")")
                    }
                    .padding()
                    
                } else {
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .frame(width: 100, height: 100)
                    
                    Text("Start scanning saved markers to get your location")
                        .bold()
                    Spacer()
                }
                
                
                HStack(alignment: .center) {
                    
                    Button("Reset", systemImage: "multiply.circle") {
                        locationManager.resetPath(arView: arView)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .disabled(locationManager.currentLocation == nil || locationManager.isArrived)
                    
                    Menu {
                        ForEach(locationManager.endLocations, id: \.self) { endLocation in
                            Button(endLocation.name ?? "Point located at (\(endLocation.x),\(endLocation.y))") {
                                locationManager.createPath(to: endLocation)
                            }
                        }
                    } label: {
                        Label("Start", systemImage: "figure.walk.departure")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .disabled(locationManager.currentLocation == nil || locationManager.isArrived)
                }
                
            }
            .padding()
        }
        .onAppear {
            locationManager.startLocationUpdates(arView: arView)
            //            locationManager.showFloorMap(CGRect(x: 20, y: 60, width: 147, height: 223)) // Call the method here
        }
    }
}



//                        Text("Heading to origin: \(currentLocation.heading, specifier: "%.2f") radians")
//                        Text("Heading Difference: \(locationManager.headingDifference!, specifier: "%.2f") radians")
//                        Text("Proximity: \(locationManager.proximity, specifier: "%.2f")")
//                        Text("Building: \(locationManager.currentBuilding ?? "N/A")")
//                        Text("Floor: \(locationManager.currentFloor ?? "N/A")")
