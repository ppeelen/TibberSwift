import SwiftUI
import TibberSwift

struct HomesView: View {
    let tibberSwift: TibberSwift

    @State private var homes: [Home]?
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            if let errorMessage {
                Text(errorMessage)
            } else if let homes {
                List {
                    ForEach(homes, id:\.address.address1) { home in
                        Section {
                            VStack(alignment: .leading) {
                                Text("ID")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                Text(home.id)
                                    .font(.body)
                            }
                            VStack(alignment: .leading) {
                                Text("Address 1")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                Text(home.address.address1)
                                    .font(.body)
                            }
                            if let address2 = home.address.address2 {
                                VStack(alignment: .leading) {
                                    Text("Address 2")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                    Text(address2)
                                        .font(.body)
                                }
                            }
                            if let address3 = home.address.address3 {
                                VStack(alignment: .leading) {
                                    Text("Address 3")
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                    Text(address3)
                                        .font(.body)
                                }
                            }
                            VStack(alignment: .leading) {
                                Text("Postalcode")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                Text(home.address.postalCode)
                                    .font(.body)
                            }
                            VStack(alignment: .leading) {
                                Text("City")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                Text(home.address.city)
                                    .font(.body)
                            }
                            VStack(alignment: .leading) {
                                Text("Country")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                Text(home.address.country)
                                    .font(.body)
                            }
                            VStack(alignment: .leading) {
                                Text("Coordinater")
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                Text("\(home.address.latitude) / \(home.address.longitude)")
                                    .font(.body)
                            }
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            self.fetchHomes()
        }
    }

    private func fetchHomes() {
        Task {
            do {
                self.homes = try await tibberSwift.homes()
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    HomesView(tibberSwift: TibberSwift(apiKey: ""))
}
