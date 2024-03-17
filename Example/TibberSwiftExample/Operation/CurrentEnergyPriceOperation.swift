import Foundation
import TibberSwift

public extension GraphQLOperation where Input == EmptyInput, Output == CurrentEnergyPrice {
    static func currentEnergyPrice() throws -> Self {
        try GraphQLOperation(input: EmptyInput(), queryFilename: "CurrentEnergyPrice")
    }
}

public struct CurrentEnergyPrice: Codable {
    struct Home: Codable, Identifiable {
        struct CurrentSubscription: Codable {
            struct PriceInfo: Codable {
                struct Current: Codable {
                    let total: Double
                    let energy: Double
                    let tax: Double
                    let startsAt: Date
                    let currency: String
                }
                let current: Current
            }
            let priceInfo: PriceInfo
        }
        let currentSubscription: CurrentSubscription
        let id = UUID()
    }
    let homes: [Home]
}
