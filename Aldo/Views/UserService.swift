//
//  UserService.swift
//  Aldo
//
//  Created by Andrew Katsifis on 1/26/25.
//

import FirebaseFirestore
import FirebaseAuth

class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()

    // This method will search for users based on username or phone number.
    func searchUsers(query: String, completion: @escaping ([User]) -> Void) {
        let usersRef = db.collection("users")

        // Create a query to search for username or phone number that contains the query string
        let usernameQuery = usersRef.whereField("username", isGreaterThanOrEqualTo: query)
                                      .whereField("username", isLessThanOrEqualTo: query + "\u{f8ff}")
        let phoneQuery = usersRef.whereField("phoneNumber", isGreaterThanOrEqualTo: query)
                                  .whereField("phoneNumber", isLessThanOrEqualTo: query + "\u{f8ff}")

        // Fetch users matching the username or phone number
        usernameQuery.getDocuments { (usernameSnapshot, error) in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                completion([])
                return
            }

            var fetchedUsers: [User] = []

            for document in usernameSnapshot!.documents {
                let userData = document.data()
                if let user = try? User.fromFirestore(data: userData, id: document.documentID) {
                    fetchedUsers.append(user)
                }
            }

            // Fetch phone number matches if necessary
            phoneQuery.getDocuments { (phoneSnapshot, error) in
                if let error = error {
                    print("Error fetching users: \(error.localizedDescription)")
                    completion([])
                    return
                }

                for document in phoneSnapshot!.documents {
                    let userData = document.data()
                    if let user = try? User.fromFirestore(data: userData, id: document.documentID) {
                        fetchedUsers.append(user)
                    }
                }

                // Return the fetched users
                completion(fetchedUsers)
            }
        }
    }
}

extension User {
    static func fromFirestore(data: [String: Any], id: String) throws -> User? {
        guard let username = data["username"] as? String,
              let firstName = data["firstName"] as? String,
              let lastName = data["lastName"] as? String,
              let email = data["email"] as? String,
              let phoneNumber = data["phoneNumber"] as? String,
              let friends = data["friends"] as? [String],
              let scoresData = data["scores"] as? [[String: Any]],
              let steps = data["steps"] as? Int else {
                  throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid data"])
              }
        
        var scores: [User.Score] = []
        for scoreData in scoresData {
            if let course = scoreData["course"] as? String, let score = scoreData["score"] as? Int {
                scores.append(User.Score(course: course, score: score))
            }
        }
        
        return User(id: id, username: username, firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber, friends: friends, scores: scores, steps: steps, profilePicture: data["profilePicture"] as? String)
    }
}
