import XCTest
@testable import TibberSwift

final class GraphQLOperationTests: XCTestCase {

    var urlSessionMock: URLSessionMock!
    var sut: TibberSwift!

    override func setUp() async throws {
        let urlSessionMock = URLSessionMock()
        self.urlSessionMock = urlSessionMock
    }

    override func tearDown() async throws {
        urlSessionMock = nil
    }

    // MARK: - Test customOperation

    func testCustomOperation() async throws {
        // Given
        guard
            let data = TestDataManager.getData(forFile: "Operations/TestOperation.graphql"),
            let query = String(data: data, encoding: .utf8)
        else {
            XCTFail("File not found!")
            return
        }
        let returnValue = TestDataManager.getData(forFile: "json/DummyResult.json")!
        urlSessionMock.dataForReturnValue = (returnValue, TestDataManager.dummyResponse())

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        let operation: GraphQLOperation<EmptyInput, DummyResult> = GraphQLOperation(input: EmptyInput(), operationString: query, jsonEncoder: encoder)

        // When
        let sut = TibberSwift(apiKey: "test", urlSession: urlSessionMock)
        let result = try await sut.customOperation(operation)

        // Then
        XCTAssertEqual(result.name, "Dummy")
        XCTAssertEqual(String(data: urlSessionMock.dataRequest?.httpBody ?? Data(), encoding: .utf8), "{\"query\":\"{\\n  viewer {\\n    homes {\\n      name\\n    }\\n  }\\n}\\n\",\"variables\":{}}")
        XCTAssertEqual(urlSessionMock.dataRequestInvokeCount, 1)
        XCTAssertEqual(urlSessionMock.dataRequest?.url?.absoluteString, "https://api.tibber.com/v1-beta/gql")
        XCTAssertEqual(urlSessionMock.dataRequest?.httpMethod, "POST")
        XCTAssertEqual(urlSessionMock.dataRequest?.allHTTPHeaderFields, ["Content-Type": "application/json",
                                                                         "Authorization": "test",
                                                                         "User-Agent": "TibberSwift"])
    }

    func testCustomOperationHomesFile() async throws {
        // Given
        let returnValue = TestDataManager.getData(forFile: "json/DummyResult.json")!
        urlSessionMock.dataForReturnValue = (returnValue, TestDataManager.dummyResponse())

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        // When
        let sut = TibberSwift(apiKey: "test", urlSession: urlSessionMock)

        let operation: GraphQLOperation<EmptyInput, DummyResult> = try GraphQLOperation(input: EmptyInput(), queryFilename: "Homes", jsonEncoder: encoder)
        let result = try await sut.customOperation(operation)

        // Then
        XCTAssertEqual(result.name, "Dummy")
        XCTAssertEqual(String(data: urlSessionMock.dataRequest?.httpBody ?? Data(), encoding: .utf8), "{\"query\":\"{\\n  viewer {\\n    homes {\\n      id\\n      address {\\n        address1\\n        address2\\n        address3\\n        postalCode\\n        city\\n        country\\n        latitude\\n        longitude\\n      }\\n    }\\n  }\\n}\\n\",\"variables\":{}}")
        XCTAssertEqual(urlSessionMock.dataRequestInvokeCount, 1)
        XCTAssertEqual(urlSessionMock.dataRequest?.url?.absoluteString, "https://api.tibber.com/v1-beta/gql")
        XCTAssertEqual(urlSessionMock.dataRequest?.httpMethod, "POST")
        XCTAssertEqual(urlSessionMock.dataRequest?.allHTTPHeaderFields, ["Content-Type": "application/json",
                                                                         "Authorization": "test",
                                                                         "User-Agent": "TibberSwift"])
    }

    func testCustomOperationFileNotFound() async throws {
        // Given
        let returnValue = TestDataManager.getData(forFile: "json/DummyResult.json")!
        urlSessionMock.dataForReturnValue = (returnValue, TestDataManager.dummyResponse())

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        // When
        let sut = TibberSwift(apiKey: "test", urlSession: urlSessionMock)

        do {
            let operation: GraphQLOperation<EmptyInput, DummyResult> = try GraphQLOperation(input: EmptyInput(), queryFilename: "InvalidFileName", jsonEncoder: encoder)
            _ = try await sut.customOperation(operation)
        } catch {
            guard let error = error as? GraphQLOperationError else {
                XCTFail("Invalid error returned")
                return
            }
            XCTAssertEqual(error, GraphQLOperationError.queryFileNotFound)
        }

        // Then
        XCTAssertEqual(urlSessionMock.dataRequestInvokeCount, 0)
    }
}

private struct DummyResult: Codable {
    let name: String
}
