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
    var errorMessageKey: String {
        return "errorMessage";
    }
    var errorCodeKey: String {
        return "errorCode"
    }
    var bodyKey: String {
        return "bodyKey";
    }
}

enum PublicAPI {
    case testRequest(id:String);

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
            return "";
        }
    }
    func parameters() -> [String : Any]? {
        switch self {
        case .testRequest(let id):
            return ["id":id];
        }
    }
    
    func method(path: String) -> HTTPMethod {
        switch self {
        case .testRequest(_):
            return .get
        }
    }
    
}
