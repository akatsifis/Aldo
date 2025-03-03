//
//  ContentView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/12/24.
//
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainView()
            } else {
                WelcomeView()
            }
        }
        .onAppear {
            authManager.checkLoginStatus()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationManager())
    }
}
