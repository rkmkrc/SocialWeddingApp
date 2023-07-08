//
//  WeddAppApp.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import SwiftUI

@main
struct WeddAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
