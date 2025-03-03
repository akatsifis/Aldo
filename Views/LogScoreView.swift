//
//  LogScoreView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/12/24.
//

import SwiftUI

struct LogScoreView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var selectedUser: AppUser?
    
    var body: some View {
        VStack {
            Picker("Select User", selection: $selectedUser) {
                ForEach(authManager.users) { user in
                    Text(user.username).tag(user as AppUser?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding()
            
            if let user = selectedUser {
                // Display user's scores or other relevant information
                Text("Selected User: \(user.username)")
                // Add more views to display user's scores, workout stats, etc.
            }
            
            Spacer()
        }
        .navigationTitle("Log Score")
    }
}

struct LogScoreView_Previews: PreviewProvider {
    static var previews: some View {
        LogScoreView()
            .environmentObject(AuthenticationManager())
    }
}
