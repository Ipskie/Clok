//
//  DayStrip.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

fileprivate let labelOffset = CGFloat(-10)
fileprivate let labelPadding = CGFloat(3)

/// One vertical strip of bars representing 1 day in the larger graph
struct NewDayStrip: View {
    
    @EnvironmentObject var model: NewGraphModel
    @Environment(\.namespace) var namespace
    
    let entries: [TimeEntry]
    let midnight: Date
    let terms: SearchTerms
    let animationInfo: (row: Int, col: TimeInterval)

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(entries, id: \.id) { entry in
                    DayRect(
                        entry: entry,
                        size: geo.size,
                        midnight: midnight
                    )
                        .offset(y: CGFloat((entry.start - midnight) / .day) * geo.size.height)
                        .opacity(entry.matches(terms) ? 1 : 0.25)
                        .onTapGesture {
                            withAnimation {
                                model.selected = NamespaceModel(
                                    entry: entry,
                                    row: animationInfo.row,
                                    col: animationInfo.col
                                )
                            }
                        }
                        .matchedGeometryEffect(
                            id: NamespaceModel(
                                entry: entry,
                                row: animationInfo.row,
                                col: animationInfo.col
                            ),
                            in: namespace,
                            anchor: .bottomTrailing
                        )
                }
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height,
                        alignment: .top
                    )
                
                /// show current time in `calendar` mode
                if midnight == Date().midnight {
                    NewCurrentTimeIndicator(height: geo.size.height)
                        .frame(
                            width: geo.size.width,
                            height: geo.size.height,
                            alignment: .top
                        )
                    NewRunningEntryView(terms: terms)
                }
            }
        }
    }
}
