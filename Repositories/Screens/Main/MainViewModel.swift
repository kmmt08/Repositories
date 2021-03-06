//
//  MainViewModel.swift
//  Repositories
//

import Foundation

protocol MainViewModelProtocol: AnyObject {
    func reloadTableView(scrollToTop: Bool)
    func showLazyLoader()
    func hideLazyLoader()
    func showFullLoader()
    func hideFullLoader()
}

class MainViewModel {
    private let searchService: SearchServiceProtocol
    private let router: MainRouter
    weak var delegate: MainViewModelProtocol?
    
    private var currentSearchText: String = ""
    private var nextPage: Int = 1
    private var hasNextPage: Bool = false
    private var isLoading: Bool = false
    private var items: [SearchRespositories.Response.Items] = []
    private var listCellData: [MainModel.CellDisplay] = []
    private var totalItem: Int = 0
    private(set) var tableCellData: MainModel.TableData = .blank
    
    init(searchService: SearchServiceProtocol = SearchService(),
         router: MainRouter) {
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
                                                 description: item.description,
                                                 starCount: strongSelf.formatCount(item.starGazersCount)))
                    }
                    strongSelf.listCellData.append(contentsOf: newCellData)
                    strongSelf.tableCellData = .success(item: strongSelf.listCellData)
                    strongSelf.items.append(contentsOf: data.items)
                    strongSelf.delegate?.reloadTableView(scrollToTop: firstSearch)
                } else if firstSearch {
                    strongSelf.tableCellData = .error(message: "Search not found. Please try other keyword.")
                    strongSelf.delegate?.reloadTableView(scrollToTop: firstSearch)
                }
            case .failure(let error):
                if firstSearch {
                    strongSelf.tableCellData = .error(message: error.description)
                    strongSelf.delegate?.reloadTableView(scrollToTop: firstSearch)
                } else {
                    strongSelf.router.showPopupError(.init(title: "Error",
                                                           message: error.description,
                                                           buttonTitle: "Ok"))
                }
            }
        }
    }
    
    func didScrollAtEnd() {
        if !isLoading,
           listCellData.count < totalItem,
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
    
    private func isFirstSearch() -> Bool {
        return nextPage == 1
    }
    
    private func formatCount(_ count: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: count)) ?? "\(count)"
    }
}
