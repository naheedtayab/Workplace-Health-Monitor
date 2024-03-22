import Foundation
import SwiftUI
import HealthKit

extension StepCounterViewModel {
    
    func sendTestNotification() {
        // Ensure the notification center is authorized
        notificationCenter.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                // Send the test notification
                DispatchQueue.main.async {
                    self.sendLocalNotification()
                }
            } else {
                // Request authorization if not already authorized
                self.notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
                    if granted {
                        DispatchQueue.main.async {
                            self.sendLocalNotification()
                        }
                    }
                }
            }
        }
    }
    
    private func sendLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time to Move!"
        content.body = "You've been sitting for a while. Why not take a short walk?"
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil) // Set trigger to nil for immediate delivery

        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}

struct StepCounterView: View {
    @ObservedObject var viewModel = StepCounterViewModel()

    var body: some View {
        VStack {
            Text("Steps Today: \(viewModel.stepsToday)")
            Button("Send Test Notification") {
                viewModel.sendTestNotification()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

struct StepCounterView_Previews: PreviewProvider {
    static var previews: some View {
        StepCounterView()
    }
}
