//
//  ContentView.swift
//  Workplace Health Monitor
//
//  Created by Naheed on 16/11/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ActivityViewModel()
    
    var body: some View {
        VStack {
            VStack {
                Text("Workplace Health Monitor").font(.title)
            }
            Spacer()
            Text("Current Activity:")
            Text(viewModel.activity)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
    }
}

#Preview {
    ContentView()
}
