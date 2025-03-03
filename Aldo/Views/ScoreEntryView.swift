//
//  ScoreEntryView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/12/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth // Import Firebase Authentication to access the logged-in user

struct ScoreEntryView: View {
    @State private var scores: [Int] = Array(repeating: 0, count: 18)
    @State private var selectedCourse = ""
    @State private var courses = ["Armitage", "Rich Valley", "Range End", "Cumberland", "Mayapple", "Dauphin Highlands"]
    @State private var playNineHoles = false
    @State private var frontNine = true
    @State private var totalScore: Int = 0
    @State private var username: String = "" // Username will be pulled automatically
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isPressed = false // For button animation

    @EnvironmentObject var workoutManager: iOSWorkoutManager

    private var loggedInUsername: String {
        Auth.auth().currentUser?.displayName ?? "Guest"
    }

    var body: some View {
        NavigationView {
            VStack {
                workoutStatsSection

                Picker("Select Course", selection: $selectedCourse) {
                    ForEach(courses, id: \.self) { course in
                        Text(course)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()

                if playNineHoles {
                    Picker("Select Front or Back Nine", selection: $frontNine) {
                        Text("Front Nine").tag(true)
                        Text("Back Nine").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Quick Entry")
                        .font(.headline)

                    HStack {
                        Text("Total Score: \(totalScore)")
                            .font(.title2)
                            .padding()

                        Button(action: submitQuickScore) {
                            Text("Submit")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                    }

                    Text("Logged in as: \(loggedInUsername)")
                        .font(.footnote)
                        .padding(.top, 5)
                }
                .padding()

                let holes = determineHolesToPlay()

                List {
                    ForEach(holes, id: \.self) { hole in
                        NavigationLink(
                            destination: IndividualHoleView(
                                score: $scores[hole],
                                holeNumber: hole + 1,
                                totalHoles: playNineHoles ? 9 : 18,
                                workoutManager: workoutManager
                            )
                        ) {
                            HStack {
                                Text("Hole \(hole + 1)")
                                Spacer()
                                Text("\(scores[hole])")
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())

                if scores.filter({ $0 == 0 }).isEmpty {
                    submitButton
                        .transition(.move(edge: .bottom))
                        .animation(.spring(), value: scores)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Submission Status"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Enter Scores")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: scores) { _ in
                updateTotalScore()
            }
        }
        .onAppear {
            username = loggedInUsername
        }
    }

    private var workoutStatsSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Workout Stats")
                .font(.headline)
            Text("Steps: \(workoutManager.steps)")
            Text("Distance: \(String(format: "%.2f miles", workoutManager.distance))")
            Text("Calories: \(String(format: "%.0f kcal", workoutManager.caloriesBurned))")
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding([.leading, .trailing, .top])
    }

    private var submitButton: some View {
        Button(action: submitScores) {
            Text("Submit Scores/Workout")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(15)
                .shadow(radius: 10)
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.easeInOut, value: isPressed)
        }
        .padding()
        .onTapGesture {
            isPressed.toggle()
        }
    }

    private func determineHolesToPlay() -> Range<Int> {
        if playNineHoles {
            return frontNine ? 0..<9 : 9..<18
        }
        return 0..<18
    }

    private func updateTotalScore() {
        totalScore = scores.reduce(0, +)
    }

    private func submitScores() {
        let scoreEntry = ScoreEntry(
            course: selectedCourse,
            holesPlayed: playNineHoles ? (frontNine ? "Front Nine" : "Back Nine") : "18 Holes",
            scores: scores,
            totalScore: totalScore,
            username: username,
            steps: workoutManager.steps,
            distance: workoutManager.distance,
            caloriesBurned: workoutManager.caloriesBurned,
            date: Date()
        )
        saveScoreEntryToFirestore(scoreEntry: scoreEntry)
    }

    private func submitQuickScore() {
        let scoreEntry = ScoreEntry(
            course: selectedCourse,
            holesPlayed: playNineHoles ? (frontNine ? "Front Nine" : "Back Nine") : "18 Holes",
            scores: scores,
            totalScore: totalScore,
            username: username,
            steps: workoutManager.steps,
            distance: workoutManager.distance,
            caloriesBurned: workoutManager.caloriesBurned,
            date: Date()
        )
        saveScoreEntryToFirestore(scoreEntry: scoreEntry)
    }

    private func saveScoreEntryToFirestore(scoreEntry: ScoreEntry) {
        let db = Firestore.firestore()
        db.collection("scores").addDocument(data: scoreEntry.toDictionary()) { error in
            if let error = error {
                alertMessage = "Error saving score: \(error.localizedDescription)"
            } else {
                alertMessage = "Score successfully saved!"
            }
            showAlert = true
        }
    }
}

struct ScoreEntry {
    var course: String
    var holesPlayed: String
    var scores: [Int]
    var totalScore: Int
    var username: String
    var steps: Int
    var distance: Double
    var caloriesBurned: Double
    var date: Date

    func toDictionary() -> [String: Any] {
        return [
            "course": course,
            "holesPlayed": holesPlayed,
            "scores": scores,
            "totalScore": totalScore,
            "username": username,
            "steps": steps,
            "distance": distance,
            "caloriesBurned": caloriesBurned,
            "date": date
        ]
    }
}

struct ScoreEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreEntryView()
            .environmentObject(iOSWorkoutManager()) // Provide a mock environment object for previews
    }
}
