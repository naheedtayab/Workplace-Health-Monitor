import Combine // Import Combine if you're using @Published
import CoreMotion
import Foundation

class ActivityViewModel: ObservableObject {
    private var motionManager: CMMotionActivityManager?
    @Published var activity: String = "Unknown"
    private var inactivityTimer: Timer? // Make sure you have this timer declared
    private var inactiveTimeCount: Int = 0 // Counter for tracking inactivity
    @Published var inactivityDuration: Int = 45 // User-defined duration for inactivity, defaulting to 45 minutes

    init() {
        // Check if activity tracking is available before starting
        if CMMotionActivityManager.isActivityAvailable() {
            motionManager = CMMotionActivityManager()
            startMonitoring()
        } else {
            print("Motion activity tracking is not available.")
        }
    }

    func startMonitoring() {
        motionManager?.startActivityUpdates(to: .main) { [weak self] activity in
            guard let activity = activity else { return }

            // Update your activity status; this is simplified
            if activity.stationary {
                self?.activity = "Stationary"
                self?.startInactivityTimer()
            } else if activity.walking {
                self?.activity = "Walking"
                self?.resetInactivityTimer()
            } else if activity.running {
                self?.activity = "Running"
                self?.resetInactivityTimer()
            } else if activity.automotive {
                self?.activity = "In Vehicle"
                self?.resetInactivityTimer()
            } else {
                self?.activity = "Unknown"
                self?.resetInactivityTimer()
            }
        }
    }

    private func startInactivityTimer() {
        inactivityTimer?.invalidate() // Stop any existing timer
        inactiveTimeCount = 0 // Reset counter when starting a new timer
        inactivityTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.inactiveTimeCount += 1
            if self?.inactiveTimeCount ?? 0 >= self?.inactivityDuration ?? 0 {
                // Send notification
                self?.sendInactivityNotification()
                self?.inactiveTimeCount = 0 // Reset counter
            }
        }
    }

    private func resetInactivityTimer() {
        inactivityTimer?.invalidate()
        inactiveTimeCount = 0 // Reset counter
    }

    private func sendInactivityNotification() {
        // Implement your code to send a local notification
        print("User has been inactive for \(inactivityDuration) minutes.")
    }

    deinit {
        motionManager?.stopActivityUpdates() // Stop the updates when the view model is deinitialized
    }
}

//    private func startMonitoring() {
//        guard CMMotionActivityManager.isActivityAvailable() else {
//            activity = "You have no motion."
//            return
//        }
//
//        motionManager.startActivityUpdates(to: OperationQueue.main) { [weak self] (motionActivity) in
//            guard let activity = motionActivity else { return }
//
//            if activity.walking {
//                self?.activity = "Walking"
//            } else if activity.running {
//                self?.activity = "Running"
//            } else if activity.stationary {
//                self?.activity = "Stationary"
//            } else if activity.automotive {
//                self?.activity = "In a vehicle"
//            } else {
//                self?.activity = "Unknown"
//            }
//        }
//    }
