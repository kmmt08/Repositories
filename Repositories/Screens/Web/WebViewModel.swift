//
//  WebViewModel.swift
//  Repositories
//

import Foundation

protocol WebViewModelProtocol: AnyObject {
    func loadWebView(request: URLRequest)
    func displayTitle(_ title: String)
}

class WebViewModel {
    private let name: String
    private let repoUrl: String
    private let router: WebRouter
    weak var delegate: WebViewModelProtocol?
    
    init(name: String,
         url: String,
         router: WebRouter) {
        self.name = name
        self.repoUrl = url
        self.router = router
        self.router.delegate = self
    }
    
    func getTitle() {
        delegate?.displayTitle(name)
    }
    
    func getUrl() {
        guard let url = URL(string: repoUrl) else {
            return
        }
        let request = URLRequest(url: url)
        delegate?.loadWebView(request: request)
    }
    
    func loadWebviewFailed() {
        router.showPopupError(.init(title: "Error",
                                    message: "Failed to load the URL. Do you want to try loading again?",
                                    cancelButtonTitle: "No",
                                    okButtonTitle: "Yes"))
    }
}

// MARK: - WebRouter Protocol

extension WebViewModel: WebRouterProtocol {
    func alertOkButtonTapped() {
        getUrl()
    }
}
