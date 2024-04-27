import CoreMotion
import SwiftUI

// ViewModel to manage motion activities
class MotionActivityViewModel: ObservableObject {
    private var activityManager = CMMotionActivityManager()
    private var activityQueue = OperationQueue()

    @Published var currentActivity = "Unknown"

    init() {
        startTracking()
    }

    private func startTracking() {
        guard CMMotionActivityManager.isActivityAvailable() else {
            print("Activity tracking is not available on this device.")
            return
        }

        activityManager.startActivityUpdates(to: activityQueue) { [weak self] activity in
            guard let activity = activity else { return }

            DispatchQueue.main.async {
                self?.updateCurrentActivity(activity)
            }
        }
    }

    private func updateCurrentActivity(_ activity: CMMotionActivity) {
        if activity.walking {
            currentActivity = "Walking"
        } else if activity.running {
            currentActivity = "Running"
        } else if activity.cycling {
            currentActivity = "Cycling"
        } else if activity.automotive {
            currentActivity = "Driving"
        } else if activity.stationary {
            currentActivity = "Sedentary"
        } else {
            currentActivity = "Unknown"
        }
    }

    deinit {
        activityManager.stopActivityUpdates()
    }
}
