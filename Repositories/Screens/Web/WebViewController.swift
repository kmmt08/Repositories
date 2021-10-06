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
        webView.navigationDelegate = self
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

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Loader.shared.show()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Loader.shared.hide()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Loader.shared.hide()
        viewModel.loadWebviewFailed()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Loader.shared.hide()
        viewModel.loadWebviewFailed()
    }
}
