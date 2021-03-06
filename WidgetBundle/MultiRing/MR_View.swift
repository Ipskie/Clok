//
//  MultiRing.swift
//  MultiRing
//
//  Created by Secret Asian Man 3 on 20.09.25.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

fileprivate let padded = CGFloat(7)
fileprivate let spaced = CGFloat(7)

struct MultiRingEntryView : View {
    
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var mode: ColorScheme
    
    var entry: MultiRingProvider.Entry
    
    var body: some View {
        HStack {
            switch family {
            case .systemSmall:
                Grid4(topN[0], topN[1], topN[2], topN[3])
            case .systemMedium:
                ProjectRing(project: topN[0], size: .large, entry: entry)
                Grid4(topN[1], topN[2], topN[3], topN[4])
            case .systemLarge:
                Grid4(topN[0], topN[1], topN[2], topN[3])
            @unknown default:
                fatalError("Unsupported Widget Size!")
            }
        }
        .padding(padded)
        /// enforce the user's preferred scheme, if any, otherwise pass through the default
        .environment(\.colorScheme, {
            switch entry.config.Theme {
            case .system, .unknown:
                return mode
            case .dark:
                return .dark
            case .light:
                return .light
            }
        }())
        .background({ () -> Color in
            switch entry.config.Theme {
            case .system, .unknown:
                return mode == .dark
                    ? .black
                    : .white
            case .dark:
                return .black
            case .light:
                return .white
            }
        }())
    }
    
    func Grid4(
        _ p1: Detailed.Project,
        _ p2: Detailed.Project,
        _ p3: Detailed.Project,
        _ p4: Detailed.Project
    ) -> some View {
        VStack(spacing: spaced) {
            HStack(spacing: spaced) {
                ProjectRing(project: p1, entry: entry)
                ProjectRing(project: p2, entry: entry)
            }
            HStack(spacing: spaced) {
                ProjectRing(project: p3, entry: entry)
                ProjectRing(project: p4, entry: entry)
            }
        }
    }
}

// MARK: - How many rings to show
extension MultiRingEntryView {
    var ringCount: Int {
        switch family {
        case .systemSmall:
            return 4
        case .systemMedium:
            return 8
        case .systemLarge:
            return 16
        @unknown default:
            fatalError()
        }
    }
    
    /// return exactly enough projects, padded with `empty`s to make the count
    var topN: [Detailed.Project] {
        /// sorted by duration and padded with enough `empty`s
        var projs = entry.projects.sorted(by: {$0.duration > $1.duration})
            + Array(repeating: .empty, count: ringCount)
        
        /// if in `medium` size, big ring should be the running ring
        if
            family == .systemMedium,
            entry.running != .noEntry,
            let idx = projs.firstIndex(where: {$0.id == entry.running.wrappedProject.id})
        {
            let popped = projs.remove(at: idx)
            projs = [popped] + projs
        }
        
        return Array(projs[0..<ringCount])
    }
}
