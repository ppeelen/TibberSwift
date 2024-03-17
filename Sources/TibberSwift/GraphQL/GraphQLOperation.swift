import Foundation

/// The errors that can be returned by ``GraphQLOperation``
public enum GraphQLOperationError: Error {
    /// The query file defined is not found
    case queryFileNotFound
    /// The query file was found, but the data for it could not be retrieved
    case noDataForQuery

    /// The human readable error description
    public var errorDescription: String? {
        switch self {
        case .queryFileNotFound:
            "Provided query file was not found."
        case .noDataForQuery:
            "No data was found for query"
        }
    }
}

protocol GraphQLOperationDefinition {
    func encode(to encoder: Encoder) throws
    func getURLRequest(apiKey: String) throws -> URLRequest
}

/// The GraphQL Operation, which handles the query send to the server and the expected result from said operation
public struct GraphQLOperation<Input: Encodable, Output: Decodable>: GraphQLOperationDefinition, Encodable {
    private var input: Input
    private var operationString: String
    private let url = URL(string: "https://api.tibber.com/v1-beta/gql")! // swiftlint:disable:this force_unwrapping
    private let jsonEncoder: JSONEncoder

    /// Init method used with Input and GraphQL query string
    /// - Parameters:
    ///   - input: The input encodable to use with the query
    ///   - operationString: The operation string, aka graphQL query to use
    public init(input: Input, operationString: String, jsonEncoder: JSONEncoder = JSONEncoder()) {
        self.input = input
        self.operationString = operationString
        self.jsonEncoder = jsonEncoder
    }

    /// Init method used with Input and reference to GraphQL query file
    ///
    /// The query file should be available in the same bundle as TibberSwift exists in.
    /// - Parameters:
    ///   - input: The input encodable to use with the query
    ///   - queryFilename: The filename of the query file, excluding the extension. The query file's extension should be `.graphql`.
    public init(input: Input, queryFilename: String, jsonEncoder: JSONEncoder = JSONEncoder()) throws {
        self.input = input

        let url: URL
        if let moduleUrl = Bundle.module.url(forResource: "\(queryFilename)", withExtension: "graphql") {
            url = moduleUrl
        } else if let mainUrl = Bundle.main.url(forResource: "\(queryFilename)", withExtension: "graphql") {
            url = mainUrl
        } else {
            throw GraphQLOperationError.queryFileNotFound
        }
        let data = try Data(contentsOf: url)
        
        guard let queryString = String(data: data, encoding: .utf8) else { throw GraphQLOperationError.noDataForQuery }
        self.operationString = queryString
        self.jsonEncoder = jsonEncoder
    }

    private enum CodingKeys: CodingKey {
        case variables, query
    }

    /// Encodes this value into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(input, forKey: .variables)
        try container.encode(operationString, forKey: .query)
    }

    internal func getURLRequest(apiKey: String) throws -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("TibberSwift", forHTTPHeaderField: "User-Agent")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        request.httpBody = try jsonEncoder.encode(self)

        return request
    }
}
