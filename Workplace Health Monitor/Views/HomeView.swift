import SwiftUI

struct TextView: UIViewRepresentable {
    var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.textAlignment = .justified
        textView.isEditable = false
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                Text("Workplace Health Monitor")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(Color.blue)
                    .padding(.top, 20)

                TextView(text: "Welcome to the Workplace Health Monitor! This app helps you maintain a healthy balance between work and physical activity. It tracks your sedentary time and reminds you to take breaks for walking or stretching, ensuring you stay active throughout your workday.").frame(width: 350, height: 180)

                Image(systemName: "figure.walk.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .foregroundColor(Color.blue)

                Spacer()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
