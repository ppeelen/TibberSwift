import Foundation

public extension GraphQLOperation where Input == EmptyInput, Output == [Home] {

    /// Fetches the logged in user's homes with their ID'
    /// - Returns: GraphQL Operation for homes
    static func homes() throws -> Self {
        try GraphQLOperation(input: EmptyInput(), queryFilename: "Homes")
    }
}
