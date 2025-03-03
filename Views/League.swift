//
//  League.swift
//  Aldo
//
//  Created by Andrew Katsifis on 1/26/25.
//

import Foundation
struct League {
    struct Round {
        var id: UUID
        var number: Int
        var score: Int
        var scores: [Score] // If needed, you can store multiple scores per round
        
        struct Score {
            var id: UUID
            var userId: String
            var holeScores: [Int] // Scores for each hole in the round
        }
    }
}
