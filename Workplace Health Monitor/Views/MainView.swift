import SwiftUI
import UserNotifications

struct MainView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.signedIn {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }.tag(0)
                    
                    MotionActivityView()
                        .tabItem {
                            Label("Motion Activity", systemImage: "waveform.path.ecg")
                        }.tag(1)
                    
                    SensorView()
                        .tabItem {
                            Label("Live Sensors", systemImage: "figure.walk")
                        }.tag(2)
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }.tag(3)
                }
            } else {
                LoginView()
            }
        }
    }
}

// Preview
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(AuthViewModel())
    }
}
