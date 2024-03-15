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
    
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(authViewModel)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background || scenePhase == .inactive {
                // User is leaving the app, handle sign out
                authViewModel.signOut()
            }
        }
    }
}
