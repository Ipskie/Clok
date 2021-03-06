//
//  DataFetch.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 12/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import CoreData

/// fetch projects from Core Data storage
func loadProjects(context: NSManagedObjectContext) -> [Project]? {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Project.entityName)
    do {
        let projects = try context.fetch(fetchRequest) as! [Project]
        return projects
    } catch {
        print(error)
    }
    return nil
}
