import Foundation

/// The  structure of the user's price info today
public struct PriceInfoToday: Codable {
    public struct Home: Codable, Identifiable {
        public struct CurrentSubscription: Codable {
            public struct PriceInfo: Codable {
                public struct PriceInfoElement: Codable {
                    public let total: Double
                    public let energy: Double
                    public let tax: Double
                    public let startsAt: Date
                    public let currency: String
                }
                public let today: [PriceInfoElement]
            }
            public let priceInfo: PriceInfo
        }
        public let currentSubscription: CurrentSubscription
        public let id: UUID
    }
    public let homes: [Home]
}
