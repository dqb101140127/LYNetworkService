//
//  PublicAPI.swift
//  LYNetworkService_Example
//
//  Created by dong on 2022/1/25.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import LYNetworkService
import SwiftyJSON

extension NetworkServiceTarget {
    var resultKey: String {
        return "status"
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
    
    public func headers(path: String) -> [String : String]? {
        return nil;
    }
    
    public func cookies(url: URL) -> [HTTPCookie]? {
        return nil;
    }
    public func didReceiveData(path: String, error: LYError?, data: Data, json: JSON?) {
        
    }
}

enum PublicAPI {
    case testRequest(code:String);

}

extension PublicAPI:NetworkServiceTarget {

    func didReceiveData(error: LYError?, data: Data, json: JSON?) {
        print("接收到数据-----\(json ?? "")");
    }
  
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
    
    func enableLog(path: String) -> Bool {
        return true;
    }
    
}
