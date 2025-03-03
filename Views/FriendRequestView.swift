//
//  FriendRequestView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/12/24.
//

import SwiftUI

struct FriendRequestView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        List {
            ForEach(authManager.friendRequests, id: \.id) { user in
                HStack {
                    Text(user.username)
                    Spacer()
                    Button(action: {
                        acceptFriendRequest(user)
                    }) {
                        Text("Accept")
                            .padding(8)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
        }
        .onAppear {
            authManager.fetchFriendRequests()
        }
    }

    private func acceptFriendRequest(_ user: AppUser) {
        authManager.acceptFriendRequest(user) { success in
            if success {
                print("Friend request accepted")
            } else {
                print("Failed to accept friend request")
            }
        }
    }
}

struct FriendRequestView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestView()
            .environmentObject(AuthenticationManager())
    }
}
