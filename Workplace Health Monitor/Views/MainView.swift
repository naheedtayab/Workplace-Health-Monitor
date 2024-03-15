import SwiftUI
import UserNotifications

struct MainView: View {
    @State private var selectedTab = 0
    @StateObject var motionManager = MotionManager()
    @StateObject private var userSettings = UserSettings() // Instantiate your UserSettings object
    @EnvironmentObject var authViewModel: AuthViewModel // Add this line
    
    var body: some View {
        Group {
            if authViewModel.signedIn { // Check if the user is signed in
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }.tag(0)
                    
                    MotionActivityView()
                        .tabItem {
                            Label("Motion Activity", systemImage: "waveform.path.ecg")
                        }.tag(1)
                    
                    StepCounterView()
                        .tabItem {
                            Label("Step Counter", systemImage: "figure.walk")
                        }.tag(2)
                    
                    AccelerometerDataView(motionManager: motionManager)
                        .tabItem {
                            Label("Accelerometer", systemImage: "waveform.path.ecg")
                        }.tag(3)
                    
                    SettingsView().environmentObject(userSettings)
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                }
            } else {
                // Present a view that handles user sign in or registration.
                // Assuming you have a view named LoginView for this purpose:
                LoginView()
            }
        }
    }
}

#Preview {
    MainView()
}
