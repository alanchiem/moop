//
//  pomodoroApp.swift
//  pomodoro
//
//  Created by Alan Chiem on 6/7/22.
//

import SwiftUI

@main
struct pomodoroApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
