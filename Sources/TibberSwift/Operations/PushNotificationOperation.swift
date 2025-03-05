import Foundation

public extension GraphQLOperation where Input == EmptyInput, Output == PushNotificationResult {

    /// Sends a push notification to all logged-in devices of the user
    /// - Parameters:
    ///   - title: Title of the notification
    ///   - message: Message of the notification
    /// - Returns: ``GraphQLOperation`` for the notification
    static func pushNotification(
        title: String,
        message: String
    ) throws -> Self {
        GraphQLOperation(input: EmptyInput(),
                         operationString: """
                mutation {
                  sendPushNotification(input: {
                    title: \"\(title)\",
                    message: \"\(message)\"
                }){
                    successful
                    pushedToNumberOfDevices
                  }
                }
                """)
    }
}
