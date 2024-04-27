import SwiftUI

struct SettingsView: View {
    @State private var selectedModel = "LSTM" // Local state for demonstration
    @State private var breakDuration = 15 // Default value for demo
    @State private var inactivityDuration = 30 // Default value for demo

    var body: some View {
        Form {
            Section(header: Text("Motion Prediction Model")) {
                Picker("Prediction Model", selection: $selectedModel) {
                    Text("LSTM").tag("LSTM")
                    Text("Random Forest").tag("Random Forest")
                    Text("SVM").tag("SVM")
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Break Duration")) {
                Stepper(value: $breakDuration, in: 5...60, step: 5) {
                    Text("\(breakDuration) minutes")
                }
            }

            Section(header: Text("Inactivity Notification")) {
                Stepper(value: $inactivityDuration, in: 5...60, step: 5) {
                    Text("\(inactivityDuration) seconds")
                }
            }
        }
        .navigationTitle("Settings")
    }
}
