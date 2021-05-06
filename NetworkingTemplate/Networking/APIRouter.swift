//
//  APIRouter.swift
//  NetworkingTemplate
//
//  Created by Phanit Pollavith on 5/5/21.
//

import Foundation
import Alamofire

struct APIRouterStructer: URLRequestConvertible {
  
  let apiRouter: APIRouter
  
  func headers() -> HTTPHeaders {
    var headersDictionary = [
      "Accept": "application/json",
      "Origin": "some origin"
    ]
    if let additionalHeaders = apiRouter.additionalHeaders {
      let additionalHeadersDictionary = additionalHeaders.dictionary
      additionalHeadersDictionary.forEach { (key, value) in
        headersDictionary[key] = value
      }
    }
    return HTTPHeaders(headersDictionary)
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try apiRouter.baseURL.asURL()
    var urlRequest = URLRequest(url: url.appendingPathComponent(apiRouter.path))
    urlRequest.httpMethod = apiRouter.method.rawValue
    urlRequest.timeoutInterval = apiRouter.timeout
    urlRequest.headers = headers()
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    if let body = apiRouter.body {
      do {
        let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        urlRequest.httpBody = data
      } catch {
        print("Fail to generate JSON data")
      }
    }
    if let parameters = apiRouter.paramters {
      urlRequest = try apiRouter.encoding.encode(urlRequest, with: parameters)
    }
    print("urlRequest: \(urlRequest)")
    return urlRequest
  }
}

// MARK: - PostModel
struct PostModel {
  let title: String
  let body: String
  let userID: Int
}

extension PostModel {
  func bodyForAPIRequest() -> [String: Any] {
    var bodyForAPI: [String: Any] = [:]
    bodyForAPI["userId"] = userID
    bodyForAPI["title"] = title
    bodyForAPI["body"] = body
    return bodyForAPI
  }
}

enum APIRouter {
  
  // MARK: - Endpoints
  case todos(number: Int)
  case posts(postModel: PostModel)
  
  var baseURL: String {
    switch self {
    case .todos, .posts: return "https://jsonplaceholder.typicode.com"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .todos: return .get
    case .posts: return .post
    }
  }
  
  var path: String {
    switch self {
    case let .todos(number):
      return "todos/\(number)"
    case .posts:
      return "posts"
    }
  }
  
  var encoding: ParameterEncoding {
    switch method {
    default: return URLEncoding.default
    }
  }
  
  var paramters: Parameters? {
    switch self {
    case .todos, .posts: return nil
    }
  }
  
  var body: Parameters? {
    switch self {
    case .todos: return nil
    case let .posts(postModel):
      return postModel.bodyForAPIRequest()
    }
  }
  
  var additionalHeaders: HTTPHeaders? {
    switch self {
    case .todos: return HTTPHeaders(["Token": "Some Token"])
    case .posts: return nil
    }
  }
  
  var timeout: TimeInterval {
    switch self {
    default: return 20
    }
  }
}
