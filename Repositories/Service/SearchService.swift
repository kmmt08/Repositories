//
//  SearchService.swift
//  Repositories
//

import Foundation

protocol SearchServiceProtocol {
    func getSearchRepositories(_ searchText: String, page: Int, completion: @escaping (Result<SearchRespositories.Response, ErrorResponse>) -> Void)
}

class SearchService: DefaultService, SearchServiceProtocol {
    private let baseURL: String = "https://api.github.com"
    
    enum APISearch: String {
        case respositories = "/search/repositories?q=%@&page=%ld"
    }
    
    func getSearchRepositories(_ searchText: String, page: Int, completion: @escaping (Result<SearchRespositories.Response, ErrorResponse>) -> Void) {
        let url = baseURL + String(format: APISearch.respositories.rawValue, searchText, page)
        let urlRequest = buildRequest(url: url,
                                      httpMethod: .get,
                                      parameters: EmptyData())
        request(urlRequest, completion: completion)
    }
}
