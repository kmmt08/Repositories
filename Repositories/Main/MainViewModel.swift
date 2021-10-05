//
//  MainViewModel.swift
//  Repositories
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    
}

class MainViewModel: MainViewModelProtocol {
    private let searchService: SearchServiceProtocol
    weak var delegate: MainViewModelProtocol?
    var reloadTableView: (() -> Void)?
    
    private var currentSearchText: String = ""
    private var nextPage: Int = 1
    private var hasNextPage: Bool = false
    private var items: [SearchRespositories.Response.Items] = []
    
    private(set) var listCellData: [MainModel.CellDisplay] = [] {
        didSet {
            reloadTableView?()
        }
    }
    
    init(searchService: SearchServiceProtocol = SearchService()) {
        self.searchService = searchService
    }
    
    func search(_ text: String) {
        searchService.getSearchRepositories(text, page: nextPage) { [weak self] result in
            switch result {
            case .success(let data):
                self?.nextPage += 1
                self?.hasNextPage = data.incompleteResults
                var newCellData: [MainModel.CellDisplay] = []
                for item in data.items {
                    newCellData.append(.init(name: item.fullName,
                                             description: item.description))
                }
                self?.listCellData.append(contentsOf: newCellData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCellData(at row: Int) -> MainModel.CellDisplay {
        return listCellData[row]
    }
}
