import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    let models = ["Standard", "Advanced", "Custom"] // Example model names
    
    var body: some View {
        Form {
            Section(header: Text("Machine Learning Model")) {
                Picker("Select Model", selection: $userSettings.selectedModel) {
                    ForEach(models, id: \.self) { model in
                        Text(model).tag(model)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Break Duration")) {
                Stepper(value: $userSettings.breakDuration, in: 5...60, step: 5) {
                    Text("\(userSettings.breakDuration) minutes")
                }
            }
            
            Section(header: Text("Inactivity Notification")) {
                Stepper(value: $userSettings.inactivityDuration, in: 15...120, step: 15) {
                    Text("\(userSettings.inactivityDuration) minutes")
                }
            }
        }
        .navigationTitle("Settings")
    }
}

