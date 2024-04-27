import SwiftUI

struct MotionActivityView: View {
    @StateObject private var viewModel = MotionActivityViewModel()

    var body: some View {
        VStack {
            Text("Predicted State:")
            Text(viewModel.currentActivity)
                .font(.title)
                .fontWeight(.bold)
                .padding()
        }
    }
}

struct MotionActivityView_Previews: PreviewProvider {
    static var previews: some View {
        MotionActivityView()
    }
}
