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
    @StateObject var motionManager = MotionManager()
    
    var body: some View {
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
