//
//  ApiHeaders.swift
//  NetworkingChallange
//
//  Created by Yurii Savchuk on 01.02.2024.
//

import Foundation

enum ApiHeaders {
    case base
}

extension ApiHeaders {
    var asDictionary: [String: String] {
        switch self {
        case .base:
            return [
                "Accept": "application/vnd.github+json",
                "Authorization": "Authorization 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",
                "X-GitHub-Api-Version": "2022-11-28"
            ]
        }
    }
}
