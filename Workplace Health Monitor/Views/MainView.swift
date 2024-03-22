import SwiftUI
import UserNotifications

struct MainView: View {
    @State private var selectedTab = 0
    @StateObject var motionManager = MotionManager()
    @StateObject private var userSettings = UserSettings() 
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                LoginView()
            }
        }
    }
}

#Preview {
    MainView()
}
