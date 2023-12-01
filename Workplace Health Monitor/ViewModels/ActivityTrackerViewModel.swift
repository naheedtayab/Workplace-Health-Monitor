import Foundation
import SwiftUI
import CoreMotion

class ActivityTrackerViewModel: ObservableObject {
    @Published var lastActivityTime: Date?
    @Published var timeSinceLastActivity: String = ""

    private let motionActivityManager = CMMotionActivityManager()
    private var activityTimer: Timer?
    private let activityDetectionInterval: TimeInterval = 60 // 1 minute
    
    init() {
        // Initialize lastActivityTime if needed, e.g., from UserDefaults
        updateElapsedTime()
        startMotionActivityUpdates()
    }
    
    private func startMotionActivityUpdates() {
            guard CMMotionActivityManager.isActivityAvailable() else { return }

            motionActivityManager.startActivityUpdates(to: .main) { [weak self] activity in
                guard let activity = activity, activity.confidence == .high else { return }

                if activity.walking || activity.running || activity.cycling {
                    self?.resetActivityTimer()
                }
            }
        }
    
    private func resetActivityTimer() {
            activityTimer?.invalidate()
            activityTimer = Timer.scheduledTimer(withTimeInterval: activityDetectionInterval, repeats: false) { [weak self] _ in
                self?.lastActivityTime = Date()
                self?.updateElapsedTime()
            }
        }
    


    func updateActivityTime() {
        lastActivityTime = Date()
        updateElapsedTime()
        // Save lastActivityTime to persistent storage if necessary
    }

    func updateElapsedTime() {
        guard let lastActivityTime = lastActivityTime else {
            timeSinceLastActivity = "No activity recorded"
            return
        }

        let now = Date()
        let elapsedTime = now.timeIntervalSince(lastActivityTime)

        // Convert elapsedTime to a readable format
        timeSinceLastActivity = formatTimeInterval(elapsedTime)
    }

    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.maximumUnitCount = 2  // Adjust as needed

        return formatter.string(from: interval) ?? ""
    }
}
