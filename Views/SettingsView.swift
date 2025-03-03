//
//  SettingsView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/12/24.
//
////
//  SettingsView.swift
//  Aldo
//
//  Created by Andrew Katsifis on 6/12/24.
//

import SwiftUI
import FirebaseStorage // Assuming you are using Firebase for storage

struct SettingsView: View {
    @State private var username = "User1" // Default value
    @State private var profilePicture: UIImage? = nil
    @State private var profilePictureURL: String? = nil // URL to fetch the profile picture
    @State private var phoneNumber = "" // User's phone number
    @State private var email = "" // User's email address
    @State private var bio = "" // User's bio
    @State private var location = "" // User's location
    @State private var notificationsEnabled = true // Notification preference
    @State private var selectedLanguage = "English" // User's language preference
    @State private var newPassword = "" // New password for the user
    @State private var showImagePicker = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // List of prohibited words
    let prohibitedWords = ["badword1", "badword2"] // Replace with actual list of prohibited words

    var body: some View {
        NavigationView {
            Form {
                // Profile Picture Section
                Section(header: Text("Profile Picture")) {
                    VStack {
                        if let profilePicture = profilePicture {
                            Image(uiImage: profilePicture)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 10)
                                .padding()
                        } else if let urlString = profilePictureURL, let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .padding()
                            } placeholder: {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 100, height: 100)
                                    .padding()
                            }
                        } else {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 100, height: 100)
                                .padding()
                        }

                        Button(action: {
                            showImagePicker = true
                        }) {
                            Text("Change Picture")
                                .foregroundColor(.blue)
                        }
                    }
                }

                // Username Section
                Section(header: Text("Username")) {
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                // Phone Number Section
                Section(header: Text("Phone Number")) {
                    TextField("Phone Number", text: $phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .keyboardType(.phonePad)
                }

                // Email Address Section
                Section(header: Text("Email Address")) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .keyboardType(.emailAddress)
                }

                // Bio Section
                Section(header: Text("Bio")) {
                    TextField("Tell us about yourself", text: $bio)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                // Location Section
                Section(header: Text("Location")) {
                    TextField("Location", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                // Password Section
                Section(header: Text("Password")) {
                    SecureField("New Password", text: $newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                // Notifications Section
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                        .padding(.horizontal)
                }

                // Language Section
                Section(header: Text("Language")) {
                    Picker("Language", selection: $selectedLanguage) {
                        Text("English").tag("English")
                        Text("Spanish").tag("Spanish")
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                }
                
                // Save Button
                Button(action: saveSettings) {
                    Text("Save Settings")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $profilePicture)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .onAppear(perform: loadUserData) // Load the data when the view appears
    }

    // Load User Data
    private func loadUserData() {
        // Load data from UserDefaults
        if let savedUsername = UserDefaults.standard.string(forKey: "username") {
            username = savedUsername
        }
        
        if let savedPhoneNumber = UserDefaults.standard.string(forKey: "phoneNumber") {
            phoneNumber = savedPhoneNumber
        }
        
        if let savedEmail = UserDefaults.standard.string(forKey: "email") {
            email = savedEmail
        }
        
        if let savedBio = UserDefaults.standard.string(forKey: "bio") {
            bio = savedBio
        }
        
        if let savedLocation = UserDefaults.standard.string(forKey: "location") {
            location = savedLocation
        }
        
        if let savedNotificationsEnabled = UserDefaults.standard.value(forKey: "notificationsEnabled") as? Bool {
            notificationsEnabled = savedNotificationsEnabled
        }
        
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            selectedLanguage = savedLanguage
        }
        
        // Load the profile picture URL if saved
        profilePictureURL = UserDefaults.standard.string(forKey: "profilePictureURL")
        
        if let urlString = profilePictureURL, let url = URL(string: urlString) {
            fetchImage(from: url) { image in
                if let image = image {
                    profilePicture = image
                }
            }
        }
    }

    // Fetch Image
    private func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                completion(nil)
            }
        }.resume()
    }

    // Save Settings
    private func saveSettings() {
        guard validateUsername() else { return }

        // Save data to UserDefaults
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(bio, forKey: "bio")
        UserDefaults.standard.set(location, forKey: "location")
        UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        UserDefaults.standard.set(selectedLanguage, forKey: "selectedLanguage")
        
        // Upload new profile picture if changed
        if let inputImage = profilePicture {
            uploadImage(inputImage) { urlString in
                profilePictureURL = urlString
                UserDefaults.standard.set(urlString, forKey: "profilePictureURL")
            }
        }
        
        print("Settings saved for username \(username)")
    }
    
    // Validate Username
    private func validateUsername() -> Bool {
        // Check for prohibited words
        for word in prohibitedWords {
            if username.lowercased().contains(word) {
                alertMessage = "Username contains prohibited language."
                showAlert = true
                return false
            }
        }
        
        // Check for duplicate username
        // Replace this with your actual data fetching logic
        let existingUsernames = ["ExistingUser1", "ExistingUser2"] // Replace with actual data fetch
        if existingUsernames.contains(username) {
            alertMessage = "Username is already taken."
            showAlert = true
            return false
        }
        
        return true
    }

    // Upload Image
    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        let storageRef = Storage.storage().reference().child("profilePictures/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                print("Failed to upload image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("Failed to get download URL: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }

                completion(downloadURL.absoluteString)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
