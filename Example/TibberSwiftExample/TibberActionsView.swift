import SwiftUI
import TibberSwift

private enum Action {
    case loggedInUser
}

struct TibberActionsView: View {
    let apiKey: String
    let tibberSwift: TibberSwift

    @State private var loggedInUser: LoggedInUser?
    @State private var userLogin: UserLogin?
    @State private var currentEnergyPrice: CurrentEnergyPrice?
    @State private var errorMessage: String?

    @State private var loggedInLoading = false
    @State private var userLoginLoading = false
    @State private var currentEnergyPriceLoading = false

    init(apiKey: String) {
        self.apiKey = apiKey
        self.tibberSwift = TibberSwift(apiKey: apiKey)
    }

    var body: some View {
        List {
            if let loggedInUser {
                HStack {
                    Text("Logged in as:")
                    Spacer()
                    Text(loggedInUser.name)
                }
                .listRowInsets(.none)
                .background(.clear)
                .scrollContentBackground(.hidden)
            }
            Section("API Explorer actions") {
                Button(action: loggedInUserAction, label: {
                    HStack {
                        Text("Logged in user")
                        if loggedInLoading {
                            Spacer()
                            ProgressView()
                        }
                    }
                })
                NavigationLink("Homes") {
                    HomesView(tibberSwift: tibberSwift)
                }
                NavigationLink("Consumption") {
                    ConsumptionView(tibberSwift: tibberSwift)
                }
            }
            Section("Custom operations") {
                if let userLogin {
                    HStack {
                        Text("User Login is:")
                        Spacer()
                        Text(userLogin.login)
                    }
                    .listRowInsets(.none)
                    .background(.clear)
                    .scrollContentBackground(.hidden)
                }
                Button(action: userLoginAction, label: {
                    HStack {
                        Text("Get user Login")
                        if userLoginLoading {
                            Spacer()
                            ProgressView()
                        }
                    }
                })
                if let currentEnergyPrice {
                    ForEach(currentEnergyPrice.homes) { home in
                        VStack {
                            HStack {
                                Text("Total:")
                                Spacer()
                                Text("\(home.currentSubscription.priceInfo.current.total) \(home.currentSubscription.priceInfo.current.currency)")
                            }
                            HStack {
                                Text("Tax:")
                                Spacer()
                                Text("\(home.currentSubscription.priceInfo.current.tax) \(home.currentSubscription.priceInfo.current.currency)")
                            }
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                            HStack {
                                Text("Starts at:")
                                Spacer()
                                Text("\(home.currentSubscription.priceInfo.current.startsAt, format: .dateTime)")
                            }
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                        }
                    }
                }
                Button(action: currentEnergyPriceAction, label: {
                    HStack {
                        Text("Get current energy price")
                        if currentEnergyPriceLoading {
                            Spacer()
                            ProgressView()
                        }
                    }
                })
            }
            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
        }
        .onAppear()
    }

    func loggedInUserAction() {
        loggedInLoading = true
        Task {
            do {
                self.loggedInUser = try await tibberSwift.loggedInUser()
                loggedInLoading = false
            } catch {
                errorMessage = error.localizedDescription
                loggedInLoading = false
            }
        }
    }

    func userLoginAction() {
        userLoginLoading = true
        Task {
            do {
                let operation = GraphQLOperation.userLogin()
                self.userLogin = try await tibberSwift.customOperation(operation)
                userLoginLoading = false
            } catch {
                errorMessage = error.localizedDescription
                userLoginLoading = false
            }
        }
    }

    func currentEnergyPriceAction() {
        currentEnergyPriceLoading = true
        Task {
            do {
                let operation = try GraphQLOperation.currentEnergyPrice()
                self.currentEnergyPrice = try await tibberSwift.customOperation(operation)
                currentEnergyPriceLoading = false
            } catch {
                errorMessage = error.localizedDescription
                currentEnergyPriceLoading = false
            }
        }
    }
}

#Preview {
    TibberActionsView(apiKey: "")
}
