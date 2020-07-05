//
//  Project.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.21.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

struct Project: Hashable, Comparable, Identifiable {
    var name: String
    var color: Color
    var id: Int
    
    func matches(_ other: Project) -> Bool {
        /// Any Project matches all other projects
        self == other || other == .any || self == .any
    }
    
    static func < (lhs: Project, rhs: Project) -> Bool {
        /// No Project should always be first
        if lhs == .noProject { return true }
        if rhs == .noProject { return false }
        return lhs.name < rhs.name
    }
    
    static let noProject = Project(
        name: "No Project",
        color: Color.noProject,
        id: NSNotFound
    )
    
    static let any = Project(
        name: "Any Project",
        color: Color.secondary,
        id: Int.zero
    )
    
    init(name: String, color: Color, id: Int){
        self.name = name
        self.color = color
        self.id = id
    }
    
    // parse from JSON
    init?(from data: [String : AnyObject]){
        // check that these properties are not nil
        guard
            let id = data["id"] as? Int,
            let project_hex_color = data["hex_color"] as? String,
            let name = data["name"] as? String
        else { return nil }
        
        self.id = id
        self.color = Color(hex: project_hex_color)
        self.name = name
    }
}
