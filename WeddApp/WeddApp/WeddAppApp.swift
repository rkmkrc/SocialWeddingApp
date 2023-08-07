//
//  WeddAppApp.swift
//  WeddApp
//
//  Created by Erkam Karaca on 8.07.2023.
//

import SwiftUI
import Firebase

@main
struct WeddAppApp: App {
    let persistenceController = PersistenceController.shared
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            OTPPage()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
