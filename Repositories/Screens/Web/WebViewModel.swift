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
    weak var delegate: WebViewModelProtocol?
    
    init(name: String,
         url: String) {
        self.name = name
        self.repoUrl = url
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
}
