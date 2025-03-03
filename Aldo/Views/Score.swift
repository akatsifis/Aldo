//
//  Score.swift
//  Aldo
//
//  Created by Andrew Katsifis on 1/26/25.
//


import Foundation

struct Score: Identifiable {
    var id: String
    var userId: String
    var holeScores: [Int]  // Array to hold scores for each hole (or whatever structure you want)
}
