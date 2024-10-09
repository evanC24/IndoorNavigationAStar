//
//  LocationMarkerView.swift
//  IndoorNavigationAStar
//
//  Created by Ivan Coppola on 08/10/24.
//

//import Foundation
//import SwiftUI
//
//
//struct LocationMarkerView: View {
//    let isArrived: Bool
//    let headingDifference: CGFloat?
//    let rotationAngle = (locationManager.headingDifference ?? 0) + CGFloat.pi / 2
//    
//    var body: some View {
//        Image(systemName: isArrived ? "mappin.circle" : "location.fill")
//            .tint(isArrived ? .green : .black)
//            .resizable()
//            .frame(width: 100, height: 100)
//            .rotationEffect(isArrived ? .zero : .radians(rotationAngle))
//            .animation(.easeInOut(duration: 0.5), value: locationManager.headingDifference ?? 0)
//            .padding()
//    }
//}
