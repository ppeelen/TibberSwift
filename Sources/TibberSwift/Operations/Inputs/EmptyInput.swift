import Foundation

/// ``EmptyInput`` is used when no input is required for the query
///
/// Example of how this is used when creating an operation:
///
///     public extension GraphQLOperation where Input == EmptyInput, Output == MyOutput { ... }
///
public struct EmptyInput: Encodable {
    public init() { }
}
