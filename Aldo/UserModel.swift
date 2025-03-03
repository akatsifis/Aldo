// UserModel.swift
// Aldo
//
// Created by Andrew Katsifis on 6/12/24.

import Foundation

struct Models {
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
}
