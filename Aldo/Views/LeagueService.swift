//
//  LeagueService.swift
//  Aldo
//
//  Created by Andrew Katsifis on 1/26/25.
//
//
//  LeagueService.swift
//  Aldo
//
//  Created by Andrew Katsifis on 1/26/25.
//

import FirebaseFirestore

class LeagueService {
    static let shared = LeagueService()
    private let db = Firestore.firestore()
    
    // MARK: - Create a New League
    func createLeague(name: String, hostUserId: String, completion: @escaping (String?) -> Void) {
        let leagueData: [String: Any] = [
            "name": name,
            "hostUserId": hostUserId,
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("leagues").addDocument(data: leagueData) { error in
            if let error = error {
                print("Error creating league: \(error.localizedDescription)")
                completion(nil)
            } else {
                print("League created successfully!")
                completion(nil)
            }
        }
    }
    
    // MARK: - Add Round to League
    func addRoundToLeague(leagueId: String, round: League.Round, completion: @escaping (Bool) -> Void) {
        let roundData: [String: Any] = [
            "number": round.number,
            "score": round.score
        ]
        
        db.collection("leagues").document(leagueId).collection("rounds").addDocument(data: roundData) { error in
            if let error = error {
                print("Error adding round: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Round added successfully!")
                completion(true)
            }
        }
    }
    
    // MARK: - Update Scores for a Round
    func updateScores(leagueId: String, roundId: String, score: League.Round.Score, completion: @escaping (Bool) -> Void) {
        let scoreData: [String: Any] = [
            "userId": score.userId,
            "holeScores": score.holeScores
        ]
        
        let scoresRef = db.collection("leagues").document(leagueId).collection("rounds").document(roundId).collection("scores").document(score.id.uuidString)
        scoresRef.setData(scoreData) { error in
            if let error = error {
                print("Error updating score: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Score updated successfully!")
                completion(true)
            }
        }
    }
}
