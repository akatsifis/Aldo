//
//  SignUpView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/12/24.
//
// In SignUpView.swift

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseFirestore

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var phoneNumber: String = ""
    @State private var bio: String = ""
    @State private var location: String = ""
    @State private var profilePicture: UIImage? = nil
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showImagePicker = false
    
    // List of prohibited words
    let prohibitedWords = ["badword1", "badword2"] // Replace with actual list of prohibited words
    
    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            // Profile Picture Section
            VStack {
                if let profilePicture = profilePicture {
                    Image(uiImage: profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .padding()
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                        .padding()
                }

                Button(action: {
                    showImagePicker = true
                }) {
                    Text("Select Profile Picture")
                        .foregroundColor(.blue)
                }
            }

            // Username Field
            TextField("Username", text: $username)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            // Email Field
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            // Phone Number Field
            TextField("Phone Number", text: $phoneNumber)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
                .keyboardType(.phonePad)
            
            // Bio Field
            TextField("Bio", text: $bio)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            // Location Field
            TextField("Location", text: $location)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            // Password Fields
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 20)
            
            // Sign Up Button
            Button(action: {
                signUp()
            }) {
                Text("Sign Up")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
            
            // Error Message
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $profilePicture)
        }
    }
    
    private func signUp() {
        guard validateInputs() else { return }
        
        // Create Firebase Authentication User
        authManager.signUp(email: email, password: password, username: username) { success in
            if !success {
                errorMessage = "Sign up failed. Please try again."
                showError = true
            } else {
                uploadProfilePicture { profilePictureURL in
                    saveUserData(profilePictureURL: profilePictureURL)
                }
            }
        }
    }
    
    private func validateInputs() -> Bool {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            errorMessage = "All fields are required."
            showError = true
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            showError = true
            return false
        }
        
        guard isValidEmail(email) else {
            errorMessage = "Invalid email format."
            showError = true
            return false
        }
        
        guard validateUsername() else {
            return false
        }
        
        return true
    }
    
    private func validateUsername() -> Bool {
        // Check for prohibited words
        for word in prohibitedWords {
            if username.lowercased().contains(word) {
                errorMessage = "Username contains prohibited language."
                showError = true
                return false
            }
        }
        
        // Check for duplicate username
        // Replace this with your actual data fetching logic
        let existingUsernames = ["ExistingUser1", "ExistingUser2"] // Replace with actual data fetch
        if existingUsernames.contains(username) {
            errorMessage = "Username is already taken."
            showError = true
            return false
        }
        
        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func uploadProfilePicture(completion: @escaping (String?) -> Void) {
        guard let image = profilePicture else {
            completion(nil)
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference().child("profile_pictures/\(UUID().uuidString).jpg")
        
        if let imageData = image.jpegData(compressionQuality: 0.75) {
            storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                if let error = error {
                    self.errorMessage = "Error uploading image: \(error.localizedDescription)"
                    self.showError = true
                    completion(nil)
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let url = url {
                            completion(url.absoluteString)
                        } else {
                            self.errorMessage = "Error getting image URL."
                            self.showError = true
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    private func saveUserData(profilePictureURL: String?) {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Error: User not authenticated."
            showError = true
            return
        }
        
        var userData: [String: Any] = [
            "username": username,
            "email": email,
            "phoneNumber": phoneNumber,
            "bio": bio,
            "location": location,
            "profilePictureURL": profilePictureURL ?? "",
        ]
        
        Firestore.firestore().collection("users").document(userId).setData(userData) { error in
            if let error = error {
                self.errorMessage = "Error saving data: \(error.localizedDescription)"
                self.showError = true
            } else {
                // Sign in the user immediately after sign up
                self.authManager.signIn(email: self.email, password: self.password) { success, error in
                    if !success {
                        self.errorMessage = error ?? "Login failed after sign up. Please try again."
                        self.showError = true
                    }
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthenticationManager())
    }
}
