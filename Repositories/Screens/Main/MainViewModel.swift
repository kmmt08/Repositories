//
//  MainViewModel.swift
//  Repositories
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    func reloadTableView()
    func showLazyLoader()
    func hideLazyLoader()
}

class MainViewModel {
    private let searchService: SearchServiceProtocol
    private let router: MainRouterProtocol
    weak var delegate: MainViewModelProtocol?
    
    private var currentSearchText: String = ""
    private var nextPage: Int = 1
    private var hasNextPage: Bool = false
    private var isLoading: Bool = false
    private var items: [SearchRespositories.Response.Items] = []
    
    private var totalItem: Int = 0 {
        didSet {
            checkForNextPage()
        }
    }
    
    private(set) var listCellData: [MainModel.CellDisplay] = [] {
        didSet {
            delegate?.reloadTableView()
        }
    }
    
    init(searchService: SearchServiceProtocol = SearchService(),
         router: MainRouterProtocol) {
        self.searchService = searchService
        self.router = router
    }
    
    func search(_ text: String, forNextPage: Bool = false) {
        if text != currentSearchText || (!forNextPage && text == currentSearchText) {
            nextPage = 1
            totalItem = 0
            items = []
            listCellData = []
        }
        currentSearchText = text
        searchService.getSearchRepositories(text, page: nextPage) { [weak self] result in
            self?.delegate?.hideLazyLoader()
            self?.isLoading = false
            switch result {
            case .success(let data):
                self?.nextPage += 1
                self?.totalItem = data.totalCount
                var newCellData: [MainModel.CellDisplay] = []
                for item in data.items {
                    newCellData.append(.init(name: item.fullName,
                                             description: item.description))
                }
                self?.listCellData.append(contentsOf: newCellData)
                self?.items.append(contentsOf: data.items)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCellData(at row: Int) -> MainModel.CellDisplay {
        return listCellData[row]
    }
    
    func willDisplayCell(at row: Int) {
        if row == listCellData.count - 1,
           !isLoading,
           hasNextPage {
            delegate?.showLazyLoader()
            isLoading = true
            search(currentSearchText, forNextPage: true)
        }
    }
    
    func didSelectCell(at row: Int) {
        let item = items[row]
        router.navigateToWebview(with: item.htmlUrl,
                                 name: item.name)
    }
    
    private func checkForNextPage() {
        let pages = Double(totalItem) / 30
        let maxPages = pages.rounded(.up)
        hasNextPage = Double(nextPage) <= maxPages
    }
}