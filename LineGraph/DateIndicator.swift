//
//  DateIndicator.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 14/8/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct DateIndicator: View {
    
    @EnvironmentObject var zero: ZeroDate
    
    let dayHeight: CGFloat
    
    var body: some View {
        HStack(spacing: .zero) {
            WidthHelper
            ForEach(
                Array(stride(from: zero.start, to: zero.end, by: .day)),
                id: \.timeIntervalSince1970
            ) { midnight in
                /// short weekday and date labels
                VStack(spacing: .zero) {
                    Text(midnight.shortWeekday)
                        .font(Font.footnote.boldIfToday(date: midnight))
                        .lineLimit(1)
                        .foregroundColor(color(for: midnight))
                    DateLabel(for: midnight)
                        .font(Font.caption.boldIfToday(date: midnight))
                        .lineLimit(1)
                        .foregroundColor(color(for: midnight))
                }
                .frame(maxWidth: .infinity)
                .background(Color.clokBG)
                .transition(zero.slideOver)
            }
        }
    }
    
    /**
     determine the correct color to use for this date
     */
    private func color(for date: Date) -> Color {
        switch Date() - date {
        case let diff where diff < 0: /// date is in the future
            return .secondary
        case let diff where diff < .day: /// date is today
            return .red
        default: /// date is in the past
            return .primary
        }
    }
    
    /**
     Wrapper around  an invisible`TimeIndicator`.
     Keeps the labels aligned correctly above their respective days
     */
    var WidthHelper: some View {
        /// `TimeIndicator` is very tall, so wrap it in a `ScrollView`
        /// to allow it to collapse its height without messing up the width
        ScrollView {
            TimeIndicator(divisions: evenDivisions(for: dayHeight))
        }
        /// view should be invisible and non-interactable
        .opacity(0)
        .allowsHitTesting(false)
        .disabled(true)
        
    }
    
    func HeaderLabel(for date: Date) -> some View {
        /// short weekday and date labels
        VStack(spacing: .zero) {
            Text(date.shortWeekday)
                .font(.footnote)
                .lineLimit(1)
            DateLabel(for: date)
                .font(.caption)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .background(Color.clokBG)
    }
    
    func DateLabel(for date: Date) -> Text {
        let df = DateFormatter()
        if Calendar.current.component(.day, from: date) == 1 {
            df.setLocalizedDateFormatFromTemplate("MMM")
            return Text(df.string(from: date)).bold()
        } else {
            df.setLocalizedDateFormatFromTemplate("dd")
            return Text(df.string(from: date))
        }
    }
}

/**
 bold the font if the provided date is today
 */
fileprivate extension Font {
    func boldIfToday(date: Date) -> Font {
        let diff = Date() - date
        guard diff > 0 else { return self }
        guard diff < .day else { return self }
        return self.bold()
    }
}
