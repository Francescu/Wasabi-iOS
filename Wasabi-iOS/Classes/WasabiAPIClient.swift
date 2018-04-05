//
//  WasabiAPIClient.swift
//  Pods-Wasabi-iOS_Tests
//
//  Created by Francescu Santoni on 05/04/2018.
//

import Foundation
import BrightFutures

public class WasabiAPIClient {
    private static let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    public static var defaultBaseUrl: URL?
    public static var defaultApplication: String?
    
    let userId: String
    let experiment: String
    let application: String
    let baseUrl: URL
    
    public init(userId: String, experiment: String, application: String? = nil, baseUrl: URL? = nil) {
        self.userId = userId
        self.experiment = experiment
        self.application = application ?? WasabiAPIClient.defaultApplication!
        self.baseUrl = baseUrl ?? WasabiAPIClient.defaultBaseUrl!
        
    }
    
    public func request<T: WasabiAPIRequestProtocol>(_ request: T) -> Future<T.Response, WasabiAPIError> {
        return Future<T.Response, WasabiAPIError> { completion in
            guard let urlRequest = self.urlRequestFor(request),
                let _ = urlRequest.url
                else {
                    completion(.failure(.client(.cantBuildRequest)))
                    return
            }
            
            WasabiAPIClient.session.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(.failure(.client(.requestError(error))))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    completion(.failure(.client(.noHTTPResponse)))
                    return
                }
                
                let statusCode = response.statusCode
                if statusCode >= 400 && statusCode < 500 {
                    completion(.failure(.client(.statusCode(statusCode))))
                    return
                }
                else if statusCode >= 500 {
                    completion(.failure(.server(.statusCode(statusCode))))
                    return
                }
                else {
                    guard request.expectsResponse else {
                        completion(.success(T.Response.init(rawAPIResponse: 0)!))
                        return
                    }
                    guard let data = data else {
                        completion(.failure(.server(.noData)))
                        return
                    }
                    
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                        completion(.failure(.server(.notValidJSON)))
                        return
                    }
                    
                    guard let result = T.Response.init(rawAPIResponse: json) else {
                        completion(.failure(.client(.cantInstanciateSuccessResponse)))
                        return
                    }
                    
                    completion(.success(result))
                }
                
                
                }.resume()
        }
        
        
    }
    
    private func urlRequestFor<T: WasabiAPIRequestProtocol>(_ request: T) -> URLRequest? {
//        http://<domain>:<port>/api/v1/assignments/applications/<application>/experiments/<experiment>/users/<userId>

        let url = baseUrl
            .appendingPathComponent(request.path)
            .appendingPathComponent("applications")
            .appendingPathComponent(application)
            .appendingPathComponent("experiments")
            .appendingPathComponent(experiment)
            .appendingPathComponent("users")
            .appendingPathComponent(userId)
        
        var r = URLRequest(url: url)
        
        
        if request.httpMethod == .post {
            if let parameters = request.parameters {
                r.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            }
            r.addValue("application/json", forHTTPHeaderField: "Content-Type")
            r.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        
        
        r.httpMethod = request.httpMethod.rawValue
        
        return r
    }
    
    
    
}
