//
//  ScoreService.swift
//  Aldo
//
//  Created by Andrew Katsifis on 1/26/25.
//

import FirebaseFirestore

class ScoreService {
    static let shared = ScoreService()
    private let db = Firestore.firestore()
    
    func updateScores(leagueId: String, roundId: String, score: Score, completion: @escaping (Bool) -> Void) {
        // Reference to Firestore document for the score
        let scoresRef = db.collection("leagues").document(leagueId).collection("rounds").document(roundId).collection("scores").document(score.id)
        
        // Set the data for the score
        scoresRef.setData([
            "userId": score.userId,
            "holeScores": score.holeScores
        ]) { error in
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
