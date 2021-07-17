//
//  CoreHost+CoreDataProperties.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 17/07/2021.
//
//

import Foundation
import CoreData


extension CoreHost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreHost> {
        return NSFetchRequest<CoreHost>(entityName: "CoreHost")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var url: URL
    @NSManaged public var creationDate: Date
    @NSManaged public var updatedDate: Date
    @NSManaged public var apps: NSSet

}

// MARK: Generated accessors for apps
extension CoreHost {

    @objc(addAppsObject:)
    @NSManaged public func addToApps(_ value: CoreApp)

    @objc(removeAppsObject:)
    @NSManaged public func removeFromApps(_ value: CoreApp)

    @objc(addApps:)
    @NSManaged public func addToApps(_ values: NSSet)

    @objc(removeApps:)
    @NSManaged public func removeFromApps(_ values: NSSet)

}

extension CoreHost : Identifiable {

}
