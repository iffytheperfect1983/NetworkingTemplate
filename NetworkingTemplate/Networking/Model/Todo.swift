//
//  Todo.swift
//  NetworkingTemplate
//
//  Created by Phanit Pollavith on 5/5/21.
//

import Foundation

// MARK: - Todo
struct Todo: Codable {
  let userID, id: Int
  let title: String
  let completed: Bool
  
  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case id, title, completed
  }
}
