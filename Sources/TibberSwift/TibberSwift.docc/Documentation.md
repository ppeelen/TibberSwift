# ``TibberSwift``

``TibberSwift`` is a Swift package written to make simple queries towards Tibber's GraphQL backend indeed simple, without a need of embedding large libraries. 
TibberSwift requires you to have an APIKey to function. You will write your GraphQL queries and either store them as `.graphql` file in your bundle, or directly 
add the query to the operation.

@Metadata {
    @PageImage(
        purpose: icon, 
        source: "icon", 
        alt: "TibberSwift icon.")
    @PageColor(orange)
}

## Overview

``TibberSwift`` functions by creating an operation which in turn sets an `Input` as well as an `Output`. The `Input` is of `Encodable` type and output of 
`Decodable`. You can checkout the custom `UserLoginOperation` in the Example app to see how you can create an operation inside your application.
