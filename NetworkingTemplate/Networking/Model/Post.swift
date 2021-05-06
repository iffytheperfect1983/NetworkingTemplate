//
//  Post.swift
//  NetworkingTemplate
//
//  Created by Phanit Pollavith on 5/5/21.
//

import Foundation

// MARK: - Post
struct Post: Codable {
  let userID, id: Int
  let title, body: String
  
  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case id, title, body
  }
}
