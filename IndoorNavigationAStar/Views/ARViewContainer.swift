//
//  ARViewContainer.swift
//  IndoorNavigationAStar
//
//  Created by Ivan Coppola on 05/10/24.
//


import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    let arView: ARView // Pass ARView directly

    func makeUIView(context: Context) -> ARView {
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }
}

