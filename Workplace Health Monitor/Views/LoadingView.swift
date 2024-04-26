import SwiftUI

struct LoadingView: View {
    @Binding var isLoadComplete: Bool

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "figure.walk.circle") // Make sure you have your logo in the Assets
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            Text("Workplace Health Monitor")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 2 seconds loading time
                self.isLoadComplete = true
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(isLoadComplete: .constant(false))
    }
}
