//
//  Aldo_Watch_AppApp.swift
//  Aldo Watch App Watch App
//
//  Created by Andrew Katsifis on 6/12/24.
//

import SwiftUI

@main
struct Aldo_Watch_AppApp: App {
    @StateObject private var workoutManager = WatchWorkoutManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workoutManager)
        }
    }
}
