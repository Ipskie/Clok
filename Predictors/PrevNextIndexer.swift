//
//  PrevNextIndexer.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 24/12/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import CoreData
import Combine

struct PrevNextIndexer {
    
    let anyCancellable: AnyCancellable
    let context: NSManagedObjectContext
    
    /// how long to wait in seconds before performing another index operation
    static private let Interval: TimeInterval = 10
    
    init(in context: NSManagedObjectContext) {
        self.context = context
        self.anyCancellable = Timer
            .publish(every: Self.Interval, on: .main, in: .common)
            .autoconnect()
            .sink{ _ in
                Self.prevNextIndex(context: context)
            }
    }
    
    static func prevNextIndex(context: NSManagedObjectContext) -> Void {
        guard let target: TimeEntry = findTarget(context: context) else {
            #if DEBUG
            print("No Entries to index.")
            #endif
            return
        }
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
        /// to avoid hitting `CoreData` repeatedly, choose a range of dates to link together and fetch them at once
        req.predicate = NSPredicate(format: "(start >= %@) AND (start <= %@)", NSDate(target.start), NSDate(target.start + .week))
        req.sortDescriptors = [NSSortDescriptor(key: "start", ascending: true)]
        guard let entries = try? context.fetch(req) as? [TimeEntry] else {
            #if DEBUG
            assert(false, "Failed to fetch entries to index!")
            #endif
            return
        }
        /// avoid in indexing error by aborting if there are too few entries
        guard entries.count > 1 else { return }
        (0...(entries.count - 2)).forEach{ entries[$0].next = entries[$0 + 1] }
        entries.forEach{ $0.lastIndexed = Date() }
        do { try context.save() }
        catch { assert(false, "Failed to save after indexing!") }
        #if DEBUG
        print("Indexed \(entries.count) entries")
        #endif
    }

    /// only select entries which are potentially out of date due to having been updated recently
    /// and fetch the entry most egregiously out of date
    private static func findTarget(context: NSManagedObjectContext) -> TimeEntry? {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: TimeEntry.entityName)
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "lastIndexed < lastUpdated")
        req.sortDescriptors = [NSSortDescriptor(key: "lastIndexed", ascending: true)]
        return context.max1(for: req)
    }

}
