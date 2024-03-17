import Foundation

/// Used for defining the consumption energy resolution type
public enum ConsumptionResolution: String, Encodable {
    case hourly = "HOURLY"
    case daily = "DAILY"
    case monthly = "MONTHLY"
}

/// ``ConsumptionInput`` is used when using the ``Consumption`` operation. The operation uses this structure to set resolution and the amount for `last`.
public struct ConsumptionInput: Encodable {
    let resolution: ConsumptionResolution
    let last: Int
}
