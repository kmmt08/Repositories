//
//  ListTableViewCell.swift
//  Repositories
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    static let identifier: String = "listCell"

    func displayData(_ data: MainModel.CellDisplay) {
        titleLabel.text = data.name
        descriptionLabel.text = data.description
    }
    
}
