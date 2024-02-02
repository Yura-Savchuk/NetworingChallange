//
//  HomeView.swift
//  NetworkingChallange
//
//  Created by Yurii Savchuk on 01.02.2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                if viewModel.repositories.isEmpty {
                    Text("Searching for \(viewModel.searchText)")
                        .navigationTitle("Search for repo")
                } else {
                    List {
                        ForEach(viewModel.repositories, id: \.id) { item in
                            NavigationLink {
                                if let url = URL(string: item.url) {
                                    WebView(url: url)
                                        .ignoresSafeArea()
                                        .navigationBarTitleDisplayMode(.inline)
                                } else {
                                    Text("Unable to open web page.")
                                }
                            } label: {
                                //                            Text(item.name)
                                HStack {
                                    AsyncImage(url: .init(string: item.owner.awatartUrl))
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(3)
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                        Text(item.description)
                                    }
                                }
                                .padding(4)
                            }
                        }
                    }
                }
            }
            .searchable(
                text: .init(get: {
                    viewModel.searchText
                }, set: {
                    viewModel.searchText = $0
                }),
                prompt: "tetris+language.swift"
            )
            
            if viewModel.isLoading {
                ZStack(alignment: .center) {
                    ProgressView()
                }
                .background(
                    Color.white
                        .opacity(0.3)
                )
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(Color.red)
                    .padding(10)
            }
        }
    }
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
