import Foundation
@testable import TibberSwift

final class URLSessionMock: URLSessionDefinition {
    public var dataRequestInvokeCount = 0
    public var dataRequest: URLRequest?
    public var dataDelegate: URLSessionTaskDelegate?
    public var dataForReturnValue: (Data, URLResponse)?

    func data(for request: URLRequest, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse) {
        dataRequestInvokeCount += 1
        dataRequest = request
        dataDelegate = delegate

        guard let dataForReturnValue else { fatalError("No return value set") }
        return dataForReturnValue
    }
}
