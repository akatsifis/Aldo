import SwiftUI

struct MainView: View {
    @EnvironmentObject var authManager: AuthenticationManager // Access the auth manager from the environment
    
    // Set a fixed size for buttons
    let buttonWidth: CGFloat = 300
    let buttonHeight: CGFloat = 60

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image
                Image("Armitage")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    Spacer()

                    // "Play Now" button
                    NavigationLink(destination: ActivityAndTransportPromptView()) {
                        Text("Play Now")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color.black.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    // "View Activity" button
                    NavigationLink(destination: ActivityView()) {
                        Text("View Activity")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color.black.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    // "Add Previous Score" button
                    NavigationLink(destination: LogScoreView()) {
                        Text("Add Previous Score")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color.black.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    // "View Friends" button
                    NavigationLink(destination: FriendsListView()) {
                        Text("View Friends")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color.black.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    // "Add Friend" button
                    NavigationLink(destination: FriendRequestView()) {
                        Text("Add Friend")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color.black.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    // "View Profile" button
                    NavigationLink(destination: SettingsView()) {
                        Text("View Profile")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color.black.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    // "League Play" button
                    NavigationLink(destination: LeaguePlayView()) {
                        Text("League Play")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color.black.opacity(0.9))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    // "Log Out" button
                    Button(action: {
                        authManager.logout()
                    }) {
                        Text("Log Out")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 12)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color.red.opacity(0.7))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }

                    Spacer() // To ensure buttons are positioned towards the top

                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct LeaguePlayView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose an option to proceed")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            // "Create a League" button
            NavigationLink("Create a League", destination: CreateLeagueView())
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.black)
                .cornerRadius(10)
                .shadow(radius: 5)

            // "Search Leagues" button
            NavigationLink("Search for a League", destination: SearchLeaguesView())
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)

            Spacer()
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AuthenticationManager()) // Provide a mock environment object for previews
    }
}
