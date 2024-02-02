//
//  Repository.swift
//  NetworkingChallange
//
//  Created by Yurii Savchuk on 01.02.2024.
//

import Foundation

struct Repository: Decodable, Equatable {
    let id: Int
    let name: String
    let description: String
    let url: String
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case url = "html_url"
        case owner
    }
}


