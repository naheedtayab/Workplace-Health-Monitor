//
//  ActivityViewModel.swift
//  Workplace Health Monitor
//
//  Created by Naheed on 16/11/2023.
//

import Foundation
import CoreMotion

class ActivityViewModel: ObservableObject {
    private var motionManager = CMMotionActivityManager()
    @Published var activity: String = "Unknown"

    init() {
        startMonitoring()
    }

    private func startMonitoring() {
        guard CMMotionActivityManager.isActivityAvailable() else {
            activity = "Motion activity not available."
            return
        }

        motionManager.startActivityUpdates(to: OperationQueue.main) { [weak self] (motionActivity) in
            guard let activity = motionActivity else { return }

            if activity.walking {
                self?.activity = "Walking"
            } else if activity.running {
                self?.activity = "Running"
            } else if activity.stationary {
                self?.activity = "Stationary"
            } else if activity.automotive {
                self?.activity = "In a vehicle"
            } else {
                self?.activity = "Unknown"
            }
        }
    }
}

