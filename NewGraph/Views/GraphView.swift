//
//  NewGraphView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 29/11/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

/// fixed size footer, unfortunate but necessary
fileprivate let footerHeight: CGFloat = 20

struct NewGraph: View {
    
    @State var DayList = [0]
    
    /// stores the zoom level before `MagnificationGesture` began
    @State var initialZoom: CGFloat? = nil
    @Environment(\.colorScheme) var mode
    @EnvironmentObject var model: NewGraphModel
    
    var df = DateFormatter()
    
    init() {
        df.setLocalizedDateFormatFromTemplate("MMMdd")
    }
    
    var body: some View {
        /// a giant, monstrous hack
        GeometryReader { geo in
            ZoomableScrollView {
                LazyVStack(alignment: .leading, spacing: .zero, pinnedViews: .sectionFooters) {
                    ForEach(DayList, id: \.self) { idx in
                        Section(footer: Footer(
                            idx: idx,
                            size: CGSize(width: geo.size.width, height: geo.size.height * model.zoom)
                        )) {
                            HStack(spacing: .zero) {
                                NewTimeIndicator(divisions: evenDivisions(for: geo.size.height * model.zoom))
                                NewLineGraphView(
                                    dayHeight: geo.size.height * model.zoom,
                                    start: Date().midnight.advanced(by: Double(idx) * .day)
                                )
                            }
                                .padding(.top, -footerHeight)
                        }
                            /// flip view back over
                            .rotationEffect(.tau / 2)
                            /// if user hits the "last" (visually top) date, add another one "above" (by appending)
//                            .onAppear {
//                                if idx == DayList.last {
//                                    DayList.insert(DayList.last! - 1, at: DayList.count)
//                                }
//                            }
                    }
                }
            }
            /**
             Flipped over so user can infinitely scroll "up" (actually down) to previous days
             */
            .rotationEffect(.tau / 2)
        }
//            .gesture(
//                MagnificationGesture()
//                    .onChanged { state in
//                        if initialZoom == .none { initialZoom = model.zoom }
//                        #warning("placeholder bounds!")
//                        withAnimation {
//                            model.zoom = clamp(initialZoom! * state, between: (0.5, 2))
//                        }
//                        
//                    }
//                    .onEnded { _ in
//                        /// wipe zoom level
//                        initialZoom = .none
//                    }
//            )
    }
}

// MARK:- Section Footer
extension NewGraph {
    func Footer(idx: Int, size: CGSize) -> some View {
        HStack(spacing: .zero) {
            /// prevents the `DateIndicator` from covering the `TimeIndicator`
            WidthHelper(size: size)
            Text(df.string(from: Date().advanced(by: Double(idx) * .day)))
                .foregroundColor(mode == .dark ? .black : .white)
                .font(.system(size: footerHeight - 5))
                .bold()
                .frame(height: footerHeight)
                .padding([.leading, .trailing], 3)
                .background(
                    RoundedCornerRectangle(radius: 4, corners: [.bottomRight, .topRight])
                        .foregroundColor(.red)
                )
            /// push view against the left edge of the graph
            Spacer()
        }
    }
}

// MARK:- Width Helper
extension NewGraph {
    /**
     Wrapper around  an invisible`TimeIndicator`.
     Keeps the labels aligned correctly above their respective days
     */
    func WidthHelper(size: CGSize) -> some View {
        /// `TimeIndicator` is very tall, so wrap it in a `ScrollView`
        /// to allow it to collapse its height without messing up the width
        ScrollView {
            NewTimeIndicator(divisions: evenDivisions(for: size.height))
        }
            /// view should be invisible and non-interactable
            .opacity(0)
            .allowsHitTesting(false)
            .disabled(true)
            .frame(height: .zero)
    }
}
