//
//  LinedBackground.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LinedBackground: View {
    let size: CGSize
    var body: some View {
        VStack(spacing: .zero) {
            Lines(color: .clokBG)
            Lines(color: Color(UIColor.systemBackground))
            Lines(color: .clokBG)
        }
    }
    
    func Lines(color: Color) -> some View {
        ForEach(0..<evenDivisions(for: size), id: \.self) { _ in
            Rectangle().foregroundColor(color)
            Divider()
        }
    }
    
}