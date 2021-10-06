//
//  MainModel.swift
//  Repositories
//

import Foundation
import UIKit

struct MainModel {
    struct CellDisplay {
        let name: String
        let description: String?
    }
    
    enum TableData {
        case success(item: [CellDisplay])
        case error(message: String)
        case blank
    }
}
