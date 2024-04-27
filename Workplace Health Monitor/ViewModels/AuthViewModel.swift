import Combine
import FirebaseAuth
import Foundation

class AuthViewModel: ObservableObject {
    @Published var signedIn = false
    @Published var authError: String?

    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        self.authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let user = user {
                print("User is currently signed in: \(user.uid)")
                self?.signedIn = true
            } else {
                print("No user is currently signed in.")
                self?.signedIn = false
            }
        }

        if Auth.auth().currentUser != nil {
            print("User already signed in at app launch: \(Auth.auth().currentUser!.uid)")
            self.signedIn = true
        } else {
            print("No user signed in at app launch.")
            self.signedIn = false
        }
    }

    func signUp(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                self.authError = error.localizedDescription
                print("Signup error: \(error.localizedDescription)")
            } else {
                self.authError = nil
                self.signedIn = true
                print("Signup successful, user signed in.")
            }
        }
    }

    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                self.authError = error.localizedDescription
                print("Sign-in error: \(error.localizedDescription)")
            } else {
                self.authError = nil
                self.signedIn = true
                print("Sign-in successful, user signed in.")
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.signedIn = false
            print("User signed out.")
        } catch let signOutError {
            self.authError = signOutError.localizedDescription
            print("Sign-out error: \(signOutError.localizedDescription)")
        }
    }
}
