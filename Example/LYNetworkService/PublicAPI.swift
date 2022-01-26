//
//  PublicAPI.swift
//  LYNetworkService_Example
//
//  Created by dong on 2022/1/25.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import LYNetworkService

extension NetworkServiceTarget {
    var resultKey: String {
        return "result"
    }
    var statusKey: String {
        return "status";
    }
    var errorMessageKey: String {
        return "message";
    }
    var errorCodeKey: String {
        return "errorCode"
    }
    var bodyKey: String {
        return "data";
    }
}

enum PublicAPI {
    case testRequest(code:String);

}

extension PublicAPI:NetworkServiceTarget {
  
    var baseURL: String {
        switch self {
        case .testRequest(_):
            return BASE_URL;
        }
    }
    
    var path: String {
        switch self {
        case .testRequest(_):
            return "/dtww/index/selectUpp";
        }
    }
    func parameters() -> [String : Any]? {
        switch self {
        case .testRequest(let code):
            return ["cityCode":code];
        }
    }
    
    func method(path: String) -> HTTPMethod {
        switch self {
        case .testRequest(_):
            return .get
        }
    }
    
}
