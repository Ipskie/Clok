//
//  EntryFullScreenModal.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 2/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct EntryFullScreenModal: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    //MARK:- Modal Properties
    @State var scrollOffset: CGFloat = .zero
    @State var initialPos: CGFloat? = .none
    @State var bottomPos: CGFloat = .zero
    
    @Binding var selected: TimeEntry?
    var geometry: NamespaceModel
    var namespace: Namespace.ID
    
    /// the minimum pull-down to dismiss the view
    static let threshhold: CGFloat = 50
    
    static let sharedPadding: CGFloat = 10
        /// named Coordinate Space for this view
    let coordSpaceName = "bottom"
    
    var entry: TimeEntryLike { selected ?? StaticEntry.noEntry }
    
    var body: some View {
        /// define a drag gesture that imitates scrolling (no momentum though)
        let ScrollDrag = DragGesture()
            .onChanged { gesture in
                /// capture initial offset as gesture begins
                if initialPos == .none { initialPos = scrollOffset }
                let newOffset = initialPos! + gesture.translation.height
                withAnimation(.linear(duration: 0.05)) {
                    /// give pull down more "resistance"
                    self.scrollOffset = newOffset < 0 ? newOffset : newOffset / 3
                }
            }
            .onEnded { _ in
                initialPos = .none
                if scrollOffset > EntryFullScreenModal.threshhold {
                    self.dismiss()
                } else if scrollOffset > 0 {
                    withAnimation { scrollOffset = 0 }
                } else if bottomPos < 0 {
                    /// prevent scrolling past bottom of stack
                    withAnimation { scrollOffset -= bottomPos }
                }
            }
        
        return GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Color(UIColor.secondarySystemBackground)
                    .offset(y: max(0, scrollOffset))
                ControlBar
                    .offset(y: max(0, scrollOffset))
                    .zIndex(1)
                VStack(spacing: .zero) {
                    EntryHeader
                        .matchedGeometryEffect(id: geometry, in: namespace)
                    EntryBody
                    /// monitors the position of the bottom of the view
                    GeometryReader { bottomGeo in
                        Run {
                            bottomPos = bottomGeo.frame(in: .named(coordSpaceName)).maxY - geo.size.height
                        }
                    }
                }
                    .offset(y: scrollOffset)
            }
                .frame(height: geo.size.height, alignment: .top)
                .clipped()
                .coordinateSpace(name: coordSpaceName)
                .gesture(ScrollDrag)
        }
    }
    
    
    var EntryBody: some View {
        VStack {
            EntryLabel(entry.projectName, systemImage: "folder.fill")
            EntryLabel(entry.duration.toString(), systemImage: "stopwatch")
        }
            .padding(Self.sharedPadding)
            .background(Color(UIColor.secondarySystemBackground))
    }
    
    // MARK:- ControlBar
    var ControlBar: some View {
        HStack {
            DismissalButton(dismiss: dismiss, completion: dismissalCompletion)
            Spacer()
            Button {
                print("dummy button!")
            } label: {
                Image(systemName: "xmark")
            }
        }
            .buttonStyle(PlainButtonStyle())
            .padding(Self.sharedPadding)
            .background(
                /// a nice transluscent system color
                Color(UIColor.secondarySystemFill)
                    /// allows it to cover color when user scrolls down
                    .edgesIgnoringSafeArea(.top)
            )
    }
    
    /// measures the progress of the "swipe down to dismiss" gesture. bounded from [0, 1]
    var dismissalCompletion: CGFloat {
        /// note: clamp prevents visual from triggering while scrolling down
        /// `-` inversion causes circle to fill clockwise instead of counterclockwise
        -clamp(scrollOffset / Self.threshhold, between: (0, 1))
    }
    
    func dismiss() -> Void {
        withAnimation { selected = .none }
    }
}