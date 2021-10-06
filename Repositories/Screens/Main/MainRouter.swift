//
//  MainRouter.swift
//  Repositories
//

import UIKit

protocol MainRouterProtocol {
    func navigateToWebview(with url: String, name: String)
    func showPopupError(_ data: MainModel.PopupError)
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
    
    func showPopupError(_ data: MainModel.PopupError) {
        let alert: UIAlertController = .init(title: data.title,
                                             message: data.message,
                                             preferredStyle: .alert)
        alert.addAction(.init(title: data.buttonTitle, style: .default))
        viewController.present(alert, animated: true)
    }
}
