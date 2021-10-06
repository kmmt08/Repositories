//
//  WebRouter.swift
//  Repositories
//

import Foundation
import UIKit

protocol WebRouterProtocol: AnyObject {
    func alertOkButtonTapped()
}

class WebRouter {
    private weak var viewController: WebViewController!
    weak var delegate: WebRouterProtocol?
    
    init(viewController: WebViewController) {
        self.viewController = viewController
    }
    
    func showPopupError(_ data: WebModel.PopupError) {
        let alert: UIAlertController = .init(title: data.title,
                                             message: data.message,
                                             preferredStyle: .alert)
        let cancelAction: UIAlertAction = .init(title: data.cancelButtonTitle,
                                                style: .cancel) { [weak self] _ in
            self?.viewController.navigationController?.popViewController(animated: true)
        }
        let okAction: UIAlertAction = .init(title: data.okButtonTitle,
                                            style: .default) { [weak self] _ in
            self?.delegate?.alertOkButtonTapped()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true)
    }
}
