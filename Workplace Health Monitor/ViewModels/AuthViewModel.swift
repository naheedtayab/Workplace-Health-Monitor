import Combine
import FirebaseAuth
import Foundation

class AuthViewModel: ObservableObject {
    @Published var signedIn = false
    @Published var authError: String? // For storing the error message

    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        self.authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { _, user in
            self.signedIn = user != nil
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            // Handle errors or success
            func signUp(email: String, password: String) {
                Auth.auth().createUser(withEmail: email, password: password) { _, error in
                    if let error = error {
                        // Handle error
                        print("Error signing up:", error.localizedDescription)
                    } else {
                        // Handle success
                        print("Sign up successful")
                        self.authError = nil
                    }
                }
            }
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            // Handle errors or success
            if let error = error {
                // Handle error
                print("Error signing in:", error.localizedDescription)
            } else {
                // Handle success
                print("Sign in successful")
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.signedIn = false
        } catch {
            print("Error signing out")
        }
    }
}
