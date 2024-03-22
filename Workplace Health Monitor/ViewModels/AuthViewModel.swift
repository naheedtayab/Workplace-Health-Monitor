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
            if let error = error {
                // Update authError when there's an error
                self.authError = error.localizedDescription
            } else {
                // Reset authError on success
                self.authError = nil
                self.signedIn = true // Update signedIn status
            }
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                // Update authError when there's an error
                self.authError = error.localizedDescription
            } else {
                // Reset authError on success
                self.authError = nil
                self.signedIn = true // Update signedIn status
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.signedIn = false
        } catch let signOutError {
            // Update authError when there's an error
            self.authError = signOutError.localizedDescription
        }
    }
}
