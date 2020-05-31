//
//  EntrySpiral.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.05.13.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntrySpiral: View {
    @ObservedObject var entry:TimeEntry = TimeEntry()
    @EnvironmentObject var listRow: ListRow
    @State private var scale:CGFloat = 1
    @State private var bright:Double = 0.0
    
    var body: some View {
        ZStack{
            Spiral(theta1: entry.startTheta, theta2: entry.endTheta)
                // fill in with the provided color, or black by default
                // TODO: accomodate dark mode with an adaptive color here
                .fill(entry.project_hex_color)
                
            Spiral(theta1: entry.startTheta, theta2: entry.endTheta)
            // fill in with the provided color, or black by default
            // TODO: accomodate dark mode with an adaptive color here
                .stroke(entry.project_hex_color, style: StrokeStyle(
                lineWidth: stroke_weight,
                lineCap: .round,
                lineJoin: .round,
                miterLimit: 0,
                dash: [],
                dashPhase: 0)
            )
            
        }
        .gesture(TapGesture().onEnded(){_ in
            /// pass selection to global variable
            self.listRow.entry = self.entry
            
            /// brief bounce animation
            self.scale += CGFloat(1 / self.entry.endTheta.radians)
            self.bright += 0.25
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.scale = 1
                self.bright = 0
            }
            
        })
        .scaleEffect(scale)
        .brightness(bright)
        .animation(.linear(duration: 0.25))
        
    }
    
    init (_ entry:TimeEntry, zeroTo zeroDate:Date) {
        self.entry = entry
        self.entry.zero(zeroDate)
    }
}

struct EntrySpiral_Previews: PreviewProvider {
    static var previews: some View {
        EntrySpiral(
            TimeEntry(),
            zeroTo: Date()
        )
    }
}
