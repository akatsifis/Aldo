//
//  AppUser.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/24/24.
//


import Foundation

struct AppUser: Identifiable, Hashable {
    let id = UUID()
    let username: String
    let profilePicture: String
    var isFriendRequestPending: Bool

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
