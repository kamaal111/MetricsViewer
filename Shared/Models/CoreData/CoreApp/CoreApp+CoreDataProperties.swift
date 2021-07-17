//
//  CoreApp+CoreDataProperties.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 06/07/2021.
//
//

import Foundation
import CoreData


extension CoreApp {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreApp> {
        return NSFetchRequest<CoreApp>(entityName: "CoreApp")
    }

    @NSManaged public var accessToken: String
    @NSManaged public var appIdentifier: String
    @NSManaged public var creationDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var updateDate: Date
    @NSManaged public var host: CoreHost?

}

extension CoreApp : Identifiable {

}
