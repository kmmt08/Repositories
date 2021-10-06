//
//  WebViewController.swift
//  Repositories
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    var viewModel: WebViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        viewModel.getTitle()
        viewModel.getUrl()
    }
    
    private func initialSetup() {
        viewModel.delegate = self
        navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
    }
}

// MARK: - WebViewModel Protocol

extension WebViewController: WebViewModelProtocol {
    func loadWebView(request: URLRequest) {
        webView.load(request)
    }
    
    func displayTitle(_ title: String) {
        navigationItem.title = title
    }
}
