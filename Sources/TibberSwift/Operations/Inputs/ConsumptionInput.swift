import Foundation

public enum ConsumptionResolution: String, Encodable {
    case hourly = "HOURLY"
    case daily = "DAILY"
    case monthly = "MONTHLY"
}

public struct ConsumptionInput: Encodable {
    let resolution: ConsumptionResolution
    let last: Int
}
