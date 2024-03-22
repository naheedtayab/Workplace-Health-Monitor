import SwiftUI
import CoreMotion

struct AccelerometerDataView: View {
    @ObservedObject var motionManager: MotionManager

    var body: some View {
        VStack {
            Text("Accelerometer Data")
            if let accelerometerData = motionManager.accelerometerData {
                Text("X: \(accelerometerData.acceleration.x)")
                Text("Y: \(accelerometerData.acceleration.y)")
                Text("Z: \(accelerometerData.acceleration.z)")
            } else {
                Text("No accelerometer data")
            }
        }
        .padding()
        .navigationTitle("Accelerometer")
        .onAppear {
            motionManager.startSensors()
        }
        .onDisappear {
            motionManager.stopSensors()
        }
    }
}

struct AccelerometerDataView_Previews: PreviewProvider {
    static var previews: some View {
        AccelerometerDataView(motionManager: MotionManager())
    }
}
