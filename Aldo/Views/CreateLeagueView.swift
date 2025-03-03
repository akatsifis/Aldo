import SwiftUI

struct CreateLeagueView: View {
    @State private var searchQuery = ""
    @State private var users: [User] = []
    
    var body: some View {
        VStack {
            // Search Bar
            TextField("Search by username or phone number", text: $searchQuery)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .onChange(of: searchQuery) { newValue in
                    // Call search function when the query changes
                    if newValue.isEmpty {
                        users = [] // Clear users if search query is empty
                    } else {
                        searchUsers(query: newValue) // Fetch users based on the query
                    }
                }
            
            // Display search results
            List(users, id: \.id) { user in
                HStack {
                    // Display Profile Picture
                    if let profilePicture = user.profilePicture {
                        // Check if it's a valid image path or base64-encoded data
                        if let imageData = Data(base64Encoded: profilePicture),
                           let uiImage = UIImage(data: imageData) {
                            // If profilePicture is base64 encoded, decode it to UIImage
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        } else if let imagePath = user.profilePicture,
                                  let uiImage = UIImage(contentsOfFile: imagePath) {
                            // If it's a file path, load the image from the file system
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        } else {
                            // Fallback in case profilePicture is invalid
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        }
                    } else {
                        // If profilePicture is nil, show default image
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                    
                    // Display Username and Phone Number
                    VStack(alignment: .leading) {
                        Text(user.username)
                            .font(.headline)
                        Text(user.phoneNumber)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
            }
        }
        .padding()
        .navigationTitle("Create League")
    }
    
    // Search function to fetch users based on query
    private func searchUsers(query: String) {
        UserService.shared.searchUsers(query: query) { fetchedUsers in
            self.users = fetchedUsers
        }
    }
}

struct CreateLeagueView_Previews: PreviewProvider {
    static var previews: some View {
        CreateLeagueView()
    }
}
