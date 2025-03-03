//
//  AldoApp.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/12/24.
//

import SwiftUI
import Firebase

@main
struct AldoApp: App {
    @StateObject private var workoutManager = iOSWorkoutManager()
    @StateObject private var authManager = AuthenticationManager()

    init() {
        FirebaseApp.configure() // Initialize Firebase
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(workoutManager)
                .environmentObject(authManager)
        }
    }
}
