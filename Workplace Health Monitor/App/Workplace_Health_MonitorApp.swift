import FirebaseCore
import SwiftUI

// class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
//    {
//        FirebaseApp.configure()
//
//        return true
//    }
// }

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        registerForPushNotifications(application: application)
        return true
    }

    private func registerForPushNotifications(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Request authorization failed: \(error)")
                return
            }
            print("Permission granted: \(granted)")
            guard granted else { return }
            application.registerForRemoteNotifications()
        }
    }
}

// @main
// struct Workplace_Health_MonitorApp: App {
//    // register app delegate for Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @StateObject private var authViewModel = AuthViewModel()
//    @Environment(\.scenePhase) var scenePhase // Add this line
//
//    @State private var isLoadComplete = false
//
//    var body: some Scene {
//        WindowGroup {
//            if isLoadComplete {
//                if authViewModel.signedIn {
//                    MainView() // Main view with tabs
//                        .environmentObject(authViewModel)
//                        .onAppear { print("Transitioning to MainView")
//                        }
//                } else {
//                    LoginView()
//                        .environmentObject(authViewModel)
//                        .onAppear { print("Transitioning to LoginView")
//                        }
//                }
//            } else {
//                LoadingView(isLoadComplete: $isLoadComplete)
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 2 second delay
//                            isLoadComplete = true
//                            print("Loading complete, checking user sign-in status...")
//                        }
//                    }
//            }
//        }
//    }
// }

@main
struct Workplace_Health_MonitorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authViewModel = AuthViewModel()
    @Environment(\.scenePhase) var scenePhase

    @State private var isLoadComplete = false

    var body: some Scene {
        WindowGroup {
            if isLoadComplete {
                if authViewModel.signedIn {
                    MainView()
                        .environmentObject(authViewModel)
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            } else {
                LoadingView(isLoadComplete: $isLoadComplete)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isLoadComplete = true
                        }
                    }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                scheduleNotification()
            }
        }
    }

    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "It's time to take a break!"
        content.body = "You have been sedentary for too long. Get up and go for a walk!"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
