import Foundation

public struct Home: Codable {
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

    public let address: Address
    public let id: String
}
