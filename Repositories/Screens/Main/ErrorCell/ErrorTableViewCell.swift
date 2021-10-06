//
//  ErrorTableViewCell.swift
//  Repositories
//

import UIKit

class ErrorTableViewCell: UITableViewCell {
    @IBOutlet private weak var errorLabel: UILabel!
    
    static let identifier: String = "errorCell"

    func setErrorMessage(_ text: String) {
        errorLabel.text = text
    }
    
}
