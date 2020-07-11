//
//  SpiralControls.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.14.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct SpiralControls: View {
    var body: some View {
        VStack(spacing: .zero) {
            TimeStripView()
            Spacer()
            HStack {
                FilterStack()
                Spacer()
            }
            WeekButtons()
                /// don't pad vertically, week button already does that
                .padding([.leading, .trailing], buttonPadding)
        }
    }
}
