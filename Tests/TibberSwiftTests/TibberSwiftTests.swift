import XCTest
@testable import TibberSwift

final class TibberSwiftTests: XCTestCase {
    
    var urlSessionMock: URLSessionMock!
    var sut: TibberSwift!
    
    override func setUp() async throws {
        let urlSessionMock = URLSessionMock()
        self.urlSessionMock = urlSessionMock
    }
    
    override func tearDown() async throws {
        urlSessionMock = nil
    }
    
    // MARK: - TibberSwift network operations
    
    func testInvalidStatusCode() async throws {
        urlSessionMock.dataForReturnValue = (Data(), TestDataManager.dummyResponse(statusCode: 404))
        
        let sut = TibberSwift(apiKey: "abc123", urlSession: urlSessionMock)
        
        // When
        do {
            _ = try await sut.loggedInUser()
            XCTFail("Test should not continue successfully.")
        } catch {
            guard case TibberSwiftError.invalidStatusCode(let statusCode) = error else {
                XCTFail("Invalid error returned")
                return
            }
            XCTAssertEqual(statusCode, 404)
        }
    }
    
    func testInvalidResponse() async throws {
        urlSessionMock.dataForReturnValue = (Data(), URLResponse())
        
        let sut = TibberSwift(apiKey: "abc123", urlSession: urlSessionMock)
        
        // When
        do {
            _ = try await sut.loggedInUser()
            XCTFail("Test should not continue successfully.")
        } catch {
            guard let error = error as? TibberSwiftError else {
                XCTFail("Invalid error returned")
                return
            }
            XCTAssertEqual(error, TibberSwiftError.invalidResponse)
        }
        
        XCTAssertEqual(urlSessionMock.dataRequestInvokeCount, 1)
    }
    
    // MARK: - Test loggedInUser()
    
    func testLoggedInUser() async throws {
        // Given
        let data = TestDataManager.getData(forFile: "json/UserLogin.json")!
        urlSessionMock.dataForReturnValue = (data, TestDataManager.dummyResponse())
        
        let sut = TibberSwift(apiKey: "tibberSwiftApiKey", urlSession: urlSessionMock)
        
        // When
        let result = try await sut.loggedInUser()
        
        // Then
        XCTAssertEqual(result.name, "John Appleseed")
        XCTAssertEqual(urlSessionMock.dataRequestInvokeCount, 1)
        XCTAssertNil(urlSessionMock.dataDelegate)
        XCTAssertEqual(urlSessionMock.dataRequest?.url?.absoluteString, "https://api.tibber.com/v1-beta/gql")
        XCTAssertEqual(urlSessionMock.dataRequest?.httpMethod, "POST")
        XCTAssertEqual(urlSessionMock.dataRequest?.allHTTPHeaderFields, ["Content-Type": "application/json",
                                                                         "Authorization": "tibberSwiftApiKey",
                                                                         "User-Agent": "TibberSwift"])
    }
    
    // MARK: - Test homes()
    
    func testHomesOneAddress() async throws {
        let data = TestDataManager.getData(forFile: "json/homes.json")!
        urlSessionMock.dataForReturnValue = (data, TestDataManager.dummyResponse())
        
        let sut = TibberSwift(apiKey: "tibberSwiftApiKey", urlSession: urlSessionMock)
        
        let result = try await sut.homes()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, "f2a876f3-e09e-4bba-af19-79b038893c3d")
        XCTAssertEqual(result.first?.address.city, "Cupertino")
        XCTAssertEqual(urlSessionMock.dataRequestInvokeCount, 1)
        XCTAssertNil(urlSessionMock.dataDelegate)
        XCTAssertEqual(urlSessionMock.dataRequest?.url?.absoluteString, "https://api.tibber.com/v1-beta/gql")
        XCTAssertEqual(urlSessionMock.dataRequest?.httpMethod, "POST")
        XCTAssertEqual(urlSessionMock.dataRequest?.allHTTPHeaderFields, ["Content-Type": "application/json",
                                                                         "Authorization": "tibberSwiftApiKey",
                                                                         "User-Agent": "TibberSwift"])
    }
    
    func testHomesMultipleAddress() async throws {
        let data = TestDataManager.getData(forFile: "json/homesMultiple.json")!
        urlSessionMock.dataForReturnValue = (data, TestDataManager.dummyResponse())
        
        let sut = TibberSwift(apiKey: "otherKey", urlSession: urlSessionMock)
        
        let result = try await sut.homes()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, "f2a876f3-e09e-4bba-af19-79b038893c3d")
        XCTAssertEqual(result[0].address.city, "Cupertino")
        XCTAssertEqual(result[0].address.postalCode, "95014")
        XCTAssertEqual(result[1].id, "e6bbdcc2-5878-41a2-b89d-b49aca5df2eb")
        XCTAssertEqual(result[1].address.city, "Cupertino")
        XCTAssertEqual(result[1].address.postalCode, "12345")
        XCTAssertEqual(urlSessionMock.dataRequestInvokeCount, 1)
        XCTAssertNil(urlSessionMock.dataDelegate)
        XCTAssertEqual(urlSessionMock.dataRequest?.url?.absoluteString, "https://api.tibber.com/v1-beta/gql")
        XCTAssertEqual(urlSessionMock.dataRequest?.httpMethod, "POST")
        XCTAssertEqual(urlSessionMock.dataRequest?.allHTTPHeaderFields, ["Content-Type": "application/json",
                                                                         "Authorization": "otherKey",
                                                                         "User-Agent": "TibberSwift"])
    }
    
    // MARK: - Test Consumption
    
    func testConsumption() async throws {
        // Given
        let data = TestDataManager.getData(forFile: "json/Consumption.json")!
        urlSessionMock.dataForReturnValue = (data, TestDataManager.dummyResponse())
        
        let sut = TibberSwift(apiKey: "consumptionKey", urlSession: urlSessionMock)
        
        // When
        let result = try await sut.consumption()
        
        // Then
        XCTAssertEqual(result.homes.first?.id, "f2a876f3-e09e-4bba-af19-79b038893c3d")
        XCTAssert(result.homes.first?.consumption.nodes.isEmpty == false)
        XCTAssertEqual(result.homes.first?.consumption.nodes.first?.cost, 1.7705849)
        XCTAssertEqual(urlSessionMock.dataRequestInvokeCount, 1)
        XCTAssertNil(urlSessionMock.dataDelegate)
        XCTAssertEqual(urlSessionMock.dataRequest?.url?.absoluteString, "https://api.tibber.com/v1-beta/gql")
        XCTAssertEqual(urlSessionMock.dataRequest?.httpMethod, "POST")
        XCTAssertEqual(urlSessionMock.dataRequest?.allHTTPHeaderFields, ["Content-Type": "application/json",
                                                                         "Authorization": "consumptionKey",
                                                                         "User-Agent": "TibberSwift"])
    }
    
    // MARK: - Test Push Notification
    
    func testPushNotification() async throws {
        // Given
        let data = TestDataManager.getData(forFile: "json/PushNotificationResult.json")!
        urlSessionMock.dataForReturnValue = (data, TestDataManager.dummyResponse())
        
        let sut = TibberSwift(apiKey: "pushNotificationKey", urlSession: urlSessionMock)
        
        // When
        let result = try await sut.pushNotification(title: "test-title", message: "test-message")
        
        // Then
        XCTAssertTrue(result.sendPushNotification.successful)
        XCTAssertEqual(result.sendPushNotification.pushedToNumberOfDevices, 1)
    }
}
