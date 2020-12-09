//
//  RunningEntry.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 4/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

final class RunningEntry: NSObject, NSSecureCoding, TimeEntryLike {
    
    var id: Int64
    var pid: Int = NSNotFound
    var start: Date
    var project: ProjectLike
    var entryDescription: String
    var tags: [String] = []
    var billable: Bool
    
    let df = DateFormatter()
    
    /// `TimeEntryLike` compliance
    var end: Date { Date() } /// always return current time
    var duration: TimeInterval { Date() - start } /// always return latest duration
    var color: Color { project.wrappedColor }
    var tagStrings: [String] { tags }
    var projectName: String { project.name }
    var identifier: Int64 { id }
    init(
        id: Int64,
        start: Date,
        project: ProjectLike,
        entryDescription: String,
        tags: [String]?,
        billable: Bool
    ){
        self.id = id
        self.start = start
        self.project = project
        self.pid = project.wrappedID
        self.entryDescription = entryDescription
        self.tags = tags ?? []
        self.billable = billable
    }
    
//    // parse from JSON for Widget
//    init?(from data: [String : AnyObject], project: ProjectLike){
//        // initialize DateFormatter to handle ISO8601 strings
//        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
//
//        // check that these properties are not nil
//        guard
//            let id = data["id"] as? Int64,
//            data["description"] != nil,
//            let entryDescription = data["description"] as? String,
//            // get Dates from ISO8601 string
//            data["start"] != nil,
//            let startString = data["start"] as? String,
//            let start = df.date(from: startString)
//        else { return nil }
//
//        self.id = id
//        self.entryDescription = entryDescription
//        self.start = start
//        self.project = project
//        self.tags = data["tags"] as? [String]
//            ?? []
//        self.billable = ERROR
//    }
    
    /// Headlining description,
    /// or project if there's no description,
    /// or placeholder if no info whatsoever
    func descriptionString() -> String {
        if entryDescription == "" && StaticProject.noProject == project {
            return "No Description"
        } else if entryDescription == "" {
            return project.name
        } else {
            return entryDescription
        }
    }

    static func == (lhs: RunningEntry, rhs: RunningEntry) -> Bool {
        /// we could check everything, but unless the data is corrupted we really only need to check task ID
        /// NOTE: if in future we support editing of time entries, this check will need to be more rigorous
        return
            lhs.id == rhs.id &&
            lhs.start == rhs.start &&
            lhs.entryDescription == rhs.entryDescription &&
            /// perform a shallow Project ID check
            lhs.pid == rhs.pid
       }
    
    //MARK:- NSSecureCoding Compliance
    static var supportsSecureCoding = true
    
    /**
     NOTE: this init only finds `pid`, it does not use that to get the associated `project`
     This is so that we do not need to make `projectLike` `NSSecureCoding` compliant.
     Whatever decodes this will need to do its own work to find the `project`.
     */
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(pid, forKey: "pid")
        coder.encode(start, forKey: "start")
        coder.encode(entryDescription, forKey: "entryDescription")
        coder.encode(tags, forKey: "tags")
    }
    
    init?(coder: NSCoder) {
        id = Int64(coder.decodeInteger(forKey: "id"))
        pid = coder.decodeInteger(forKey: "pid")
        /// note: we will assign project later, for now leave `unknown`
        project = StaticProject.unknown
        tags = coder.decodeObject(forKey: "tags") as? [String]
            ?? []
        billable = coder.decodeBool(forKey: "billable")
        
        guard
            let start = coder.decodeObject(forKey: "start") as? Date,
            let entryDescription = coder.decodeObject(forKey: "entryDescription") as? String
        else { return nil }
        self.start = start
        self.entryDescription = entryDescription
        
    }
}

extension RunningEntry {
    /// signals that no entry is currently running
    static let noEntry = RunningEntry(
        id: Int64(NSNotFound),
        start: Date.distantFuture,
        project: StaticProject.noProject,
        entryDescription: "Not Running",
        tags: [],
        billable: false
    )
    
    static let placeholder = RunningEntry(
        id: Int64(NSNotFound),
        start: Date(),
        project: StaticProject.noProject,
        entryDescription: "Placeholder",
        tags: ["Tag"],
        billable: false
    )
}

extension RunningEntry {
    /// expressly for seeing if the running entry has had substantial updates to be displayed on the widget
    /// note that the `UserDefaults` copy will have stripped down information
    static func widgetMatch(_ lhs: RunningEntry?, _ rhs: RunningEntry?) -> Bool {
        guard !(lhs == .none && rhs == .none) else { return true }
        guard
            let lhs = lhs,
            let rhs = rhs
        else { return false }
        return lhs.start == rhs.start
            && lhs.id == rhs.id
            && lhs.entryDescription == rhs.entryDescription
            && lhs.pid == rhs.pid
            && lhs.tags == rhs.tags
    }
}
