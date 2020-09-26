//
//  SummaryTimelineEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 3/9/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import WidgetKit

struct SummaryEntry: TimelineEntry {
    public let date: Date
    public let summary: Summary
    public var pid1: Int? = nil
    public var pid2: Int? = nil
    public var pid3: Int? = nil
}
