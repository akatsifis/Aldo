//  IndividualHoleView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/23/24.
//


import SwiftUI

struct IndividualHoleView: View {
    @Binding var score: Int
    var holeNumber: Int
    var totalHoles: Int
    @ObservedObject var workoutManager: iOSWorkoutManager
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            // Workout stats at the top
            VStack {
                Text("Steps: \(workoutManager.steps)")
                Text("Distance: \(String(format: "%.2f", workoutManager.distance)) miles")
                Text("Calories: \(String(format: "%.2f", workoutManager.caloriesBurned)) kcal")
            }
            .padding()

            // Hole details and score input
            VStack {
                Text("Hole \(holeNumber)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                Stepper(value: $score, in: 0...10) {
                    Text("Score: \(score)")
                        .font(.title)
                }
                .padding()

                HStack {
                    Button(action: {
                        if holeNumber > 1 {
                            // Navigate to previous hole
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Previous Hole")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    .disabled(holeNumber == 1)

                    Button(action: {
                        if holeNumber < totalHoles {
                            // Navigate to next hole
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Next Hole")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(holeNumber == totalHoles)
                }
                .padding(.top, 20)
            }

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                Text("Back to Round")
            }
        })
        .padding()
        .navigationTitle("Hole \(holeNumber)")
    }
}
