//
//  WasabiAPITypes.swift
//  Pods-Wasabi-iOS_Tests
//
//  Created by Francescu Santoni on 05/04/2018.
//

import Foundation

public enum WasabiAPIError: Error {
    case client(WasabiAPIClientError), server(WasabiAPIServerError)
}

public enum WasabiAPIClientError: Error {
    case cantBuildRequest
    
    // No network?
    case requestError(Error)
    
    case noHTTPResponse
    case statusCode(Int)
    case cantInstanciateSuccessResponse
}

public enum WasabiAPIServerError: Error {
    case noData
    case statusCode(Int)
    case notValidJSON
}


public protocol WasabiAPIResponseProtocol {
    init?(rawAPIResponse: Any)
}


public protocol WasabiAPIRequestProtocol {
    associatedtype Response: WasabiAPIResponseProtocol
    var expectsResponse: Bool { get }
    var path: String { get }
    var parameters: [String : Any]? { get }
    var httpMethod: WasabiAPIRequestHTTPMethod { get }
}

public enum WasabiAPIRequestHTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

