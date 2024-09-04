import Foundation

public extension GraphQLOperation where Input == EmptyInput, Output == PushNotificationResult {

    /// Sends a push notification to all logged-in devices of the user
    /// - Parameters:
    ///   - title: The type of EnergyResolution (Hourly, daily or monthly)
    ///   - message: Message of the push notification
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
