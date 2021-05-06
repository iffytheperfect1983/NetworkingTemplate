//
//  ConnectionSettings.swift
//  NetworkingTemplate
//
//  Created by Phanit Pollavith on 5/5/21.
//

import Foundation
import Alamofire

struct ConnectionSettings { }

extension ConnectionSettings {
  static func sessionManager() -> Session {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    configuration.urlCache = nil
    
    let sessionManager = Session(configuration: configuration, startRequestsImmediately: false)
    return sessionManager
  }
}
