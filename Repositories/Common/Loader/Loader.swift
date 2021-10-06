//
//  Loader.swift
//  Repositories
//

import UIKit

class Loader {
    
    static let shared = Loader()
    
    private var isLoading: Bool = false
    
    private lazy var loaderView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = view.center
        activityIndicator.style = .large
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        return view
    }()
    
    func show() {
        guard !isLoading,
            let superView = (UIApplication.shared.windows.filter { $0.isKeyWindow }).first else {
            return
        }
        isLoading = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            superView.addSubview(self.loaderView)
        }
    }
    
    func hide() {
        guard isLoading else { return }
        isLoading = false
        DispatchQueue.main.async { [weak self] in
            self?.loaderView.removeFromSuperview()
        }
    }
    
}
