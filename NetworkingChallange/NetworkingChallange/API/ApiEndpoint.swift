//
//  ApiEndpoint.swift
//  NetworkingChallange
//
//  Created by Yurii Savchuk on 01.02.2024.
//

import Foundation

enum ApiEndpoint: String {
    case repositories
}

extension ApiEndpoint {
    var path: String {
        switch self {
        case .repositories:
            return "/search/repositories"
        }
    }
}
