//
//  MainModel.swift
//  Repositories
//

import Foundation
import UIKit

struct MainModel {
    struct CellDisplay {
        let ownerAvatarUrl: String
        let name: String
        let description: String?
        let starCount: String
    }
    
    struct PopupError {
        let title: String
        let message: String
        let buttonTitle: String
    }
    
    enum TableData {
        case success(item: [CellDisplay])
        case error(message: String)
        case blank
    }
}
