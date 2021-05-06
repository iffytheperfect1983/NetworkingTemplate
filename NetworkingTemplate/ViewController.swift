//
//  ViewController.swift
//  NetworkingTemplate
//
//  Created by Phanit Pollavith on 5/5/21.
//

import UIKit
import Alamofire
import PromiseKit

class ViewController: UIViewController {

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var myLabel: UILabel!
  
  private lazy var session: Session = {
    return ConnectionSettings.sessionManager()
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }


  @IBAction func buttonPressed(_ sender: Any) {
    
    handleButtonPress1()
    
  }
  
  func handleButtonPressed() {
    guard let numberString = textField.text,
          let number = Int(numberString) else {
      return
    }
    let apiRouterStructure = APIRouterStructer(apiRouter: .todos(number: number))
    let todosPromise: Promise<Todo> = session.request(apiRouterStructure)
    
    firstly {
      todosPromise
    }
    .then { [weak self] todo -> Promise<Todo> in
      guard let self = self else { throw InternalError.unexpected }
      self.myLabel.text = "\(todo.id). " + todo.title
      return Promise<Todo>.value(todo)
    }
    .then { [weak self] todo -> Promise<Todo> in
      guard let self = self else { throw InternalError.unexpected }
      let nextID = todo.id + 1
      let apiRouterStructure = APIRouterStructer(apiRouter: .todos(number: nextID))
      let todosPromiseNext: Promise<Todo> = self.session.request(apiRouterStructure)
      return todosPromiseNext
    }
    .then{ [weak self] todoNext -> Promise<Todo> in
      guard let self = self else { throw InternalError.unexpected }
      self.myLabel.text = self.myLabel.text! + "\n" + "\(todoNext.id). " + todoNext.title
      
      let nextID = todoNext.id + 5
      let apiRouterStructure = APIRouterStructer(apiRouter: .todos(number: nextID))
      let todosPromiseNext: Promise<Todo> = self.session.request(apiRouterStructure)
      return todosPromiseNext
    }
    .then { [weak self] todoNext -> Promise<Void> in
      guard let self = self else { throw InternalError.unexpected }
      self.myLabel.text = self.myLabel.text! + "\n" + "\(todoNext.id). " + todoNext.title
      return Promise()
    }
    .catch { [weak self] error in
      guard let self = self else { return }
      print("there was an error")
      self.myLabel.text = "There was an error"
    }
    .finally {
      print("finally done")
    }
  }
}

extension ViewController {
  func handleButtonPress1() {
    guard let numberString = textField.text,
          let number = Int(numberString) else {
      return
    }
    let postModel = PostModel(title: "Hello Title", body: "This is body!", userID: 20)
    let apiRouterStructure = APIRouterStructer(apiRouter: .posts(postModel: postModel))
    let postPromise: Promise<Post> = session.request(apiRouterStructure)
    
    firstly {
      postPromise
    }
    .then { [weak self] post -> Promise<Post> in
      guard let self = self else { throw InternalError.unexpected }
      self.myLabel.text = "ID: \(post.id) - " + "UserID: \(post.userID)--" + post.body
      return Promise<Post>.value(post)
    }
    .then { [weak self] post -> Promise<Todo> in
      guard let self = self else { throw InternalError.unexpected }
      let apiRouterStructure = APIRouterStructer(apiRouter: .todos(number: number))
      let todosPromise: Promise<Todo> = self.session.request(apiRouterStructure)
      return todosPromise
    }
    .then { [weak self] todo -> Promise<Void> in
      guard let self = self else { throw InternalError.unexpected }
      self.myLabel.text = self.myLabel.text! + "\n" + "\(todo.id). " + todo.title
      return Promise()
    }
    .catch { [weak self] error in
      guard let self = self else { return }
      print("there was an error")
      self.myLabel.text = "There was an error"
    }
    .finally {
      print("finally done")
    }
  }
}

