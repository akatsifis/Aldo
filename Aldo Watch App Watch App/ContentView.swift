//  ContentView.swift
//  Aldo Watch App Watch App
//
//  Created by Andrew Katsifis on 6/12/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var workoutManager: WatchWorkoutManager

    var body: some View {
        VStack {
            Text("Steps: \(workoutManager.steps)")
                .foregroundColor(.white)
            Text("Distance: \(String(format: "%.2f", workoutManager.distance)) miles")
                .foregroundColor(.white)
            Text("Calories: \(String(format: "%.2f", workoutManager.caloriesBurned)) kcal")
                .foregroundColor(.white)
        }
        .padding()
        .background(
            Image("Golf")
                .resizable()
                .scaledToFill()
        )
    }
}

#Preview {
    ContentView()
        .environmentObject(WatchWorkoutManager())
}
