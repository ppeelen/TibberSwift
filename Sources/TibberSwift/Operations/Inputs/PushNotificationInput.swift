/// The `title` and `mesage` that will be delivered by the push notification.
public struct PushNotificationInput: Encodable {
    let title: String
    let message: String
}
