//
//  UINavigation+Extension.swift
//  Repositories
//

import UIKit

extension UINavigationController {
    func setToDefault() {
        navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.9725490196, blue: 0.8862745098, alpha: 1)
        navigationBar.backgroundColor = #colorLiteral(red: 1, green: 0.9725490196, blue: 0.8862745098, alpha: 1)
        navigationBar.tintColor = .black
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}
