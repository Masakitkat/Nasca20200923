//
//  Nasca20200923App.swift
//  Nasca20200923
//
//  Created by masaki on 2020/09/23.
//

import SwiftUI

@main
struct Nasca20200923App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
