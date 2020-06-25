//
//  ProjectButton.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/6/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI

struct ProjectButton: View {
    @EnvironmentObject private var data: TimeData
    
    @State private var showSheet = false
    
    let radius = CGFloat(10)
    
    var body: some View {
        HStack {
            Button(action: { self.showSheet.toggle() }) {
                Image(systemName:
                    /// show Any as an empty circle
                    data.terms.project == .any ? "circle" : "largecircle.fill.circle"
                )
                    .foregroundColor(
                        data.terms.project == .any ? Color.primary : data.terms.project.color
                )
                    .modifier(ButtonGlyph())
            }
            .actionSheet(isPresented: $showSheet) { makeSheet() }
            Text(data.terms.project.name)
        }
    }
    
    func makeSheet() -> ActionSheet {
        let projects = [Project.any] + self.data.projects()
        /// make a button for each project
        let projectBtns = projects.map { project in
            ActionSheet.Button.default(Text(project.name)) { () -> Void in
                self.data.terms.project = project
            }
        /// remember cancel button
        } + [ActionSheet.Button.cancel()]
        
        
        return ActionSheet(
            title: Text("Project"),
            buttons: projectBtns
        )
    }
}

struct ProjectButton_Previews: PreviewProvider {
    static var previews: some View {
        ProjectButton()
    }
}
