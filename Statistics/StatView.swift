//
//  StatView.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.14.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct StatView: View {
    @EnvironmentObject var data: TimeData
    @EnvironmentObject var zero: ZeroDate
    @State private var dateString = ""
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Summary")
                    .font(.title)
                    .bold()
                HStack {
                    /// show Any Project as an empty circle
                    Image(systemName: data.terms.project == .any ? "circle" : "largecircle.fill.circle")
                        .foregroundColor(data.terms.project == .any ? Color.primary : data.terms.project.color)
                    Text(data.terms.project.name)
                        .bold()
                    if data.terms.byDescription == .any {
                        Text("Any Description")
                            .foregroundColor(.secondary)
                    } else if data.terms.byDescription == .empty {
                        Text("No Description")
                            .foregroundColor(.secondary)
                    } else {
                        Text(data.terms.description)
                    }
                }
                .onTapGesture {
                    self.data.searching = true
                }
                StatDisplayView(
                    for: WeekTimeFrame(
                        start: self.zero.date,
                        entries: self.data.report.entries,
                        terms: self.data.terms
                    ),
                    prev: WeekTimeFrame(
                        start: self.zero.date - weekLength,
                        entries: self.data.report.entries,
                        terms: self.data.terms
                    )
                )
            }
            .padding()
        }
    }
    
    func Tab() -> some View {
        Rectangle()
            .frame(width: listLineInset)
            .foregroundColor(data.terms.project.color)
    }
    
    func Stat(label: String, symbol: String, text: Text) -> some View {
        Group {
            HStack{
                Text(label)
                Spacer()
                Image(systemName: symbol)
            }
            text
        }
    }
}
