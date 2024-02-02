//
//  Owner.swift
//  NetworkingChallange
//
//  Created by Yurii Savchuk on 02.02.2024.
//

import Foundation

struct Owner: Decodable, Equatable {
    let awatartUrl: String
    
    enum CodingKeys: String, CodingKey {
        case awatartUrl = "avatar_url"
    }
}
