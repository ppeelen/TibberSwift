import SwiftUI
import TibberSwift

struct ConsumptionView: View {
    let tibberSwift: TibberSwift

    @State private var consumption: Consumption?
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            if let errorMessage {
                Text(errorMessage)
                    .padding()
            } else if let consumption {
                List(consumption.homes) { home in
                    Section(home.id) {
                        ForEach(home.consumption.nodes) { node in
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("From")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                        Text(node.from, style: .time)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text("to")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                        Text(node.to, style: .time)
                                    }
                                }
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Price")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                        Text("\(String(format: "%.2f", node.unitPrice)) \(node.currency)")
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text("Usage")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                        Text("\(String(format: "%.2f", node.consumption)) \(node.consumptionUnit)")
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            self.fetchConsumption()
        }
    }

    private func fetchConsumption() {
        Task {
            do {
                self.consumption = try await tibberSwift.consumption()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

extension Consumption.Home.Consumption.Node: Identifiable {
    public var id: UUID {
        UUID()
    }
}

extension Consumption.Home: Identifiable { }

#Preview {
    ConsumptionView(tibberSwift: TibberSwift(apiKey: ""))
}
