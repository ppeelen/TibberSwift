<p align="center">
    <img src ="Sources/TibberSwift/TibberSwift.docc/Resources/documentation/icon@2x.png" alt="TibberSwift Logo" title="TibberSwift" height=200 />
</p>

<p align="center">
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

## Usage

TibberSwift comes with documentation right inside Xcode, however there is also an example app which shows a few examples on how to fetch data from Tibber.
You will need an API key from Tibber, which can either be fetched from [their developer portal](https://developer.tibber.com/settings/access-token) or via oAuth.

This documentation will be updated over time with more examples.
