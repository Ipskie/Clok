//
//  AppView.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import SwiftUI
import CoreData
import Combine

@main
struct ClokApp: App {
    
    var listRow = ListRow()
    var zero = ZeroDate()
    var data: TimeData
    var cred: Credentials
    var bounds = Bounds()
    var model = GraphModel()
    var loader = EntryLoader()
    var saver: GraphSaver
    
    var persistentContainer: NSPersistentContainer
    
    init(){
        /// initialize Core Data container
        let container = NSPersistentContainer(name: "TimeEntryModel")
        container.loadPersistentStores { description, error in
            if let error = error { fatalError("\(error)") }
        }
        persistentContainer = container
        container.viewContext.mergePolicy = NSOverwriteMergePolicy
        
        /// pull `Project`s from CoreData
        data = TimeData(projects: loadProjects(context: persistentContainer.viewContext) ?? [])
        
        /// pull `User` from KeyChain
        cred = Credentials(user: loadCredentials())
        
        /// refresh project list on launch
        data.fetchProjects(user: cred.user, context: persistentContainer.viewContext)
        
        /// attach `ZeroDate` to UserDefaults
        saver = GraphSaver(zero: zero)
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(listRow)
                .environmentObject(zero)
                .environmentObject(data)
                .environmentObject(cred)
                .environmentObject(bounds)
                .environmentObject(model)
                .environment(\.managedObjectContext, persistentContainer.viewContext)
                /// update on change to either user or space
                .onReceive(cred.$user) {
                    data.fetchProjects(
                        user: $0,
                        context: persistentContainer.viewContext
                    )
                }
                .onReceive(zero.limitedStart, perform: { date in
                    print("\(date) requestewd")
                    loader.fetchEntries(
                        range: (start: date, end: date + .week),
                        user: cred.user!,
                        projects: data.projects,
                        context: persistentContainer.viewContext
                    )
                })
        }
    }
}
final class GraphSaver: ObservableObject {
    
    init(zero: ZeroDate){
        /// save start date to User Defaults
        self.startSaver = zero.$start
            /// debounce to limit the rate we hit User Defaults
            .debounce(
                for: .seconds(1),
                scheduler: RunLoop.main
            )
            .sink { date in
                WorkspaceManager.zeroStart = date
            }
        
        /// save `zoomIdx` date to User Defaults
        self.zoomSaver = zero.$zoomIdx
            /// debounce to limit the rate we hit User Defaults
            .debounce(
                for: .seconds(1),
                scheduler: RunLoop.main
            )
            .sink { index in
                WorkspaceManager.zoomIdx = index
            }
    }
    
    var startSaver: AnyCancellable?
    var zoomSaver: AnyCancellable?
}
