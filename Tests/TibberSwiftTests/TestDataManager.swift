import Foundation

final class TestDataManager {
    static func getData(forFile file: String) -> Data? {
        if let path = Bundle.module.path(forResource: file, ofType: nil),
           let file = FileManager().contents(atPath: path)
        {
            return file as Data?
        }

        return nil
    }

    static func dummyResponse(withUrl url: String = "https://dummy.url/",
                              statusCode: Int = 200,
                              responseHeaders: [String: String]? = nil) -> URLResponse {
        let responseHeaderFields: [String: String] = responseHeaders ?? [:]

        var response: URLResponse? = nil
        if let url = URL(string: "\(url)"),
           let httpResponse = HTTPURLResponse(url: url,
                                              statusCode: statusCode,
                                              httpVersion: nil,
                                              headerFields: responseHeaderFields) {
            response = httpResponse
        }

        return response!
    }
}
