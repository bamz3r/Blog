//
//  Config.swift
//  Blog
//
//  Created by Bambang on 08/09/22.
//

import Foundation
import Alamofire

class Config {
    public static func getApiHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "app-client": "iOS"
        ]
        return headers
    }
}
