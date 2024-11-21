// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Logging

/// ``TibberSwift`` is a simple SPM that helps you create queries towards Tibber's GraphQL server.
public final class TibberSwift {
    private let apiKey: String

    private let jsonDecoder: JSONDecoder
    private let urlSession: URLSessionDefinition

    private let logger = Logger(label: "io.github.ppeelencom.TibberSwift")

    /// The init method for ``TibberSwift``, requires the ApiKey to be send in. This can be fetched from [https://developer.tibber.com](https://developer.tibber.com/settings/access-token)
    /// - Parameter apiKey: The API Key from Tibber
    public convenience init(apiKey: String) {
        self.init(apiKey: apiKey, jsonDecoder: JSONDecoder(), urlSession: URLSession.shared)
    }

    /// Meant for dependency injection while using tests
    internal init(apiKey: String, jsonDecoder: JSONDecoder = JSONDecoder(), urlSession: URLSessionDefinition = URLSession.shared) {
        self.apiKey = apiKey
        self.jsonDecoder = jsonDecoder
        self.urlSession = urlSession
    }
}

/// Example functions based on Tibber's API Explorer
public extension TibberSwift {

    /// Fetched the logged in user
    func loggedInUser() async throws -> LoggedInUser {
        let operation = try GraphQLOperation.loggedInUser()

        return try await performOperation(operation)
    }

    /// Fetches the user's homes
    /// - Returns: A list of all homes
    func homes() async throws -> [Home] {
        let operation = try GraphQLOperation.homes()

        return try await performOperation(operation)
    }

    /// Fetches the latest 100 hourly consumptions for all user's homes
    /// - Returns: A list of the last 100 measured consumptions
    func consumption() async throws -> Consumption {
        let operation = try GraphQLOperation.consumption(resolution: .hourly, last: 100)
        return try await performOperation(operation)
    }
    
    /// Fetches the user's price information of today
    /// - Returns: A list of all price information
    func priceInfoToday() async throws -> PriceInfoToday {
        let operation = try GraphQLOperation.priceInfoToday()
        return try await performOperation(operation)
    }

    /// Custom GraphQL operation
    /// - Parameter operation: The operation in question
    /// - Returns: the desired `Output` defined in the operation
    func customOperation<Input, Output>(_ operation: GraphQLOperation<Input, Output>) async throws -> Output {
        try await performOperation(operation)
    }
}

private extension TibberSwift {

    /// Perform an operator from Tibber APIs
    /// - Parameter operation: The operation to preform
    /// - Returns: The output for the operation
    func performOperation<Input, Output>(_ operation: GraphQLOperation<Input, Output>) async throws -> Output {
        logger.info("Initiating new request.")

        let request = try operation.getURLRequest(apiKey: apiKey)

        let (data, response) = try await urlSession.data(for: request)

        logger.info("Received response. Got data of \(data.count) bytes.")

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            logger.error("Invalid response received. Could not get a status code.")
            throw TibberSwiftError.invalidResponse
        }

        guard (200...300).contains(statusCode) else {
            if let data = String(data: data, encoding: .utf8) {
                logger.error("Invalid status code received. Expected status code between 200 and 300, but got \(statusCode) instead. Data: \(data)")
            } else {
                logger.error("Invalid status code received. Expected status code between 200 and 300, but got \(statusCode) instead.")
            }
            throw TibberSwiftError.invalidStatusCode(statusCode)
        }

        jsonDecoder.dateDecodingStrategyFormatters = [ DateFormatter.json ]

        let result = try jsonDecoder.decode(GraphQLResult<Output>.self, from: data)
        if let object = result.object {
            logger.info("Decoded object to \(Output.self). Done.")
            return object
        } else {
            logger.error("Could not transform result object to request data object (\(Output.self))")
            throw TibberSwiftError.decodingError
        }
    }
}

/// The errors that can be returned by ``TibberSwift``
public enum TibberSwiftError: LocalizedError {
    /// Thrown when the response of the HTTP call is invalid
    case invalidResponse
    /// Thrown if the statusCode of the response object from the HTTP call is not between 200 and 300, included the response object. If data is available, this will be logged to the console.
    case invalidStatusCode(Int)
    /// Thrown if the response from the HTTP call could not be decoded to the requested Output
    case decodingError

    /// The human readable error description
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            "Invalid response received. Could not get a status code."
        case .invalidStatusCode(let statusCode):
            "Invalid status code received. Expected status code between 200 and 300, but got \(statusCode) instead."
        case .decodingError:
            "Could not transform result object to request data object"
        }
    }
}

extension TibberSwiftError: Equatable { }

protocol URLSessionDefinition {
    func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSessionDefinition {
    func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: delegate)
    }
}

extension URLSession: URLSessionDefinition { }
