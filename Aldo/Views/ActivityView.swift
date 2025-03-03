//
//  ActivityView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/12/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ActivityView: View {
    @State private var user: User? // Current user's data
    @State private var friends: [Friend] = []
    
    var body: some View {
        NavigationView {
            List {
                // User's Activity Section
                if let user = user {
                    Section(header: Text("Your Activity")) {
                        ForEach(user.scores, id: \.course) { score in
                            HStack(alignment: .top) {
                                if let profilePicture = user.profilePicture, let url = URL(string: profilePicture) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Text("\(user.firstName) \(user.lastName) (\(user.username))")
                                        .font(.headline)
                                    Text("Course: \(score.course)")
                                    Text("Score: \(score.score)")
                                    Text("Date: \(formatDate(Date()))") // Placeholder, adjust as needed
                                    Text("Holes: 18") // Update dynamically if stored
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }

                // Friends' Activity Section
                Section(header: Text("Friends' Activity")) {
                    ForEach(friends) { friend in
                        VStack(alignment: .leading) {
                            HStack {
                                if let profileImageURL = friend.profileImageURL {
                                    AsyncImage(url: profileImageURL) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                Text("\(friend.username)")
                                    .font(.headline)
                            }
                            ForEach(friend.rounds) { round in
                                VStack(alignment: .leading) {
                                    Text("Course: \(round.course)")
                                    Text("Score: \(round.scores.map(String.init).joined(separator: ", "))")
                                    Text("Date: \(formatDate(round.date))")
                                    Text("Holes: \(round.scores.count)") // Number of holes based on scores array
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Activity")
            .onAppear(perform: fetchActivityData)
        }
    }

    private func fetchActivityData() {
        let db = Firestore.firestore()
        
        // Fetch current user
        db.collection("users").document("CURRENT_USER_ID") // Replace with dynamic user ID
            .getDocument { snapshot, error in
                if let error = error {
                    print("Error fetching user: \(error.localizedDescription)")
                    return
                }
                if let snapshot = snapshot {
                    self.user = try? snapshot.data(as: User.self)
                }
            }

        // Fetch friends' data
        db.collection("friends").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching friends: \(error.localizedDescription)")
                return
            }
            if let documents = snapshot?.documents {
                self.friends = documents.compactMap { doc in
                    try? doc.data(as: Friend.self)
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// MARK: - Models

struct User: Identifiable, Codable {
    let id: String
    var username: String
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var friends: [String]
    var scores: [Score]
    var steps: Int
    var profilePicture: String?

    struct Score: Codable {
        let course: String
        let score: Int
    }
}

struct Friend: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var profileImageURL: URL?
    var rounds: [GolfRound]
}

struct GolfRound: Identifiable, Codable {
    @DocumentID var id: String?
    var course: String
    var scores: [Int]
    var steps: Int
    var distance: Double
    var caloriesBurned: Double
    var date: Date
}
