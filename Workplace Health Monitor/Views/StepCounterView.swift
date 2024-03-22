import Foundation
import SwiftUI
import HealthKit

class StepCounterViewModel: ObservableObject {
    private var healthStore: HKHealthStore?
    @Published var stepsToday = 0
    @Published var stepsLastHour = 0
    private let notificationCenter = UNUserNotificationCenter.current()

    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
            requestAuthorization()
        }
    }

    func requestAuthorization() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        healthStore?.requestAuthorization(toShare: [], read: [stepType]) { success, error in
            if success {
                self.fetchTodaySteps()
                self.fetchLastHourSteps()
            }
        }
    }

    func fetchTodaySteps() {
        fetchSteps(from: Calendar.current.startOfDay(for: Date()), to: Date()) { steps in
            self.stepsToday = steps
        }
    }

    func fetchLastHourSteps() {
        let now = Date()
        let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: now)!
        
        fetchSteps(from: oneHourAgo, to: now) { steps in
            self.stepsLastHour = steps
        }
    }

    private func fetchSteps(from startDate: Date, to endDate: Date, completion: @escaping (Int) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, statistics, _ in
            DispatchQueue.main.async {
                var steps = 0
                if let sum = statistics?.sumQuantity() {
                    steps = Int(sum.doubleValue(for: HKUnit.count()))
                }
                completion(steps)
            }
        }

        healthStore?.execute(query)
    }
    
    func sendTestNotification() {
        print("Requesting notification settings...")
        self.notificationCenter.getNotificationSettings { settings in
            print("Notification settings received: \(settings)")
            if settings.authorizationStatus == .authorized {
                print("Notifications are authorized. Scheduling a test notification...")
                self.scheduleNotification()
            } else {
                print("Notifications are not authorized. Requesting permission...")
                self.notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
                    if let error = error {
                        print("Error requesting notification authorization: \(error.localizedDescription)")
                    }
                    if granted {
                        print("Notification permission granted. Scheduling a test notification...")
                        self.scheduleNotification()
                    } else {
                        print("Notification permission denied.")
                    }
                }
            }
        }
    }
       
       private func scheduleNotification() {
           // Create a notification content
           let content = UNMutableNotificationContent()
           content.title = "Move Alert"
           content.body = "Time to stand up and move around!"

           // Create a notification request
           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
           
           let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
           
           // Schedule the notification
           self.notificationCenter.add(request) { (error) in
               if error != nil {
                   print("error")
               }
//               if let error = error {
//                   print("Error scheduling notification: \(error.localizedDescription)")
//               } else {
//                   print("printing?")
//               }
           }
       }
   }

struct StepCounterView: View {
  @ObservedObject var viewModel = StepCounterViewModel()
    
  var body: some View {
      VStack {
          Text("Steps Today: \(viewModel.stepsToday)")
          Text("Steps Last Hour: \(viewModel.stepsLastHour)")
          
          Button("Send Test Notification") {
              viewModel.sendTestNotification()
              print("test")
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

