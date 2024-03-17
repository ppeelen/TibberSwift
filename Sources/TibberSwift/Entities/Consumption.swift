import Foundation

/// The Consumption structure
public struct Consumption: Codable {
    /// A home structure for a consumption
    public struct Home: Codable {
        /// A Home Consumption structure defining the nodes for each measurement
        public struct Consumption: Codable {
            /// A measurement node
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
