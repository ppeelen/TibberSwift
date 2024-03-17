<p align="center">
    <img src ="Sources/TibberSwift/TibberSwift.docc/Resources/documentation/icon@2x.png" alt="TibberSwift Logo" title="TibberSwift" height=200 />
</p>

<p align="center">
    <img alt="GitHub Actions Workflow Status" src="https://img.shields.io/github/actions/workflow/status/ppeelen/TibberSwift/build-and-test.yml" />
    <img src="https://img.shields.io/badge/swift-5.9-orange.svg" alt="Swift 5.9" />
    <img src="https://img.shields.io/badge/platform-SwiftUI-blue.svg" alt="Swift UI" title="Swift UI" />
    <img src="https://img.shields.io/github/license/ppeelen/TibberSwift" alt="MIT License" />
<!--    <img src="https://img.shields.io/github/v/release/ppeelen/TibberSwift" alt="Latest release" /> -->
    <br/>
    <a href="https://mastodon.nu/@ppeelen" target="_blank">
        <img alt="Mastodon Follow" src="https://img.shields.io/mastodon/follow/109416415024329828?domain=https%3A%2F%2Fmastodon.nu&style=social&label=Mastodon%3A%20%40peelen" />
    </a>
    <a href="https://twitter.com/ppeelen" target="_blank">
        <img alt="Twitter Follow" src="https://img.shields.io/twitter/follow/swiftislandnl?label=PPeelen" alt="Twitter: @ppeelen" title="Twitter: @ppeelen" />
    </a>
</p>

# TibberSwift

`TibberSwift` is a Swift package written to make simple queries towards Tibber's GraphQL backend indeed simple, without a need of embedding large libraries. 
TibberSwift requires you to have an APIKey to function. You will write your GraphQL queries and either store them as `.graphql` file in your bundle, or directly 
add the query to the operation.

``TibberSwift`` functions by creating an operation which in turn sets an `Input` as well as an `Output`. The `Input` is of `Encodable` type and output of 
`Decodable`. You can checkout the custom `UserLoginOperation` in the Example app to see how you can create an operation inside your application.

## Installation

TibberSwift can be installed with the Swift Package Manager:

```
https://github.com/ppeelen/TibberSwift.git
```

Example:
```swift
dependencies: [
    .package(url: "https://github.com/ppeelen/TibberSwift.git", branch: "main"),
    ...
]
```

## Support
You can request support here in this Github project, but there is also a facebook group where you can request support and/or show your work. Checkout the Facebook group [Tibber for Developers](https://www.facebook.com/groups/559997709570123/).

## Usage

TibberSwift comes with documentation right inside Xcode, however there is also an example app which shows a few examples on how to fetch data from Tibber.
You will need an API key from Tibber, which can either be fetched from [their developer portal](https://developer.tibber.com/settings/access-token) or via oAuth.

This documentation will be updated over time with more examples.

Initialise TibberSwift with the API key fetched from the developer portal, or OAuth connection.
```swift
let tibberSwift = TibberSwift(apiKey: "my-api-key")
```

## Operations
There are two types of operations you can preform. Either pre-defined ones, which exist in the TibberSwift project, or you can create your custom one.

### Pre-defined operation
TibberSwift comes with two pre-defined operations, called `homes` and `consumption`. If you want to fetch the standard consumption as defined in `Consumption.graphql` (Which is based of the one from the API Explorer), you can just call the `consumption()` function from Tibber swift, like so:
```swift
private func fetchConsumption() {
    Task {
        do {
            self.consumption = try await tibberSwift.consumption()
        } catch {
            debugPrint("Could not fetch the consumption. Error: \(error.localizedDescription)")
        }
    }
}
```
The same goes for fetching homes.

### Custom Operation
If you wish to make your own custom operation, follow these steps:

#### 1: Create a query
GraphQL uses queries to fetch certain data. Check the [API Reference](https://developer.tibber.com/docs/reference) to see what queries you can create and try them out using the [API Explorer](https://developer.tibber.com/explorer). Once you have a query you need to define the Input and Output for Tibber Swift.

#### 1.2: Input
Input parameters are parameters that you send in to your query. This could be the `resulution` and `last` which are send in for Consumption. Some queries do not need any input, like fetching which user is logged in. In such case, you can use `EmptyInput` as your input parameter.

Your Input should conform to [`Encodable`](https://developer.apple.com/documentation/swift/encodable).

#### 1.3: Output
The `Output`is the data you want to extract from GraphQL that exists inside the `viewer` node. Example:
```json
{
  "data": {
    "viewer": {
        <<< OUTPUT JSON >>>
    }
  }
}
```
Your `Output` should conform to [`Codable`](https://developer.apple.com/documentation/swift/codable)

#### 2: Create operation
Create an extension to `GraphQLOperation`, where *Input* = *your new input*, and *Output* = *your new output*.

Example:
```swift
// Import the Tibber Swift project
import TibberSwift

// Create the operation
public extension GraphQLOperation where Input == EmptyInput, Output == UserLogin {
    // Create and return the operation with your query
    static func userLogin() -> Self {
        GraphQLOperation(
            input: EmptyInput(), // The input needed for your query
            // The query you created in step 1
            operationString: """
                {
                  viewer {
                    login
                  }
                }
                """
        )
    }
}

// The output you are expecting from the operation
public struct UserLogin: Codable {
    public let login: String
}
```

#### 2.1: .graphql file
If you wish to seperate your query to a graphql file, you can do so and instead use `GraphQLOperation(input:queryFilename:)` instead, like so:
```swift
static func currentEnergyPrice() throws -> Self {
    try GraphQLOperation(input: EmptyInput(), queryFilename: "CurrentEnergyPrice")
}
```

#### 3: Run the operation
Now in your code, all that is left to do is to run the operation; this is an example from the example app:
```swift
func userLoginAction() {
    userLoginLoading = true
    Task {
        do {
            let operation = GraphQLOperation.userLogin()
            self.userLogin = try await tibberSwift.customOperation(operation)
            userLoginLoading = false
        } catch {
            errorMessage = error.localizedDescription
            userLoginLoading = false
        }
    }
}
```

## Future development
This package currently does not support subscriptions. This is something that should be added in the future.