//  WatchWorkoutManager.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/19/24.
//



import Foundation
import HealthKit
import WatchConnectivity

class WatchWorkoutManager: NSObject, ObservableObject, WCSessionDelegate, HKLiveWorkoutBuilderDelegate {
    @Published var steps: Int = 0
    @Published var distance: Double = 0.0
    @Published var caloriesBurned: Double = 0.0

    private var healthStore = HKHealthStore()
    private var session: WCSession?
    private var workoutSession: HKWorkoutSession?
    private var workoutBuilder: HKLiveWorkoutBuilder?

    override init() {
        super.init()
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

    func startWorkout() {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .golf // Choose appropriate activity type
        configuration.locationType = .outdoor

        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()

            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
            workoutBuilder?.delegate = self

            workoutSession?.startActivity(with: Date())
            workoutBuilder?.beginCollection(withStart: Date(), completion: { (success, error) in
                if let error = error {
                    print("Error starting workout collection: \(error.localizedDescription)")
                }
            })
        } catch {
            print("Error starting workout: \(error.localizedDescription)")
        }
    }

    // MARK: - WCSessionDelegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if message["command"] as? String == "startWorkout" {
            startWorkout()
        }
    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            if let quantityType = type as? HKQuantityType {
                let statistics = workoutBuilder.statistics(for: quantityType)
                let value = statistics?.sumQuantity()?.doubleValue(for: .count())

                DispatchQueue.main.async {
                    if quantityType == HKQuantityType.quantityType(forIdentifier: .stepCount) {
                        self.steps = Int(value ?? 0)
                        self.sendWorkoutDataToiPhone()
                    } else if quantityType == HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) {
                        self.distance = (value ?? 0.0) / 1609.34 // Convert meters to miles
                        self.sendWorkoutDataToiPhone()
                    } else if quantityType == HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) {
                        self.caloriesBurned = value ?? 0.0
                        self.sendWorkoutDataToiPhone()
                    }
                }
            }
        }
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Handle workout events if necessary
    }

    func sendWorkoutDataToiPhone() {
        let workoutData: [String: Any] = [
            "steps": steps,
            "distance": distance,
            "calories": caloriesBurned
        ]

        session?.sendMessage(workoutData, replyHandler: nil) { error in
            print("Failed to send workout data to iPhone: \(error.localizedDescription)")
        }
    }
}
