import Foundation

public struct Consumption: Codable {
    public struct Home: Codable {
        public struct Consumption: Codable {
            public struct Node: Codable {
                public let from: Date
                public let to: Date
                public let cost: Double
                public let currency: String
                public let unitPrice: Double
                public let unitPriceVAT: Double
                public let consumption: Double
                public let consumptionUnit: String
            }
            public let nodes: [Node]
        }
        public let consumption: Consumption
        public let id: String
    }
    public let homes: [Home]
}
