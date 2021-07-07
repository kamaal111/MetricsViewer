//
//  CoreApp+extensions.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 06/07/2021.
//

import CoreData

extension CoreApp {
    @discardableResult
    static func setApp(with args: Args, context: NSManagedObjectContext) -> Result<CoreApp, Error> {
        let app = CoreApp(context: context)
        app.id = UUID()
        app.name = args.name
        app.appIdentifier = args.appIdentifier
        app.accessToken = args.accessToken
        let now = Date()
        app.creationDate = now
        app.updateDate = now
        do {
            try context.save()
        } catch {
            return .failure(error)
        }
        return .success(app)
    }

    static func getAllAppIdentifiers(context: NSManagedObjectContext) throws -> [String] {
        let entityName = String(describing: self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        guard let fecthedObjects = try context.fetch(fetchRequest) as? [CoreApp] else { return  [] }
        let identifiers = fecthedObjects.map(\.appIdentifier)
        return identifiers
    }

    struct Args {
        let name: String
        let appIdentifier: String
        let accessToken: String
    }
}
