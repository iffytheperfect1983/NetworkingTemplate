//
//  SessionHelpers.swift
//  NetworkingTemplate
//
//  Created by Phanit Pollavith on 5/5/21.
//

import Foundation
import Alamofire
import PromiseKit

enum InternalError: LocalizedError {
  case unexpected
}

extension Session {
  func request<T: Codable>(_ urlRequestConvertible: APIRouterStructer) -> Promise<T> {
    return Promise<T> { seal in
      request(urlRequestConvertible).responseDecodable { (response: DataResponse<T, AFError>) in
        guard response.response != nil else {
          if let error = response.error {
            seal.reject(error)
          } else {
            seal.reject(InternalError.unexpected)
          }
          return
        }
        
        switch response.result {
        case let .success(value):
          seal.fulfill(value)
        case let .failure(error):
          seal.reject(error)
        }
      }
      .resume()
    }
  }
}
