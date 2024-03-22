import Combine
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager: CMMotionManager = .init()
    private var pedometer: CMPedometer
    private let queue = OperationQueue()
    private var timer: Timer?
    
    @Published var accelerometerData: CMAccelerometerData?
    @Published var isWalking: Bool = false
    @Published var isSedentary: Bool = false
    
    init() {
        self.motionManager = CMMotionManager()
        self.pedometer = CMPedometer()
        startMotionUpdates()
    }
    
    func startMotionUpdates() {
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let acceleration = data?.acceleration else { return }
            
            self?.isSedentary = (abs(acceleration.x) + abs(acceleration.y) + abs(acceleration.z)) < 0.05 // Very simplified threshold
        }
    }
    
    func stopMotionUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
    
    let threshold: Double = 2.0 // define threshold for checking accelerometer. in this case it's 2g (g = 9.81 m/s^2)

    func startSensors() {
        // Start accelerometer updates
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0 
            motionManager.startAccelerometerUpdates(to: queue) { [weak self] data, _ in
                DispatchQueue.main.async {
                    if let acceleration = data?.acceleration {
                        self?.accelerometerData = data
                        
                        // Check if the acceleration exceeds the threshold on any axis
                        let x = acceleration.x
                        let y = acceleration.y
                        let z = acceleration.z
                        if abs(x) > self!.threshold {
                            print("High acceleration observed on X-axis: \(x)")
                        }
                        if abs(y) > self!.threshold {
                            print("High acceleration observed on Y-axis: \(y)")
                        }
                        if abs(z) > self!.threshold {
                            print("High acceleration observed on Z-axis: \(z)")
                        }
                    }
                }
            }
        }
        
        // Start pedometer updates
        if CMPedometer.isStepCountingAvailable() {
            pedometer.startUpdates(from: Date()) { [weak self] pedometerData, _ in
                DispatchQueue.main.async {
                    self?.isWalking = (pedometerData?.numberOfSteps.intValue ?? 0) > 0
                }
            }
        }
    }
    
    func stopSensors() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
        if CMPedometer.isStepCountingAvailable() {
            pedometer.stopUpdates()
        }
    }
}
