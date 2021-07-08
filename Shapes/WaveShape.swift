//
//  WaveShape.swift
//  GreenBuddy
//
//  Created by O'Ryan Hampton on 11/3/20.
//  Copyright © 2020 O'Ryan Hampton. All rights reserved.
//

import SwiftUI

struct WaveShape: Shape {
    var yOffset: CGFloat = 0.5
    
    var animatableData: CGFloat {
        get {
            return yOffset
        }
        set {
            yOffset = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path{
        var path = Path()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        //curve at bottom
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.maxY),
                      control1: CGPoint(x: rect.maxX * 0.75, y: rect.maxY - (rect.maxY * yOffset)),
                      control2: CGPoint(x: rect.maxX * 0.25, y: rect.maxY + (rect.maxY * yOffset)))
        path.closeSubpath()
        return path
    }
}

struct WaveShape_Previews: PreviewProvider {
    var change = true
    static var previews: some View {
        WaveShape(yOffset: 0.7)
            .fill(Color(#colorLiteral(red: 0.4627109766, green: 0.6951671243, blue: 0.6798613667, alpha: 1)))
            .frame(height: 200)
            .shadow(radius: 4)
            .animation(Animation.easeOut(duration: 1.5).repeatForever(autoreverses: true))
            .padding(10)
        Button("Animate"){
            
        }
    }
}
