//
//  HomeViewModel.swift
//  NetworkingChallange
//
//  Created by Yurii Savchuk on 01.02.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""
    
    var cancellables: Set<AnyCancellable> = []
    var fetchRepositoriesUseCase: FetchRepositoriesUseCaseProtocol
    
    init(
        _ fetchRepositoriesUseCase: FetchRepositoriesUseCaseProtocol = FetchRepositoriesUseCase()
    ) {
        self.fetchRepositoriesUseCase = fetchRepositoriesUseCase
        $searchText.debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .dropFirst()
            .flatMap { [unowned self] text in
                if text.count > 0 {
                    self.isLoading = true
                    return self.fetchRepositoriesUseCase.fetch(text)
                } else {
                    return Just(RepositoriesResponse(items: []))
                        .mapError { $0 }
                        .eraseToAnyPublisher()
                }
            }
            .sink { [unowned self] completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedErrorMessage
                }
            } receiveValue: { [unowned self] response in
                self.isLoading = false
                self.repositories = response.items
            }
            .store(in: &cancellables)

    }
}

private extension ApiService.ApiError {
    var localizedErrorMessage: String {
        switch self {
        default:
            return "Something went wrong"
        }
    }
}
