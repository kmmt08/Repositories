//
//  DefaultService.swift
//  Repositories
//

import Foundation

class DefaultService {
    private let session: URLSession = URLSession.shared
    
    func buildRequest<T: Encodable>(url: String,
                                    httpMethod: HttpMethod,
                                    parameters: T) -> URLRequest {
        guard let percentEscapedUrlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let urlString = URL(string: percentEscapedUrlString) else {
            preconditionFailure("Invalid URL string")
        }
        
        var urlRequest = URLRequest(url: urlString)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.timeoutInterval = 30
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.allHTTPHeaderFields = ["Accept": "application/vnd.github.v3+json"]
        
        // Encoding
        do {
            let jsonBody = try JSONEncoder().encode(parameters)
            switch httpMethod {
            case .get:
                break
            case .post, .put:
                urlRequest.httpBody = jsonBody
            }
        } catch let error {
            print(error)
        }
        
        return urlRequest
    }
    
    func request<T: Decodable>(_ urlRequest: URLRequest, completion: @escaping (Result<T, ErrorResponse>) -> Void) {
        let task = session.dataTask(with: urlRequest) { data, urlResponse, error in
            guard error == nil else {
                completion(Result.failure(ErrorResponse(code: nil,
                                                        description: error?.localizedDescription ?? "Client Error")))
                return
            }
            
            guard let responseData = data else {
                completion(Result.failure(ErrorResponse(code: nil,
                                                        description: error?.localizedDescription ?? "No Data Error")))
                return
            }
            
            guard let response = urlResponse as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                let urlResponse: HTTPURLResponse? = urlResponse as? HTTPURLResponse
                var errorMessage: String = urlResponse?.description ?? "Server Error"
                if let decoded = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: String],
                   let message = decoded["message"] {
                    errorMessage = message
                }
                completion(Result.failure(ErrorResponse(code: urlResponse?.statusCode,
                                                        description: errorMessage)))
                return
            }
            
            if responseData.isEmpty {
                completion(Result.failure(ErrorResponse(code: nil,
                                                        description: error?.localizedDescription ?? "No Data Error")))
            } else {
                do {
                    // TODO: Remove
                    let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                    print(json)
                    
                    let decodedData = try JSONDecoder().decode(T.self, from: responseData)
                    completion(Result.success(decodedData))
                } catch let error {
                    completion(Result.failure(ErrorResponse(code: nil,
                                                            description: error.localizedDescription)))
                }
            }
        }
        task.resume()
    }
}

// MARK: - Networking Models

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum ResponseType {
    case informational
    case success
    case redirection
    case clientError
    case serverError
    case undefined
}

struct ErrorResponse: Error {
    var code: Int?
    var description: String
    
    var title: String {
        switch responseType {
        case .informational:
            return "Informational Error"
        case .redirection:
            return "Redirection Error"
        case .clientError:
            return "Client Error"
        case .serverError:
            return "Server Error"
        default:
            return "Error"
        }
    }
    
    var responseType: ResponseType {
        switch code ?? 0 {
        case 100..<200:
            return .informational
        case 200..<300:
            return .success
        case 300..<400:
            return .redirection
        case 400..<500:
            return .clientError
        case 500..<600:
            return .serverError
        default:
            return .undefined
        }
    }
    
}
