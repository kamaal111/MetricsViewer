//
//  CoreHost+extensions.swift
//  MetricsViewer
//
//  Created by Kamaal M Farah on 17/07/2021.
//

import Foundation
import CoreData
import ConsoleSwift

extension CoreHost {
    var appsArray: [CoreApp] {
        self.apps.asArray() as? [CoreApp] ?? []
    }

    func addApp(_ app: CoreApp, save: Bool) {
        guard let context = self.managedObjectContext else {
            console.error(Date(), "no context found")
            return
        }
        self.apps = NSSet(array: appsArray.appended(app))
        guard save else { return }
        do {
            try context.save()
        } catch {
            console.error(Date(), error.localizedDescription, error)
        }
    }

    @discardableResult
    static func setHost(with args: Args, context: NSManagedObjectContext) -> Result<CoreHost, Error> {
        let host = CoreHost(context: context)
        host.apps = NSSet(array: [])
        host.id = UUID()
        host.url = args.url
        host.name = args.name
        let now = Date()
        host.creationDate = now
        host.updatedDate = now
        do {
            try context.save()
        } catch {
            return .failure(error)
        }
        return .success(host)
    }

    private static func getAllHosts(
        with predicate: NSPredicate? = nil,
        context: NSManagedObjectContext) -> Result<[CoreHost], Error> {
        let entityName = String(describing: CoreHost.self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        let fetchedHosts: [CoreHost]
        do {
            fetchedHosts = try context.fetch(fetchRequest) as? [CoreHost] ?? []
        } catch {
            return .failure(error)
        }
        return .success(fetchedHosts)
    }

    static func findHost(
        by searchProperty: SearchProperties,
        of value: CVarArg,
        context: NSManagedObjectContext) -> CoreHost? {
        let predicate = NSPredicate(format: "%@ == %@", searchProperty.rawValue, value)
        return try? CoreHost.getAllHosts(with: predicate, context: context).get().first
    }

    enum SearchProperties: String {
        case name
        case id
    }

    struct Args {
        let url: URL
        let name: String
    }
}
