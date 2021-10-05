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
            let fullName: String
            let description: String?
            let url: String
            
            private enum CodingKeys: String, CodingKey {
                case fullName = "full_name"
                case description, url
            }
        }
    }
}

struct EmptyData: Codable { }
