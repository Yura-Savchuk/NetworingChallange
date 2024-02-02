//
//  FetchRepositoriesUseCase.swift
//  NetworkingChallange
//
//  Created by Yurii Savchuk on 02.02.2024.
//

import Foundation
import Combine

final class FetchRepositoriesUseCase: FetchRepositoriesUseCaseProtocol {
    func fetch(
        _ searchText: String
    ) -> AnyPublisher<RepositoriesResponse, ApiService.ApiError> {
        let request = GetAPIRequest(
            enpoint: .repositories,
            headers: .base,
            queryItems: ["q": searchText]
        )
        return ApiService.shared.request(request)
    }
}
