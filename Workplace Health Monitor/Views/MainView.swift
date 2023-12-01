//
//  MainView.swift
//  Workplace Health Monitor
//
//  Created by Naheed on 23/11/2023.
//

import SwiftUI
import UserNotifications

struct MainView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ContentView()
                .tabItem {
                    Label("Motion Activity", systemImage: "waveform.path.ecg")
                }
            
            StepCounterView()
                .tabItem {
                    Label("Step Counter", systemImage: "figure.walk")
                }
            
//            Text("Alerts")
//                .tabItem {
//                    Label("Alerts", systemImage: "bell")
//                }
//                .badge(7)
            
                        Text("Settings (todo)")
                            .tabItem {
                                Label("Settings (todo)", systemImage: "gearshape")
                            }
                            .badge(0)
            
        }
    }
}


#Preview {
    MainView()
}
