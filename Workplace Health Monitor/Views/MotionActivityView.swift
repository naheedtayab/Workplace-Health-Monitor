import SwiftUI

struct MotionActivityView: View {
    @ObservedObject var viewModel = ActivityViewModel()
    
    var body: some View {
        VStack {
            VStack {
                Text("Workplace Health Monitor").font(.title)
            }
            Spacer()
            Text("Current Activity:")
            Text(viewModel.activity)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

#Preview {
    MotionActivityView()
}
