//
//  ArticleModel.swift
//  Blog
//
//  Created by Bambang on 08/09/22.
//

import Foundation
import SwiftyJSON

struct ArticleModel {
    var id: Int = 0
    var title: String = ""
    var content: String = ""
    var published_at: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    
    init() {
    }
    
    init(newId: Int, newTitle: String, newContent: String) {
        self.id = newId
        self.title = newTitle
        self.content = newContent
    }
    
    init(dictionary: JSON) {
        id = dictionary["id"].intValue
        if(dictionary["title"].exists()) {
            title = dictionary["title"].stringValue
        }
        if(dictionary["content"].exists()) {
            content = dictionary["content"].stringValue
        }
        if(dictionary["published_at"].exists()) {
            published_at = dictionary["published_at"].stringValue
        }
        if(dictionary["created_at"].exists()) {
            created_at = dictionary["created_at"].stringValue
        }
        if(dictionary["updated_at"].exists()) {
            updated_at = dictionary["updated_at"].stringValue
        }
    }
}

