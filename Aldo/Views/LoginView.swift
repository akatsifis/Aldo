//
//  LoginView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/12/24.
//
// In LoginView.swift

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String? = nil
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
                .padding(.bottom, 20)

            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 10)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)

            Button(action: {
                authManager.signIn(email: email, password: password) { success, error in
                    if success {
                        // Handle successful login (e.g., navigate to home screen)
                    } else {
                        // Show error message if sign-in fails
                        errorMessage = error ?? "Login failed. Please try again."
                    }
                }
            }) {
                Text("Sign In")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }

            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationManager())
    }
}
