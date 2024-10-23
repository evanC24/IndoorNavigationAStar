//
//  DirectionHint.swift
//  IndoorNavigationAStar
//
//  Created by Ivan Coppola on 23/10/24.
//

import SwiftUI

struct DirectionHint: View {
    
    var headingDifference: CGFloat
    
    var body: some View {
        HStack {
            Text("Turn")
                .font(.title)
                .bold()
            Image(systemName: getArrowIcon(for: headingDifference))
                .font(.title)
        }
    }
    
    func getArrowIcon(for headingDifference: CGFloat) -> String {
        switch headingDifference {
        case -CGFloat.pi / 4..<CGFloat.pi / 4: // -45° to 45° (in radians)
            return "arrowshape.right.circle" // Forward
        case CGFloat.pi / 4..<3 * CGFloat.pi / 4: // 45° to 135°
            return "arrowshape.down.circle" // Right turn
        case -3 * CGFloat.pi / 4..<(-CGFloat.pi / 4): // -135° to -45°
            return "arrowshape.up.circle" // Left turn
        default:
            return "arrowshape.left.circle" // Backward or U-turn
        }
    }


}

#Preview {
    DirectionHint(headingDifference: 0)
}
