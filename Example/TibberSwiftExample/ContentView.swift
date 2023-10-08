import SwiftUI

struct ContentView: View {
    @State private var apiKey: String = ""

    var body: some View {
        VStack {
            Text("TibberSwift")
                .font(.title)
                .fontWeight(.light)
                .padding()

            Text("You can get your api-key via https://developer.tibber.com. Enter the key below.")

            UnderlinedTextField(title: "Tibber API Key", text: $apiKey)
                .padding()

            NavigationLink(destination: TibberActionsView(apiKey: apiKey)) {
                Text("Submit")
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(apiKey.count < 10 ? .gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .padding(.top)
            }
            .disabled(apiKey.count < 10)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

private struct UnderlinedTextField: View {
    let title: String
    @Binding var text: String
    @State private var isFocused: Bool = false

    var body: some View {
        VStack {
            TextField(title, text: $text, onEditingChanged: { editing in
                isFocused = editing
            })
            Rectangle()
                .frame(height: 1)
                .foregroundColor(getLineColor())
                .opacity(0.5)
        }
    }

    func getLineColor() -> Color {
        if isFocused {
            return text.count < 10 ? Color.red : Color.green
        } else {
            return Color.black
        }
    }
}
