import SwiftUI
import AuthenticationServices

// Custom wrapper for the Sign In with Apple button
struct CustomSignInWithAppleButton: UIViewRepresentable {
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.translatesAutoresizingMaskIntoConstraints = false // Disable autoresizing mask constraints
        return button
    }

    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        // No updates required for this button
    }
}

class WelcomeViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @AppStorage("hasShownWelcome") private var hasShownWelcome = false
    @State private var isSignedIn = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func performAppleSignIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            print("Apple ID Credential - User: \(userIdentifier), Full Name: \(String(describing: fullName)), Email: \(String(describing: email))")

            self.isSignedIn = true
            hasShownWelcome = true // Mark welcome as shown
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Failed to sign in with Apple: \(error.localizedDescription)")
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}

// SwiftUI View that wraps the ViewController for Sign In with Apple
struct WelcomeView: View {
    @AppStorage("hasShownWelcome") private var hasShownWelcome = false
    @State private var isSignedIn = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background Image with resized size
                Image("newAldo")
                    .resizable()
                    .scaledToFit() // Change this to .scaledToFit() for proportional resizing
                    .frame(width: 500, height: 500) // Adjust the width and height to make it smaller
                    .clipped() // Ensure it doesn't overflow the frame
                    .padding(.top, 50) // Adjust to add space above the image if needed

                VStack {
                    Text("Welcome to")
                        .font(.system(size: 60, weight: .heavy, design: .rounded)) // Large, heavy system font
                        .foregroundColor(.black)
                        .padding(.top, 200) // Space from the top of the screen
                        .padding(.bottom, 50) // Space below the text


                    Spacer() // Spacer to push the next elements down

                    // Buttons at the bottom
                    VStack(spacing: 20) {
                        NavigationLink(destination: LoginView()) {
                            Text("Log In")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal, 40)

                        NavigationLink(destination: SignUpView()) {
                            Text("Sign Up")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal, 40)

                        // Custom Sign In with Apple Button
                        CustomSignInWithAppleButton()
                            .frame(height: 50)
                            .padding(.horizontal, 40)
                            .accessibilityLabel(Text("Sign in with Apple"))
                            .onTapGesture {
                                performAppleSignIn()
                            }
                    }
                    .padding(.bottom, 40) // Adjust the bottom padding to position the buttons better
                }
                .padding()
            }
        }
    }

    private func performAppleSignIn() {
        let viewController = WelcomeViewController()
        viewController.performAppleSignIn()
    }
}

// Root view to manage app state
struct RootView: View {
    @AppStorage("hasShownWelcome") private var hasShownWelcome = false
    
    var body: some View {
        Group {
            if !hasShownWelcome {
                WelcomeView()
            } else {
                MainView()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
