import Foundation

public extension GraphQLOperation where Input == ConsumptionInput, Output == Consumption {

    /// Fetches the consumption for all the logged-in user's homes
    /// - Parameters:
    ///   - resolution: The type of EnergyResolution (Hourly, daily or monthly)
    ///   - last: The last n entries
    /// - Returns: ``GraphQLOperation`` for consumption
    static func consumption(
        resolution: ConsumptionResolution = .hourly,
        last: Int
    ) throws -> Self {
        try GraphQLOperation(
            input: ConsumptionInput(resolution: resolution, last: last),
            queryFilename: "Consumption"
        )
    }
}
