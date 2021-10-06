//
//  ServiceModel.swift
//  Repositories
//

import Foundation

struct SearchRespositories {
    struct Response: Decodable {
        let totalCount: Int
        let items: [Items]
        
        private enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case items
        }
        
        struct Items: Decodable {
            let name: String
            let fullName: String
            let description: String?
            let htmlUrl: String
            let owner: Owner
            
            private enum CodingKeys: String, CodingKey {
                case fullName = "full_name"
                case htmlUrl = "html_url"
                case name, description, owner
            }
        }
        
        struct Owner: Decodable {
            let avatarUrl: String
            
            private enum CodingKeys: String, CodingKey {
                case avatarUrl = "avatar_url"
            }
        }
    }
}

struct EmptyData: Codable { }
