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

import IndoorNavigation

struct ARIndoorNavigationView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var arView = ARView()
    
    var disableButton: Bool {
        return locationManager.currentLocation == nil
    }
    
    @State private var bouncingValue = 0.8
    
    var body: some View {
        ZStack {
            
            ARViewContainer(arView: arView)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                if let map = locationManager.map {
                    MapView(
                        pathPoints: locationManager.originalPath ?? [],
                        endLocation: locationManager.endLocation,
                        currentLocation: locationManager.currentLocation,
                        obstacles: map.obstacles,
                        maxWidth: CGFloat(map.width),
                        maxHeight: CGFloat(map.height),
                        viewWidth: 200,
                        viewHeight: 200
                    )
                }
                
                Spacer()
                
                if locationManager.currentLocation != nil {
                    
                    if locationManager.originalPath != nil && !locationManager.originalPath!.isEmpty {
                        if locationManager.isArrived {
                            Image(systemName: "flag.checkered.circle" )
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.green)
                                .rotationEffect(.zero)
    //                            .animation(.default, value: locationManager.headingDifference ?? .zero)
    //                            .animation(.easeOut, value: (locationManager.headingDifference  ?? .zero) )
                                .padding()
                            Text(locationManager.isArrived ? "Destination arrived" : "")
                                .font(.title2)
                                .bold()
                        } else {
                            if let headingDifference = locationManager.headingDifference {
                                Image(systemName: "location.fill")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.black)
                                    .rotationEffect(
                                        .radians(headingDifference + CGFloat.pi / 4)
                                    )
        //                            .animation(.default, value: locationManager.headingDifference ?? .zero)
        //                            .animation(.easeOut, value: (locationManager.headingDifference  ?? .zero) )
                                    .padding()
                                DirectionHint(headingDifference: headingDifference)
                                    .padding()
                            }
                        }

//                        if let nextPoint = locationManager.nextPoint {
//                            Text(String(format: "Next Point: [%.2f, %.2f]", nextPoint.x, nextPoint.y))
//                        }
                    }
                    
//                    if locationManager.isArrived {
//                        VStack {
//                            Image(systemName: "flag.checkered.circle")
//                                .resizable()
//                                .frame(width: 100, height: 100)
//                                .foregroundColor(.green)
//                                .scaleEffect(bouncingValue)
//                                .animation(.spring(duration: 2, bounce: 1), value: bouncingValue)
//                                .padding()
//                            Text("Destination arrived")
//                                .font(.title2)
//                                .bold()
//                        }
//                        Spacer()
//                    }
                } else {
                    Image(systemName: "camera.viewfinder")
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
                    .disabled(self.disableButton)
                    
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
                    .disabled(self.disableButton)
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
