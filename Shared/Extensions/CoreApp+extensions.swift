//
//  CoreApp+extensions.swift
//  MetricsViewer
//
//  Created by Kamaal Farah on 06/07/2021.
//

import CoreData
import ConsoleSwift

extension CoreApp {
    var renderable: Renderable {
        Renderable(id: self.id, content: self.name)
    }

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
        if let hostID = args.hostID, let host = CoreHost.findHost(by: .id, of: hostID.nsString, context: context) {
            host.addApp(app, save: false)
            app.host = host
        }
        do {
            try context.save()
        } catch {
            return .failure(error)
        }
        return .success(app)
    }

    static func appIdentifierExists(_ appIdentifier: String, context: NSManagedObjectContext) -> Bool {
        let getAllIdentifiersResult = CoreApp.getAllAppIdentifiers(context: context)
        let allIdentifiers: [String]
        switch getAllIdentifiersResult {
        case .failure(let failure):
            console.error(Date(), failure.localizedDescription, failure)
            return false
        case .success(let success): allIdentifiers = success
        }
        return allIdentifiers.contains(appIdentifier)
    }

    private static func getAllAppIdentifiers(context: NSManagedObjectContext) -> Result<[String], Error> {
        let entityName = String(describing: self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let fecthedObjects: [CoreApp]
        do {
            fecthedObjects = try context.fetch(fetchRequest) as? [CoreApp] ?? []
        } catch {
            return .failure(error)
        }
        let identifiers = fecthedObjects.map(\.appIdentifier)
        return .success(identifiers)
    }

    struct Renderable: MetricsGridCellRenderable {
        let id: UUID
        let content: String
    }

    struct Args {
        let name: String
        let appIdentifier: String
        let accessToken: String
        let hostID: UUID?
    }
}
