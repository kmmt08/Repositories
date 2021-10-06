//
//  MainRouter.swift
//  Repositories
//

import UIKit

protocol MainRouterProtocol {
    func navigateToWebview(with url: String, name: String)
}

class MainRouter: MainRouterProtocol {
    private weak var viewController: MainViewController!
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
    
    func navigateToWebview(with url: String, name: String) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Web",
                                                    bundle: nil)
        if let webViewController = storyboard.instantiateInitialViewController() as? WebViewController {
            webViewController.viewModel = WebViewModel(name: name,
                                                       url: url)
            viewController.navigationController?.pushViewController(webViewController, animated: true)
        }
    }
}
