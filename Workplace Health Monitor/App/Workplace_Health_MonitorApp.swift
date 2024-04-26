import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,

                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()

        return true
    }
}

@main
struct Workplace_Health_MonitorApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    @Environment(\.scenePhase) var scenePhase // Add this line

    @State private var isLoadComplete = false

    var body: some Scene {
        WindowGroup {
            if isLoadComplete {
                if authViewModel.signedIn {
                    MainView() // Main view with tabs
                        .environmentObject(authViewModel)
                        .onAppear { print("Transitioning to MainView")
                        }
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                        .onAppear { print("Transitioning to LoginView")
                        }
                }
            } else {
                LoadingView(isLoadComplete: $isLoadComplete)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 2 second delay
                            isLoadComplete = true
                            print("Loading complete, checking user sign-in status...")
                        }
                    }
            }
        }
    }
}
