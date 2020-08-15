//
//  LineGraph.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct LineGraph: View {
    
    @EnvironmentObject var zero: ZeroDate
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var model: GraphModel
    let dayHeight: CGFloat     /// visual height for 1 day
    
    var body: some View {
        /// check whether the provided time entry coincides with a particular *date* range
        /// if our entry ends before the interval even began
        /// or started after the interval finished, it cannot possibly fall coincide
        HStack(spacing: .zero) {
            /// use date enum so SwiftUI can identify horizontal swipes without redrawing everything
            ForEach(
                Array(stride(from: zero.start, to: zero.end, by: .day)),
                id: \.timeIntervalSince1970
            ) { midnight in
                Divider()
                DayStrip(
                    entries: entries(midnight: midnight),
                    midnight: midnight,
                    terms: data.terms
                )
                .transition(zero.slideOver)
                .frame(height: dayHeight * CGFloat(model.days))
            }
        }
        /// NOTE: apply lined background to whole stack, NOT individual `DayStrip`!
        .background(LinedBackground(divisions: evenDivisions(for: dayHeight)))
        .drawingGroup()
    }
    
    /// filter & sort time entries for this day
    /// the day begins at provided `midnight`
    func entries(midnight: Date) -> [TimeEntry] {
        switch model.mode {
        case .calendar: return data.entries
            .filter{$0.end > midnight - model.castBack}
            .filter{$0.start < midnight + model.castFwrd}
            /// chronological sort
            .sorted{$0.start < $1.start}
        case .graph: return data.entries
            .filter{$0.end > midnight - model.castBack}
            .filter{$0.start < midnight + model.castFwrd}
            /// use Search sort, which prioritizes selected Projects
            .sorted{data.terms.projectSort(p0: $0.wrappedProject, p1: $1.wrappedProject)}
        }
    }
}
