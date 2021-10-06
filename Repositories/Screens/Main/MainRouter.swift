//
//  MainRouter.swift
//  Repositories
//

import UIKit

class MainRouter {
    private weak var viewController: MainViewController!
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
    
    func navigateToWebview(with url: String, name: String) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Web",
                                                    bundle: nil)
        if let webViewController = storyboard.instantiateInitialViewController() as? WebViewController {
            webViewController.viewModel = WebViewModel(name: name,
                                                       url: url,
                                                       router: .init(viewController: webViewController))
            viewController.navigationController?.pushViewController(webViewController, animated: true)
        }
    }
    
    func showPopupError(_ data: MainModel.PopupError) {
        DispatchQueue.main.async {
            let alert: UIAlertController = .init(title: data.title,
                                                 message: data.message,
                                                 preferredStyle: .alert)
            alert.addAction(.init(title: data.buttonTitle, style: .default))
            self.viewController.present(alert, animated: true)
        }
    }
}
