import SwiftUI

struct SensorView: View {
    @StateObject private var viewModel = SensorViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                SensorDataCard(title: "Accelerometer",
                               xValue: viewModel.accelerometerData.x,
                               yValue: viewModel.accelerometerData.y,
                               zValue: viewModel.accelerometerData.z)

                SensorDataCard(title: "Gyroscope",
                               xValue: viewModel.gyroData.x,
                               yValue: viewModel.gyroData.y,
                               zValue: viewModel.gyroData.z)

                VStack {
                    Text("Barometer")
                        .font(.headline)
                    Text("\(viewModel.pressureData, specifier: "%.2f") hPa")
                        .font(.title2)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))

                VStack {
                    Text("GPS")
                        .font(.headline)
                    Text("Latitude: \(viewModel.locationData.latitude)")
                    Text("Longitude: \(viewModel.locationData.longitude)")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))

                VStack {
                    Text("Steps in Last Hour")
                        .font(.headline)
                    Text("\(viewModel.stepsLastHour)")
                        .font(.title2)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))
            }
            .padding()
        }
        .navigationTitle("Sensor Data")
        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

struct SensorDataCard: View {
    var title: String
    var xValue: Double
    var yValue: Double
    var zValue: Double

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            HStack {
                SensorValueAxis(title: "X", value: xValue)
                SensorValueAxis(title: "Y", value: yValue)
                SensorValueAxis(title: "Z", value: zValue)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))
    }
}

struct SensorValueAxis: View {
    var title: String
    var value: Double

    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(String(format: "%.3f", value))
                .font(.body)
                .fontWeight(.semibold)
        }
    }
}

// Preview for SwiftUI Canvas
struct SensorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SensorView()
        }
    }
}
