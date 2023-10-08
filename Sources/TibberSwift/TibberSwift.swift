// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import os.log

public final class TibberSwift {
    private let apiKey: String

    private let jsonDecoder: JSONDecoder
    private let urlSession: URLSession

    private let log = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: TibberSwift.self)
    )

    public init(apiKey: String) {
        self.apiKey = apiKey
        self.jsonDecoder = JSONDecoder()
        self.urlSession = URLSession.shared
    }

    internal init(apiKey: String, jsonDecoder: JSONDecoder = JSONDecoder(), urlSession: URLSession = URLSession.shared) {
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
        log.info("Initiating new request.")

        let request = try operation.getURLRequest(apiKey: apiKey)

        log.info("URL: \(request.url!, privacy: .private)") // swiftlint:disable:this force_unwrapping

        let (data, response) = try await urlSession.data(for: request)

        log.info("Received response. Got data of \(data.count, privacy: .public) bytes.")

        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            log.error("Invalid response received. Could not get a status code.")
            throw TibberSwiftError.invalidResponse
        }

        guard (200...300).contains(statusCode) else {
            if let data = String(data: data, encoding: .utf8) {
                log.error("Invalid status code received. Expected status code between 200 and 300, but got \(statusCode, privacy: .public) instead. Data: \(data, privacy: .public)")
            } else {
                log.error("Invalid status code received. Expected status code between 200 and 300, but got \(statusCode, privacy: .public) instead.")
            }
            throw TibberSwiftError.invalidStatusCode(statusCode)
        }

        jsonDecoder.dateDecodingStrategyFormatters = [ DateFormatter.json ]

        let result = try jsonDecoder.decode(GraphQLResult<Output>.self, from: data)
        if let object = result.object {
            log.info("Decoded object to \(Output.self, privacy: .public). Done.")
            return object
        } else {
            log.error("Could not transform result object to request data object (\(Output.self, privacy: .public))")
            throw TibberSwiftError.decodingError
        }
    }
}

public enum TibberSwiftError: LocalizedError {
    case invalidResponse
    case invalidStatusCode(Int)
    case noData
    case decodingError

    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            "Invalid response received. Could not get a status code."
        case .invalidStatusCode(let statusCode):
            "Invalid status code received. Expected status code between 200 and 300, but got \(statusCode) instead."
        case .noData:
            "No data was provided by the endpoint"
        case .decodingError:
            "Could not transform result object to request data object"
        }
    }
}

private enum LogLevel {
    case info, warning, error
}
