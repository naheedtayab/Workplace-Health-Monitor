import CoreLocation
import CoreMotion
import SwiftUI

class SensorViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var motionManager = CMMotionManager()
    private var pedometer = CMPedometer()
    private let altimeter = CMAltimeter()
    
    private let locationManager = CLLocationManager()
    
    @Published var accelerometerData: CMAcceleration = .init()
    @Published var gyroData: CMRotationRate = .init()
    @Published var pressureData: Double = 0.0
    @Published var locationData: CLLocationCoordinate2D = .init()
    @Published var stepsLastHour: Int = 0
    
    override init() {
        super.init()
        locationManager.delegate = self
        startSensors()
    }
    
    private func startSensors() {
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] data, _ in
                guard let strongSelf = self, let accelerometerData = data else { return }
                DispatchQueue.main.async {
                    strongSelf.accelerometerData = accelerometerData.acceleration
                }
            }
        }

        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 1.0 / 60.0 // 60 Hz
            motionManager.startGyroUpdates(to: OperationQueue.main) { [weak self] data, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self?.gyroData = data.rotationRate
                }
            }
        }

        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { [weak self] data, error in
                guard let data = data, error == nil else {
                    print("Error in barometer data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                DispatchQueue.main.async {
                    self?.pressureData = data.pressure.doubleValue * 10.0 // Convert to hPa
                }
            }
        }
        
        // Start GPS
        locationManager.requestWhenInUseAuthorization()

        if CMPedometer.isStepCountingAvailable() {
            let calendar = Calendar.current
            let oneHourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
            pedometer.queryPedometerData(from: oneHourAgo, to: Date()) { [weak self] data, error in
                guard let data = data, error == nil else {
                    print("Error in pedometer data: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                DispatchQueue.main.async {
                    self?.stepsLastHour = data.numberOfSteps.intValue
                }
            }
        }
    }
    
    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { guard let newLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.locationData = newLocation.coordinate
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                if CLLocationManager.locationServicesEnabled() {
                    manager.startUpdatingLocation()
                } else {}
            case .restricted, .denied:
                break
            default:
                break
        }
    }
}
