//
//  MindRepoApp.swift
//  MindRepo
//
//  Created by MindRepo Team on 10/14/25.
//

import SwiftUI
import SwiftData

@main
struct MindRepoApp: App {
    @AppStorage("didOnboard") private var didOnboard = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Diary.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            if didOnboard {
                MainView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
