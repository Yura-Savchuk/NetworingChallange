//
//  FetchRepositoriesUseCaseProtocol.swift
//  NetworkingChallange
//
//  Created by Yurii Savchuk on 02.02.2024.
//

import Foundation
import Combine

protocol FetchRepositoriesUseCaseProtocol {
    func fetch(
        _ searchText: String
    ) -> AnyPublisher<RepositoriesResponse, ApiService.ApiError>
}
