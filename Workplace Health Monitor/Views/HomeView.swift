//
//  HomeView.swift
//  Workplace Health Monitor
//
//  Created by Naheed on 30/11/2023.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.textAlignment = .justified
        textView.isEditable = false
//        textView.isScrollEnabled = false
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

struct HomeView: View {
    @ObservedObject var viewModel = ActivityTrackerViewModel()
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                Text("Workplace Health Monitor")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color.blue)
                    .padding(.top, 20) // Added padding to move it down slightly

                TextView(text: "Welcome to the Workplace Health Monitor! This app helps you maintain a healthy balance between work and physical activity. It tracks your sedentary time and reminds you to take breaks for walking or stretching, ensuring you stay active throughout your workday.").frame(width: 350, height: 180)
                
                Image(systemName: "figure.walk.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .foregroundColor(Color.blue)
//                    .padding(.vertical)

                Spacer()
                
                Text("How long since you last took a break:")
                            Text(viewModel.timeSinceLastActivity)
                                .font(.headline)
                            Button("Update Last Activity Time") {
                                viewModel.updateActivityTime()
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }
            .onAppear {
                viewModel.updateElapsedTime()
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20) // Added padding to the bottom
        }
//        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .padding(.top, 1) // Ensures the top edge respects the safe area
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
