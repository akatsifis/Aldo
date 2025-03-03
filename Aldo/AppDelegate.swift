//  AppDelegate.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/19/24.
//
import UIKit
import HealthKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    let healthStore = HKHealthStore()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Request HealthKit authorization
        requestHealthAuthorization()
        
        return true
    }

    func requestHealthAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            return
        }

        let allTypes = Set([
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ])

        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { success, error in
            if !success {
                // Handle the error here.
                print("HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
