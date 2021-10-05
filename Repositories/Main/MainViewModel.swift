//
//  MainViewModel.swift
//  Repositories
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    
}

class MainViewModel: MainViewModelProtocol {
    private let searchService: SearchServiceProtocol = SearchService()
    weak var delegate: MainViewModelProtocol?
    // Data
    private var nextPage: Int = 1
    private var hasNextPage: Bool = false
    
    func search(_ text: String) {
        searchService.getSearchRepositories(text, page: nextPage) { [weak self] result in
            switch result {
            case .success(let data):
                self?.nextPage += 1
                self?.hasNextPage = data.incompleteResults
            case .failure(let error):
                print(error)
            }
        }
    }
}
