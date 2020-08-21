//
//  EntryRect.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 21/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryRect: View {
    
    let range: DateRange
    let size: CGSize
    let midnight: Date
    let castFwrd: TimeInterval
    let castBack: TimeInterval
    let days: TimeInterval
    
    /// determines what proportion of available horizontal space to consume
    private let thicc = CGFloat(0.8)
    private let cornerScale = CGFloat(1.0/18.0)
    
    var body: some View {
        RoundedRectangle(cornerRadius: size.width * cornerScale) /// adapt scale to taste
            .frame(
                width: size.width * thicc,
                height: height
            )
    }
    
    /**
     Calculate the appropriate height for a time entry.
     */
    var height: CGFloat {
        let start = max(range.start, midnight - castBack)
        let end = min(range.end, midnight + castFwrd)
        return size.height * CGFloat((end - start) / (.day * days))
    }
}
