//  Timeline.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.

import WidgetKit
import SwiftUI
import Foundation
import Intents

/**
 Define the refresh rate centrally so it can be tweaked quickly
 */
fileprivate extension TimeInterval {
    static let widgetPeriod: TimeInterval = .hour / 4
}

struct Provider: IntentTimelineProvider {
    
    typealias Entry = SummaryEntry
    typealias Intent = ClokConfigurationIntent
    
    func placeholder(in context: Context) -> SummaryEntry {
        SummaryEntry(date: Date(), summary: .noSummary)
    }
    
    func getSnapshot(
        for configuration: ClokConfigurationIntent,
        in context: Context,
        completion: @escaping (SummaryEntry) -> Void
    ) -> Void {
        #warning("snapshot should be better formed")
        completion(placeholder(in: context))
    }
    
    func getTimeline(
        for configuration: ClokConfigurationIntent,
        in context: Context,
        completion: @escaping (Timeline<SummaryEntry>) -> Void
    ) -> Void {
        // fetch credentials from Keychain
        guard let (_, _, token, chosenWID) = try? getKey() else {
            let timeline = Timeline(entries: [SummaryEntry](), policy: .after(Date() + .widgetPeriod))
            completion(timeline)
            return
        }
        
        /// fetch summary from Toggl
        fetchSummary(token: token, wid: chosenWID) { summary, error in
            guard let summary = summary, error == nil else {
                print("Error \(String(describing: error))")
                let timeline = Timeline(entries: [SummaryEntry](), policy: .after(Date() + .widgetPeriod))
                completion(timeline)
                return
            }
            
            /// add fetched summary to Widget Timeline
            /// load again after `widgetPeriod`
            let timeline = Timeline(
                entries: [SummaryEntry(
                    date: Date(),
                    summary: summary,
                    pid1: configuration.Project1?.pid?.intValue,
                    pid2: configuration.Project2?.pid?.intValue,
                    pid3: configuration.Project3?.pid?.intValue
                )],
                policy: .after(Date() + .widgetPeriod)
            )
            completion(timeline)
            return
        }
    }
}
