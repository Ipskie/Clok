//
//  NewGraphView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct NewGraph: View {
    
    var DayList = Array(0..<10365)
    var offSet = -10000
    var df = DateFormatter()
    
    init() {
        df.dateStyle = .short
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(alignment: .leading, spacing: .zero, pinnedViews: .sectionHeaders) {
                        ForEach(DayList, id: \.self) { idx in
                            Section(header:
                                Text(dateString(at: idx))
                                        .frame(height: 40)
                            ) {
                                DayRect(idx: idx, size: geo.size)
                                    .padding(.top, -40)
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.black)
                            }
                            
                        }
                    }
                    .onAppear {
                        proxy.scrollTo(10000)
                    }
                }
            }
        }
    }
    
    func DayRect(idx: Int, size: CGSize) -> some View {
        ZStack {
            LineGraph(dayHeight: size.height)
        }
    }
    
    func dateString(at idx: Int) -> String {
        df.string(from: Date().advanced(by: Double(offSet + idx) * .day))
    }
}