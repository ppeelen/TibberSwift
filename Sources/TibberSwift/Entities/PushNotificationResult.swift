/// The PushNotificationResult structure
public struct PushNotificationResult: Codable {
    public struct Response: Codable {
        public let successful: Bool
        public let pushedToNumberOfDevices: Int
    }
    public let sendPushNotification: Response
}
