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
        return .failure(NSError(domain: "", code: 1, userInfo: nil))
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

    static func findHost(with id: UUID, context: NSManagedObjectContext) -> CoreHost? {
        let entityName = String(describing: CoreHost.self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.nsString)
        let fetchedApps = try? context.fetch(fetchRequest) as? [CoreHost]
        return fetchedApps?.first
    }

    struct Args {
        let url: URL
        let name: String
    }
}
