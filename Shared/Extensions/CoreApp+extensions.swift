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

    func editApp(with args: Args) throws -> CoreApp {
        guard let context = self.managedObjectContext else { throw Errors.contextNotFound }
        self.updateDate = Date()
        self.name = args.name
        self.appIdentifier = args.appIdentifier
        self.accessToken = args.accessToken
        if let hostID = args.hostID, let host = CoreHost.findHost(by: .id, of: hostID.nsString, context: context) {
            self.host?.removeAppFromHost(self)
            host.addToApps(self)
            self.host = host
        }
        try self.managedObjectContext?.save()
        return self
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

    static func appIdentifierExists(
        _ appIdentifier: String,
        excluding excludingIdentifier: String? = nil,
        context: NSManagedObjectContext) -> Bool {
        let getAllIdentifiersResult = CoreApp.getAllAppIdentifiers(context: context)
        var allIdentifiers: [String]
        switch getAllIdentifiersResult {
        case .failure(let failure):
            console.error(Date(), failure.localizedDescription, failure)
            return false
        case .success(let success): allIdentifiers = success
        }
        if let excludingIdentifier = excludingIdentifier {
            allIdentifiers = allIdentifiers.filter { $0 == excludingIdentifier }
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

    enum Errors: Error {
        case contextNotFound
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

        init(name: String, appIdentifier: String, accessToken: String, hostID: UUID?) {
            self.name = name
            self.appIdentifier = appIdentifier
            self.accessToken = accessToken
            self.hostID = hostID
        }

        init(name: String, appIdentifier: String, accessToken: String, host: CoreHost) {
            self.init(name: name, appIdentifier: appIdentifier, accessToken: accessToken, hostID: host.id)
        }
    }
}
