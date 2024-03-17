import Foundation

/// A Home structure defining the addresses of a user's home
public struct Home: Codable {
    /// The address structure defining a physical address of a home
    public struct Address: Codable {
        public let address1: String
        public let address2: String?
        public let address3: String?
        public let postalCode: String
        public let city: String
        public let country: String
        public let latitude: String
        public let longitude: String
    }

    /// The address of the home
    public let address: Address

    /// Tibber's internal ID for a home
    public let id: String
}
