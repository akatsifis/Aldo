//
//  Aldo_WatchApp.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/19/24.
//

import SwiftUI

struct Aldo_WatchApp: App {
    @StateObject var workoutManager = WatchWorkoutManager() // Initialize the workout manager

    var body: some Scene {
        WindowGroup {
            ContentView() // Your initial view
                .environmentObject(workoutManager) // Provide the workout manager to the environment
        }
    }
}
