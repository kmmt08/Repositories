//
//  MainViewModel.swift
//  Repositories
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    func reloadTableView()
    func showLazyLoader()
    func hideLazyLoader()
    func showFullLoader()
    func hideFullLoader()
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
    private var listCellData: [MainModel.CellDisplay] = []
    
    private var totalItem: Int = 0 {
        didSet {
            checkForNextPage()
        }
    }
    
    private(set) var tableCellData: MainModel.TableData = .blank {
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
        let firstSearch: Bool = isFirstSearch()
        if firstSearch {
            delegate?.showFullLoader()
        }
        currentSearchText = text
        searchService.getSearchRepositories(text, page: nextPage) { [weak self] result in
            guard let strongSelf = self else { return }
            if firstSearch {
                strongSelf.delegate?.hideFullLoader()
            } else {
                strongSelf.delegate?.hideLazyLoader()
                strongSelf.isLoading = false
            }
            switch result {
            case .success(let data):
                if data.items.count > 0 {
                    strongSelf.nextPage += 1
                    strongSelf.totalItem = data.totalCount
                    var newCellData: [MainModel.CellDisplay] = []
                    for item in data.items {
                        newCellData.append(.init(ownerAvatarUrl: item.owner.avatarUrl,
                                                 name: item.fullName,
                                                 description: item.description))
                    }
                    strongSelf.listCellData.append(contentsOf: newCellData)
                    strongSelf.tableCellData = .success(item: strongSelf.listCellData)
                    strongSelf.items.append(contentsOf: data.items)
                } else if firstSearch {
                    strongSelf.tableCellData = .error(message: "Search not found. Please try another keyword.")
                }
            case .failure:
                if firstSearch {
                    strongSelf.tableCellData = .error(message: "Something went wrong. Please try again.")
                } else {
                    strongSelf.router.showPopupError(.init(title: "Error",
                                                           message: "Unable to fetch data. Please try again later.",
                                                           buttonTitle: "Ok"))
                }
            }
        }
    }
    
    func getTableCellData() -> MainModel.TableData {
        return tableCellData
    }
    
    func willDisplayCell(at row: Int) {
        if row == listCellData.count - 1,
           !isLoading,
           hasNextPage,
           case .success = tableCellData {
            delegate?.showLazyLoader()
            isLoading = true
            search(currentSearchText, forNextPage: true)
        }
    }
    
    func didSelectCell(at row: Int) {
        if case .success = tableCellData {
            let item = items[row]
            router.navigateToWebview(with: item.htmlUrl,
                                     name: item.name)
        }
    }
    
    private func checkForNextPage() {
        let pages = Double(totalItem) / 30
        let maxPages = pages.rounded(.up)
        hasNextPage = Double(nextPage) <= maxPages
    }
    
    private func isFirstSearch() -> Bool {
        return nextPage == 1
    }
}
