//  iOSWorkoutManager.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/19/24.
//


import WatchConnectivity
import SwiftUI

class iOSWorkoutManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var steps: Int = 0
    @Published var distance: Double = 0.0
    @Published var caloriesBurned: Double = 0.0

    var session: WCSession?

    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func startWorkoutOnWatch() {
        session?.sendMessage(["command": "startWorkout"], replyHandler: nil) { error in
            print("Failed to send message to watch: \(error.localizedDescription)")
        }
    }

    func endWorkoutOnWatch() {
        session?.sendMessage(["command": "endWorkout"], replyHandler: nil) { error in
            print("Failed to send message to watch: \(error.localizedDescription)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let steps = message["steps"] as? Int,
           let distance = message["distance"] as? Double,
           let calories = message["calories"] as? Double {
            DispatchQueue.main.async {
                self.steps = steps
                self.distance = distance
                self.caloriesBurned = calories
            }
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle session inactivity
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Handle session deactivation
        session.activate()
    }
}
