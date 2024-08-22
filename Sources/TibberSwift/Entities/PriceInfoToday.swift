import Foundation

struct PriceInfoElement: Codable {
    let total: Double
    let energy: Double
    let tax: Double
    let startsAt: Date
    let currency: String
}

/// The  structure of the user's price info today
public struct PriceInfoToday: Codable {
    struct Home: Codable, Identifiable {
        struct CurrentSubscription: Codable {
            struct PriceInfo: Codable {
                let today: [PriceInfoElement]
            }
            let priceInfo: PriceInfo
        }
        let currentSubscription: CurrentSubscription
        let id: UUID
    }
    let homes: [Home]
}
