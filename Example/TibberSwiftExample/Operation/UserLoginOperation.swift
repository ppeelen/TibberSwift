import Foundation
import TibberSwift

public extension GraphQLOperation where Input == EmptyInput, Output == UserLogin {
    static func userLogin() -> Self {
        GraphQLOperation(
            input: EmptyInput(),
            operationString: """
                {
                  viewer {
                    login
                  }
                }
                """
        )
    }
}

public struct UserLogin: Codable {
    public let login: String
}
