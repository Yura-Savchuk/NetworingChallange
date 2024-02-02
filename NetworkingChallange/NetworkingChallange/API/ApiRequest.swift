//
//  ApiRequest.swift
//  NetworkingChallange
//
//  Created by Yurii Savchuk on 01.02.2024.
//

import Foundation

class ApiRequest {
    let enpoint: ApiEndpoint
    let headers: ApiHeaders
    
    init(enpoint: ApiEndpoint, headers: ApiHeaders) {
        self.enpoint = enpoint
        self.headers = headers
    }
    
    var httpMethod: String {
        fatalError("function must overriden in subclass")
    }
    
    func setupParams(for urlRequest: inout URLRequest) {
    }
}

final class GetAPIRequest: ApiRequest {
    let queryItems: [String: String]?
    
    init(
        enpoint: ApiEndpoint,
        headers: ApiHeaders = .base,
        queryItems: [String : String]? = nil
    ) {
        self.queryItems = queryItems
        super.init(enpoint: enpoint, headers: headers)
    }
    
    override var httpMethod: String {
        "GET"
    }
    
    override func setupParams(for urlRequest: inout URLRequest) {
        guard let queryItems else {
            return
        }
        
        urlRequest.url?.append(
            queryItems: queryItems.map {
                    .init(name: $0, value: $1)
            }
        )
    }
}
