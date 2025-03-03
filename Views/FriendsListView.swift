//
//  FriendsListView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/24/24.
//

import SwiftUI
import FirebaseFirestore

struct FriendsListView: View {
    @State private var friends: [AppFriend] = []
    @State private var searchQuery: String = "" // Store the search query
    @State private var friendToAdd: String = ""
    @State private var showAddFriendSheet = false
    @State private var alertMessage = ""
    @State private var showAlert = false

    // Assume current username is passed directly, replace with your actual method of retrieving the current user
    @State private var currentUsername: String = "testUser"  // Replace with your actual username retrieval method
    
    @State private var filteredFriends: [AppFriend] = []

    var body: some View {
        NavigationView {
            VStack {
                // Search bar
                SearchBar(text: $searchQuery)
                    .padding()

                List(filteredFriends) { friend in
                    NavigationLink(destination: FriendDetailView(friend: friend)) {
                        HStack {
                            Image(friend.profilePicture)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                            Text(friend.username)
                                .font(.headline)
                        }
                    }
                }
                .navigationTitle("Friends")
                .navigationBarItems(trailing: Button(action: {
                    showAddFriendSheet.toggle()
                }) {
                    Image(systemName: "plus")
                        .imageScale(.large)
                })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .sheet(isPresented: $showAddFriendSheet) {
                AddFriendView(friendsList: $friends, currentUsername: currentUsername)
            }
            .onAppear {
                fetchFriendsFromFirestore()
            }
            .onChange(of: searchQuery) { _ in
                filterFriends()
            }
        }
    }

    private func fetchFriendsFromFirestore() {
        // Fetch friends from Firestore based on current username or other criteria
        let db = Firestore.firestore()
        db.collection("friends").whereField("username", isEqualTo: currentUsername)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching friends: \(error)")
                } else {
                    // Parse documents into AppFriend objects
                    friends = snapshot?.documents.compactMap { doc in
                        let data = doc.data()
                        let username = data["username"] as? String ?? ""
                        let phoneNumber = data["phoneNumber"] as? String ?? ""
                        let profilePicture = data["profilePicture"] as? String ?? "defaultProfilePic"
                        return AppFriend(username: username, phoneNumber: phoneNumber, profilePicture: profilePicture)
                    } ?? []
                    filteredFriends = friends // Initialize filtered friends
                }
            }
    }

    private func filterFriends() {
        // Filter friends by username or phone number
        if searchQuery.isEmpty {
            filteredFriends = friends
        } else {
            filteredFriends = friends.filter {
                $0.username.lowercased().contains(searchQuery.lowercased()) || $0.phoneNumber.contains(searchQuery)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        TextField("Search by username or phone number", text: $text)
            .padding(10)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Spacer()
                    if !text.isEmpty {
                        Button(action: {
                            text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.trailing, 10)
            )
    }
}

struct AddFriendView: View {
    @State private var friendUsername: String = ""
    @State private var friendPhoneNumber: String = ""
    @Binding var friendsList: [AppFriend]
    var currentUsername: String

    var body: some View {
        VStack {
            TextField("Friend's Username", text: $friendUsername)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.bottom)

            TextField("Friend's Phone Number", text: $friendPhoneNumber)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.bottom)

            Button(action: addFriend) {
                Text("Add Friend")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .padding()
    }

    private func addFriend() {
        let db = Firestore.firestore()
        
        // Ensure the friend isn't already in the list
        if !friendsList.contains(where: { $0.username == friendUsername || $0.phoneNumber == friendPhoneNumber }) {
            let newFriend = AppFriend(username: friendUsername, phoneNumber: friendPhoneNumber, profilePicture: "defaultProfilePic")
            
            // Add friend to Firestore
            db.collection("friends").addDocument(data: [
                "username": friendUsername,
                "phoneNumber": friendPhoneNumber,
                "profilePicture": "defaultProfilePic"
            ]) { error in
                if let error = error {
                    print("Error adding friend: \(error)")
                } else {
                    friendsList.append(newFriend)
                }
            }
        }
    }
}

struct FriendDetailView: View {
    var friend: AppFriend

    var body: some View {
        VStack {
            Image(friend.profilePicture)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 4))
            Text(friend.username)
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
        .padding()
        .navigationTitle(friend.username)
    }
}

struct FriendsListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsListView()
    }
}

struct AppFriend: Identifiable {
    var id: String = UUID().uuidString
    var username: String
    var phoneNumber: String
    var profilePicture: String
}
