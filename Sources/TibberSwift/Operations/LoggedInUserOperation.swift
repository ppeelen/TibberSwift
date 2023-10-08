import Foundation

public extension GraphQLOperation where Input == EmptyInput, Output == LoggedInUser {

    /// Fetches the logged in user for the api key provided
    /// - Returns: GraphQL Operation for LoggedInUser
    static func loggedInUser() throws -> Self {
        try GraphQLOperation(input: EmptyInput(), queryFilename: "LoggedInUser")
    }
}
