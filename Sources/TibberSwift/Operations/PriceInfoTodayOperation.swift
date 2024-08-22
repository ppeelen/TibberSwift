import Foundation

public extension GraphQLOperation where Input == EmptyInput, Output == PriceInfoToday {

    /// Fetches the logged in user's price info of today
    /// - Returns: GraphQL Operation for homes
    static func priceInfoToday() throws -> Self {
        try GraphQLOperation(input: EmptyInput(), queryFilename: "PriceInfoToday")
    }
}
