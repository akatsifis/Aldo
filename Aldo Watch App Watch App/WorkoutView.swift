//
//  WorkoutView.swift
//  Aldo Watch App
//
//  Created by Andrew Katsifis on 6/23/24.
//
import SwiftUI
import HealthKit

struct WorkoutView: View {
    @ObservedObject var workoutManager: WatchWorkoutManager

    var body: some View {
        VStack {
            Text("Workout Metrics")
                .font(.headline)
                .padding(.bottom, 10)

            HStack {
                VStack(alignment: .leading) {
                    Text("Steps")
                    Text("\(workoutManager.steps)")
                        .font(.title)
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Calories")
                    Text(String(format: "%.1f", workoutManager.caloriesBurned))
                        .font(.title)
                }
                .padding()

                VStack(alignment: .leading) {
                    Text("Distance")
                    Text(String(format: "%.2f miles", workoutManager.distance))
                        .font(.title)
                }
                .padding()
            }
        }
        .padding()
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(workoutManager: WatchWorkoutManager())
    }
}
