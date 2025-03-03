import SwiftUI

struct ActivityAndTransportPromptView: View {
    @State private var isTracking: Bool = false
    @State private var isWalking: Bool = false
    @State private var step = 0 // To track which prompt to show
    @State private var selectedCourse: GolfCourse? = nil // Change to GolfCourse? type
    @State private var playNineHoles: Bool = false // Default to 18 holes
    @EnvironmentObject var workoutManager: iOSWorkoutManager

    @State private var showingScoreEntryView = false // Control showing ScoreEntryView

    var body: some View {
        NavigationView {
            VStack {
                if step == 0 {
                    // Step 0: Track Workout Prompt
                    Text("Do you want to track your workout?")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    HStack {
                        Button(action: {
                            isTracking = true
                            step = 1
                        }) {
                            Text("Yes")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)

                        Button(action: {
                            isTracking = false
                            step = 1
                        }) {
                            Text("No")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                } else if step == 1 {
                    // Step 1: Walking or Riding Prompt
                    Text("Are you walking or riding?")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    HStack {
                        Button(action: {
                            isWalking = true
                            step = 2
                        }) {
                            VStack {
                                Image(systemName: "figure.walk")
                                    .font(.largeTitle)
                                Text("Walking")
                                    .font(.title2)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)

                        Button(action: {
                            isWalking = false
                            step = 2
                        }) {
                            VStack {
                                Image(systemName: "car.fill")
                                    .font(.largeTitle)
                                Text("Riding")
                                    .font(.title2)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                } else if step == 2 {
                    // Step 2: Select Course and Holes
                    Text("Select Course and Holes")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    // Select Course Button
                    if selectedCourse == nil {
                        NavigationLink(destination: CourseSearchView(selectedCourse: $selectedCourse)) {
                            Text("Select Course")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }

                    // Course Selection
                    if let selectedCourse = selectedCourse {
                        Text("Selected Course: \(selectedCourse.name)")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.vertical)
                    }

                    // Holes Selection
                    VStack {
                        Toggle("Play 9 Holes", isOn: $playNineHoles)
                            .toggleStyle(SwitchToggleStyle(tint: .green))
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                            .padding(.horizontal)

                        if playNineHoles {
                            Text("Playing 9 Holes")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                        } else {
                            Text("Playing 18 Holes")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                        }
                    }

                    // Let's Go Button
                    Button(action: {
                        if isTracking {
                            workoutManager.startWorkoutOnWatch()
                        }
                        showingScoreEntryView = true // Set this to true to trigger sheet presentation
                    }) {
                        Text("Let's Go")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(
                Image("Golf")
            )
            .navigationTitle("Start Round")
            .sheet(isPresented: $showingScoreEntryView) {
                ScoreEntryView() // Ensure ScoreEntryView is initialized with no parameters
            }
        }
    }
}

struct ActivityAndTransportPromptView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityAndTransportPromptView()
            .environmentObject(iOSWorkoutManager()) // Provide a mock environment object for previews
    }
}
