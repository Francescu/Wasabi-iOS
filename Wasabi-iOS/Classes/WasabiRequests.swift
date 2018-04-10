//
//  WasabiRequests.swift
//  BrightFutures
//
//  Created by Francescu Santoni on 05/04/2018.
//

import Foundation

public enum WasabiRequest {
    case assignment
    case impression
    case event(name: String)
}

public struct WasabiNoResponse: WasabiAPIResponseProtocol {
    public init() {}
    public init?(rawAPIResponse: Any) {}
}

public struct WasabiAssignmentRequest: WasabiAPIRequestProtocol {
    public typealias Response = WasabiAssignmentResponse
    
    public let expectsResponse: Bool = true
    public let parameters: [String : Any]? = nil
    public let httpMethod: WasabiAPIRequestHTTPMethod = .post
    public let path: String = "assignments"
    public init() {}
}

public struct WasabiAssignmentResponse: WasabiAPIResponseProtocol {
    public enum Status: String {
        case new = "NEW_ASSIGNMENT", existing = "EXISTING_ASSIGNMENT"
    }
    
    public let status: Status
    public let assignment: String
    // TODO: let payload: [AnyHashable: Any]?
    
    public init?(rawAPIResponse: Any) {
        guard
        let json = rawAPIResponse as? [String: Any],
        let statusString = json["status"] as? String,
        let status = Status(rawValue: statusString),
        let assignment = json["assignment"] as? String
        else {
            return nil
        }
        
        self.status = status
        self.assignment = assignment
        
    }
}

public struct WasabiImpressionRequest: WasabiAPIRequestProtocol {
    public typealias Response = WasabiNoResponse
    public let expectsResponse: Bool = false
    public let parameters: [String : Any]? = ["events": [["name": "IMPRESSION"]]]
    public let httpMethod: WasabiAPIRequestHTTPMethod = .post
    public let path: String = "events"
    public init() {}
}

public struct WasabiEventRequest: WasabiAPIRequestProtocol {
    public typealias Response = WasabiNoResponse
    public let expectsResponse: Bool = false
    public let parameters: [String : Any]?
    public let httpMethod: WasabiAPIRequestHTTPMethod = .post
    public let path: String = "events"
    
    public init(name: String) {
        // TODO: support payload
        parameters = ["events": [["name": name]]]
    }
}
