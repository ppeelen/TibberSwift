import Foundation

struct GraphQLResult<T: Decodable>: Decodable {
    let object: T?
    let errorMessages: [String]

    struct ViewerResult<V: Decodable>: Decodable {
        let viewer: V?

        enum CodingKeys: CodingKey { // swiftlint:disable:this nesting
            case viewer
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            if let dataDict = try? container.decodeIfPresent(V.self, forKey: .viewer) {
                self.viewer = dataDict
            } else {
                let dataDict = try container.decodeIfPresent([String: V].self, forKey: .viewer)
                self.viewer = dataDict?.values.first
            }
        }
    }

    enum CodingKeys: CodingKey {
        case data, errors
    }

    struct Error: Decodable {
        let message: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let dataObj = try container.decodeIfPresent(ViewerResult<T>.self, forKey: .data)
        self.object = dataObj?.viewer

        var errorMessages: [String] = []
        if let errors = try container.decodeIfPresent([Error].self, forKey: .errors) {
            errorMessages.append(contentsOf: errors.map { $0.message })
        }
        self.errorMessages = errorMessages
    }
}
