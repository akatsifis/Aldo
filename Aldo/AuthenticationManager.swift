//
//  AuthenticationManager.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/12/24.
//
import SwiftUI
import Combine
import Firebase

class AuthenticationManager: ObservableObject {
    @Published var users: [AppUser] = []
    @Published var friendRequests: [AppUser] = []
    @Published var currentUser: AppUser?
    @Published var isAuthenticated = false

    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Failed to sign in: \(error.localizedDescription)")
                completion(false, error.localizedDescription) // Pass error message
                return
            }
            self.isAuthenticated = true
            self.currentUser = AppUser(username: email, profilePicture: "", isFriendRequestPending: false) // Update with actual user info
            completion(true, nil) // No error message
        }
    }

    func signUp(email: String, password: String, username: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Failed to sign up: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let uid = authResult?.user.uid {
                let db = Firestore.firestore()
                db.collection("users").document(uid).setData([
                    "username": username,
                    "email": email
                ]) { error in
                    if let error = error {
                        print("Failed to save user: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    completion(true)
                }
            } else {
                completion(false)
            }
        }
    }

    func checkLoginStatus() {
        self.isAuthenticated = true
        self.currentUser = AppUser(username: "test@example.com", profilePicture: "", isFriendRequestPending: false)
    }

    func logout() {
        self.isAuthenticated = false
        self.currentUser = nil
    }

    func fetchUsers(completion: @escaping ([AppUser]) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching users: \(error)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("No users found")
                return
            }

            let users = documents.map { doc -> AppUser in
                let data = doc.data()
                let username = data["username"] as? String ?? ""
                let profilePicture = data["profilePicture"] as? String ?? ""
                let isFriendRequestPending = data["isFriendRequestPending"] as? Bool ?? false
                return AppUser(username: username, profilePicture: profilePicture, isFriendRequestPending: isFriendRequestPending)
            }
            self.users = users
            completion(users)
        }
    }

    func fetchFriendRequests() {
        // Fetch friend requests logic
    }

    func acceptFriendRequest(_ user: AppUser, completion: @escaping (Bool) -> Void) {
        // Accept friend request logic
    }
}
