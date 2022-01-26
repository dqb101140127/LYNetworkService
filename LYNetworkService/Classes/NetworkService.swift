//
//  NetworkService.swift
//  neverStop
//
//  Created by developer_m1 on 2022/1/20.
//  Copyright © 2022 dongqiangbin. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
import Alamofire




public protocol NetworkServiceTarget:BaseNetworkServiceTarget {
    var resultKey:String{get}
    var errorMessageKey:String{get}
    var errorCodeKey:String{get}
    var bodyKey:String{get}
}



public class NetworkService:BaseNetworkService {
    

    //MARK 返回指定的响应模型
   public class func requestDataModel<T:NetworkServiceTarget,M:HandyJSON>( _ target:T,
                                                                              model:M.Type,
                                                                             result:@escaping (LYResponseModel<M>)->()) {
       
       makeRequest(target, result: { (data) in
           let res = dataConvertToJson(data: data, fail: nil);
           let json = res.0;
           let responseModel = LYResponseModel<M>.deserialize(from: json?.dictionaryObject);
           responseModel?.data = data;
           responseModel?.result  = json?[target.resultKey].boolValue ?? false;
           responseModel?.errorCode = json?[target.errorCodeKey].stringValue;
           responseModel?.errorMessage = json?[target.errorMessageKey].stringValue;
           if let jsonData = json?[target.bodyKey] {
               if jsonData.object is [Any] {
                 let models =  jsonData.arrayObject?.compactMap({ dict in
                     model.deserialize(from: dict as? [String :Any]);
                 })
                   responseModel?.models = models;
               }else if jsonData.object is [String:Any]{
                   let t = model.deserialize(from: jsonData.dictionaryObject);
                   responseModel?.model = t;
               }else if jsonData.object is String {
                   responseModel?.model = jsonData.stringValue as? M
               }else if jsonData.object is NSNumber{
                   responseModel?.model = jsonData.numberValue as? M
               }else if jsonData.object is Bool {
                   responseModel?.model = jsonData.boolValue as? M
               }
           }
           result(responseModel ?? LYResponseModel<M>.makeErrorResponseModel(errorMessage: res.1, error: nil));
       }, fail: {  (message,error) in
           result(LYResponseModel<M>.makeErrorResponseModel(errorMessage: message,error: error));
       })
    }
    
    //MARK 返回自定义数据模型
   public class func requestCustomDataModel<T:BaseNetworkServiceTarget,M:HandyJSON>( _ target:T,
                                                                                    model:M.Type,
                                                                                   result:@escaping (Bool,String?,M?)->()) {
       makeRequest(target,result: { (data) in
           let res = dataConvertToJson(data: data, fail: nil);
           let json = res.0;
           let t = M.deserialize(from: json?.dictionaryObject);
           result(true,nil,t);
       }, fail: {  (message,error) in
           result(false,message,nil);
       })
    }

    class private func dataConvertToJson(data:Data,fail:FailureClosure?) -> (JSON?,String?) {
        do {
            let json = try JSON.init(data: data, options: .fragmentsAllowed);
            return (json,nil);
        }catch let error{
            LYLog(error)
            fail?("数据异常",nil)
            return (nil,"数据异常");
        }
    }

}
