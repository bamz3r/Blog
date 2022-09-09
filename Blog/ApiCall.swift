//
//  Api.swift
//  Blog
//
//  Created by Bambang on 08/09/22.
//

import Alamofire
import SwiftyJSON

struct ApiCall {
    
    static func getArticles(page: Int, completion: @escaping ([ArticleModel]?) -> Void, onerror: @escaping (String?) -> Void) {
        var results: [ArticleModel] = []
        let parameters: Parameters = [:]
        print("getArticles")
        
        Alamofire.request("https://limitless-forest-49003.herokuapp.com/posts",
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.httpBody, headers: Config.getApiHeaders())
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        // No data returned
                        print("empty result")
                        onerror("Empty Result")
                        return
                    }
                    
                    let json = JSON(data)
//                    let lists = json["lists"]
                    print(json)
                    
                    for (_, subJson) in json {
                        let item: ArticleModel = ArticleModel(dictionary: subJson)
                        print(subJson)
                        results.append(item)
                    }
                    completion(results)
                case .failure(let error):
                    print(error)
                    onerror(error.localizedDescription)
                }
        }
    }
    
    static func getArticleDetail(id: Int, completion: @escaping (ArticleModel?) -> Void, onerror: @escaping (String?) -> Void) {
        var result: ArticleModel = ArticleModel.init()
        let parameters: Parameters = [:]
        
        Alamofire.request("https://limitless-forest-49003.herokuapp.com/posts/\(id)",
                          method: .get,
                          parameters: parameters,
                          encoding: URLEncoding.httpBody, headers: Config.getApiHeaders())
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        // No data returned
                        print("empty result")
                        onerror("Empty Result")
                        return
                    }
                    
                    let json = JSON(data)
                    let item: ArticleModel = ArticleModel(dictionary: json)
//                        print(subJson)
                    result = item
                    completion(result)
                case .failure(let error):
                    print(error)
                    onerror(error.localizedDescription)
                }
        }
    }
    
    static func createArticle(title: String, content: String, completion: @escaping (ArticleModel?) -> Void, onerror: @escaping (String?) -> Void) {
        var result: ArticleModel = ArticleModel.init()
        let parameters: Parameters = [
            "title": title,
            "content": content
        ]
        
        Alamofire.request("https://limitless-forest-49003.herokuapp.com/posts",
                          method: .post,
                          parameters: parameters,
                          encoding: URLEncoding.httpBody, headers: Config.getApiHeaders())
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        // No data returned
                        print("empty result")
                        onerror("Empty Result")
                        return
                    }
                    
                    let json = JSON(data)
                    let item: ArticleModel = ArticleModel(dictionary: json)
//                        print(subJson)
                    result = item
                    completion(result)
                case .failure(let error):
                    print(error)
                    onerror(error.localizedDescription)
                }
        }
    }
    
    static func updateArticle(id: Int, title: String, content: String, completion: @escaping (ArticleModel?) -> Void, onerror: @escaping (String?) -> Void) {
        var result: ArticleModel = ArticleModel.init()
        let parameters: Parameters = [
            "title": title,
            "content": content
        ]
        
        Alamofire.request("https://limitless-forest-49003.herokuapp.com/posts/\(id)",
                          method: .put,
                          parameters: parameters,
                          encoding: URLEncoding.httpBody, headers: Config.getApiHeaders())
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        // No data returned
                        print("empty result")
                        onerror("Empty Result")
                        return
                    }
                    
                    let json = JSON(data)
                    let item: ArticleModel = ArticleModel(dictionary: json)
//                        print(subJson)
                    result = item
                    completion(result)
                case .failure(let error):
                    print(error)
                    onerror(error.localizedDescription)
                }
        }
    }
    
    static func deleteArticle(id: Int, title: String, content: String, completion: @escaping (ArticleModel?) -> Void, onerror: @escaping (String?) -> Void) {
        var result: ArticleModel = ArticleModel.init()
        let parameters: Parameters = [
            "title": title,
            "content": content
        ]
        
        Alamofire.request("https://limitless-forest-49003.herokuapp.com/posts/\(id)",
                          method: .delete,
                          parameters: parameters,
                          encoding: URLEncoding.httpBody, headers: Config.getApiHeaders())
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        // No data returned
                        print("empty result")
                        onerror("Empty Result")
                        return
                    }
                    
                    let json = JSON(data)
                    let item: ArticleModel = ArticleModel(dictionary: json)
//                        print(subJson)
                    result = item
                    completion(result)
                case .failure(let error):
                    print(error)
                    onerror(error.localizedDescription)
                }
        }
    }
   
}
