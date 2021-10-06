//
//  ListTableViewCell.swift
//  Repositories
//

import UIKit
import Kingfisher

class ListTableViewCell: UITableViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var iconView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    
    static let identifier: String = "listCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.roundCorners(.allCorners, radius: 16)
        containerView.applyDefaultShadow()
        iconView.roundCorners(.allCorners, radius: 8)
    }

    func displayData(_ data: MainModel.CellDisplay) {
        iconView.kf.setImage(with: URL(string: data.ownerAvatarUrl),
                             placeholder: UIImage(named: "default_icon"))
        titleLabel.text = data.name
        descriptionLabel.text = data.description
        countLabel.text = data.starCount
    }
    
}
