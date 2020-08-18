//
//  Project+CoreDataClass.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 11/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//
//

import Foundation
import SwiftUI
import CoreData

/// simplify decoding
/// Documentation:
/// https://github.com/toggl/toggl_api_docs/blob/f62b8f4bb9118d97af54df48a268ff1e4319b34b/chapters/projects.md#projects
struct RawProject: Decodable {
    let id: Int
    let is_private: Bool
    let wid: Int
    let hex_color: String
    let name: String
    let billable: Bool
    
    /// `Date` the "task" was last updated
    let at: Date
    // one of these cases a coding failure, ignore for now
//        var actual_hours: Int
//        var color: Int // probably an enum for toggl's default color palette
}

@objc(Project)
public class Project: NSManagedObject, Decodable, ProjectLike {
    
    static let entityName = "Project" /// for making entity calls
    
    @objc
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("NSManagedObjectContext is missing") }

        super.init(entity: Project.entity(), insertInto: context)
        
        let rawProject = try RawProject(from: decoder)
        id = Int64(rawProject.id)
        color = rawProject.hex_color
        name = rawProject.name
        fetched = Date()
    }
    
    init(raw: RawProject, context: NSManagedObjectContext) {
        super.init(entity: Project.entity(), insertInto: context)
        id = Int64(raw.id)
        color = raw.hex_color
        name = raw.name
        fetched = Date()
    }
    
    /// copy properties from `RawProject` into `Project`
    func update(from rawProject: RawProject) {
        self.setValuesForKeys([
            /// NOTE: `id`should never change
            "color": rawProject.hex_color,
            "name": rawProject.name,
            "fetched": Date(), /// update `fetched`
        ])
    }
    
    static func == (lhs: Project, rhs: ProjectLike) -> Bool {
        lhs.name == rhs.name && lhs.wrappedID == rhs.wrappedID
    }
    
    func matches(_ other: ProjectLike) -> Bool {
        /// Any Project matches all other projects
        self == other || .any == other  || self == StaticProject.any
    }
    
    static func < (lhs: Project, rhs: ProjectLike) -> Bool {
        /// No Project should always be first
        if StaticProject.noProject == lhs  { return true }
        if StaticProject.noProject == rhs  { return false }
        return lhs.name < rhs.name
    }
}
