//
//  ServiceModel.swift
//  Repositories
//

import Foundation

struct SearchRespositories {
    struct Response: Decodable {
        let incompleteResults: Bool
        let items: [Items]
        
        private enum CodingKeys: String, CodingKey {
            case incompleteResults = "incomplete_results"
            case items
        }
        
        struct Items: Decodable {
            let name: String
            let fullName: String
            let description: String?
            let htmlUrl: String
            
            private enum CodingKeys: String, CodingKey {
                case fullName = "full_name"
                case htmlUrl = "html_url"
                case name, description
            }
        }
    }
}

struct EmptyData: Codable { }
