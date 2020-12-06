//
//  StaticEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 5/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI
struct StaticEntry: TimeEntryLike {
    var id: Int64
    var start: Date
    var end: Date
    var color: Color
    var entryDescription: String
    var projectName: String
    var tagStrings: [String]
    var duration: TimeInterval
    
    //MARK:- NoEntry
    /// represents the absence of an entry, without resorting to a forced unwrap
    static let noEntry = StaticEntry(
        id: Int64(NSNotFound),
        start: .distantPast,
        end: .distantFuture,
        color: .clear,
        entryDescription: "[No Entry]",
        projectName: StaticProject.unknown.name,
        tagStrings: [],
        duration: .zero
    )
}