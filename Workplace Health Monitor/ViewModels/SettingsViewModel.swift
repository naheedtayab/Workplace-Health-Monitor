import Foundation

class UserSettings: ObservableObject {
    @Published var selectedModel: String {
        didSet {
            UserDefaults.standard.set(selectedModel, forKey: "selectedModel")
        }
    }
    
    @Published var breakDuration: Int {
        didSet {
            UserDefaults.standard.set(breakDuration, forKey: "breakDuration")
        }
    }
    
    @Published var inactivityDuration: Int {
        didSet {
            UserDefaults.standard.set(inactivityDuration, forKey: "inactivityDuration")
        }
    }
    
    init() {
        self.selectedModel = UserDefaults.standard.string(forKey: "selectedModel") ?? "Standard"
        self.breakDuration = UserDefaults.standard.integer(forKey: "breakDuration")
        self.inactivityDuration = UserDefaults.standard.integer(forKey: "inactivityDuration")
    }
}
