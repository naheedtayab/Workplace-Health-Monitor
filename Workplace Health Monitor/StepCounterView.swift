//
//  StepCounterView.swift
//  Workplace Health Monitor
//
//  Created by Naheed on 16/11/2023.
//

import Foundation
import SwiftUI
import HealthKit

class StepCounterViewModel: ObservableObject {
    private var healthStore: HKHealthStore?
    @Published var steps = 0

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
                self.fetchSteps()
            }
            // Handle errors or lack of permissions gracefully
        }
    }

    func fetchSteps() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, statistics, _ in
            DispatchQueue.main.async {
                if let sum = statistics?.sumQuantity() {
                    self.steps = Int(sum.doubleValue(for: HKUnit.count()))
                }
            }
        }

        healthStore?.execute(query)
    }
}

struct StepCounterView: View {
    @ObservedObject var viewModel = StepCounterViewModel()

    var body: some View {
        Text("Steps: \(viewModel.steps)")
    }
}

struct StepCounterView_Previews: PreviewProvider {
    static var previews: some View {
        StepCounterView()
    }
}
