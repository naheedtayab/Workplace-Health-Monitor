//
//  MainView.swift
//  Workplace Health Monitor
//
//  Created by Naheed on 23/11/2023.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
//            Text("Home")
//                .tabItem {
//                    Label("Home", systemImage: "house")
//                }
//            
//            Text("Alerts")
//                .tabItem {
//                    Label("Alerts", systemImage: "bell")
//                }
//                .badge(7)
            
            ContentView()
                .tabItem {
                    Label("Motion Activity", systemImage: "waveform.path.ecg")
                }
            
            StepCounterView()
                .tabItem {
                    Label("Step Counter", systemImage: "figure.walk")
                }        }
    }
}


#Preview {
    MainView()
}
