//
//  NetworkingChallangeTests.swift
//  NetworkingChallangeTests
//
//  Created by Yurii Savchuk on 01.02.2024.
//

import XCTest
import Combine

final class NetworkingChallangeTests: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    func testSearchText_whenInputSomeValue_shouldLoadData() throws {
        // given
        let expectation = self.expectation(description: "test1")
        let response = RepositoriesResponse(items: [.init(id: 1, name: "name", description: "desc", url: "http://yrl.conm", owner: .init(awatartUrl: "avatar"))])
        let mock = FetchRepositoriesUseCaseMock(
            result: Just(response)
                .mapError { $0 }
                .eraseToAnyPublisher()
        )
        let viewModel = HomeViewModel(mock)
        cancellables = []
        
        // when
        viewModel.searchText = "q"
        
        // then
        var repositories = [Repository]()
        viewModel.$repositories
            .sink { _repositories in
                repositories = _repositories
                expectation.fulfill()
            }
            .store(in: &cancellables)
        waitForExpectations(timeout: 10)
        XCTAssertEqual(repositories, response.items)
        cancellables.removeAll()
    }
}
