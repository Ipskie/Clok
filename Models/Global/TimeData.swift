//
//  Data.swift
//  Trickl
//
//  Created by Secret Asian Man 3 on 20.06.20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import SwiftUI

final class TimeData: ObservableObject {
    @Published var report = Report()
    
    // the Project and Descriptions the user is filtering for
    @Published var terms = SearchTerm(
        project: .any,
        description: "",
        byDescription: .any
    )
    
    // true when user is changing the search terms
    @Published var searching = false
    
    func projects() -> [Project] {
        /// use set to make unique
        Set(self.report.entries.map{$0.project})
            .sorted()
    }
}

struct WithID<T>: Identifiable {
    var id = UUID()
    var val: T
}