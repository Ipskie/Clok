//
//  BarStack.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 10/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct BarStack: View {
    
    @EnvironmentObject private var bounds: Bounds
    @EnvironmentObject private var zero: ZeroDate
    
    func jumpCoreDate() {
        zero.start += .leastNonzeroMagnitude
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                Mask {
                    DayScroll(size: geo.size)
                }
                HStack {
                    FilterStack()
                        .padding(buttonPadding)
                    Image(systemName: "chevron.left.2")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .back
                            withAnimation {
                                zero.start -= dayLength * Double(zero.dayCount)
                            }
                        }
                    Image(systemName: "chevron.left")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .back
                            withAnimation {
                                zero.start -= dayLength
                            }
                        }
                    Image(systemName: "chevron.right")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .fwrd
                            withAnimation {
                                zero.start += dayLength
                            }
                        }
                    Image(systemName: "chevron.right.2")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .fwrd
                            withAnimation {
                                zero.start += dayLength * Double(zero.dayCount)
                            }
                        }
                    Image(systemName: "plus")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .none
                            withAnimation {
                                zero.dayCount = min(ZeroDate.countMax, zero.dayCount + 1)
                            }
                        }
                    Image(systemName: "minus")
                        .modifier(ButtonGlyph())
                        .onTapGesture {
                            zero.dateChange = .none
                            withAnimation {
                                zero.dayCount = max(ZeroDate.countMin, zero.dayCount - 1)
                            }
                        }
                }
                
            }
        }
        /// keep it square
        .aspectRatio(1, contentMode: bounds.notch ? .fit : .fill)
        .onAppear(perform: jumpCoreDate)
    }
    
    func DayScroll(size: CGSize) -> some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: .zero) {
//                    LineGraph(offset: 0,size: size)
//                        .frame(width: size.width, height: size.height)
//                        .background(LinedBackground(size: size, color: .clokBG))
//                    MidnightDivider(size: size)
                    LineGraph(offset: 1,size: size)
                        .frame(width: size.width, height: size.height * 3)
                        .background(LinedBackground(size: size))
                        .id(0)
//                    MidnightDivider(size: size)
//                    LineGraph(offset: 2,size: size)
//                        .frame(width: size.width, height: size.height)
//                        .background(LinedBackground(size: size, color: .clokBG))
                }
                .padding([.top, .bottom], -size.height / 2)
                .onAppear{ proxy.scrollTo(0) }
            }
        }
    }
    
    func LinedBackground(size: CGSize) -> some View {
        return VStack(spacing: .zero) {
            ForEach(0..<evenDivisions(for: size), id: \.self) { _ in
                Rectangle().foregroundColor(.clokBG)
                Divider()
            }
            ForEach(0..<evenDivisions(for: size), id: \.self) { _ in
                Rectangle().foregroundColor(Color(UIColor.systemBackground))
                Divider()
            }
            ForEach(0..<evenDivisions(for: size), id: \.self) { _ in
                Rectangle().foregroundColor(.clokBG)
                Divider()
            }
        }
    }
    
    
    func MidnightDivider(size: CGSize) -> some View {
        Rectangle()
            .foregroundColor(.red)
            .frame(width: size.width, height: 2)
    }
    
    func frameHeight(geo: GeometryProxy) -> CGFloat {
        geo.size.height * CGFloat(dayLength / zero.interval)
    }
}


