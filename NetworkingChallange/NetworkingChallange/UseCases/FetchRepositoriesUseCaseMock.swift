//
//  FetchRepositoriesUseCase.swift
//  NetworkingChallange
//
//  Created by Yurii Savchuk on 02.02.2024.
//

import Foundation
import Combine

final class FetchRepositoriesUseCaseMock: FetchRepositoriesUseCaseProtocol {
    let result: AnyPublisher<RepositoriesResponse, ApiService.ApiError>
    
    init(result: AnyPublisher<RepositoriesResponse, ApiService.ApiError>) {
        self.result = result
    }
    
    func fetch(
        _ searchText: String
    ) -> AnyPublisher<RepositoriesResponse, ApiService.ApiError> {
        return result
    }
}
