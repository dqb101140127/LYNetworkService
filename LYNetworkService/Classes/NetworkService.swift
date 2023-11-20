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

fileprivate func jsonDecoderErrorHandler(error:Error) {
    LYLog(error);
#if DEBUG
    fatalError(error.localizedDescription);
#else
#endif
 }

public class NetworkService:BaseNetworkService {
    public static let share:NetworkService = NetworkService();
    public lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder;
    }()
    
    //MARK 返回指定的响应模型
    public func requestDataModel<T:NetworkServiceTarget,M:HandyJSON>( _ target:T,
                                                                    parameters:[String:Any]? = nil,
                                                                         model:M.Type,
                                                                        result:@escaping (LYResponseModel<M>)->()) {
       makeRequest(target,parameters: parameters, result: { (data) in
           let res = NetworkService.dataConvertToJson(target:target,data: data, fail: nil);
           let json = res.0;
           let responseModel = LYResponseModel<M>.deserialize(from: json?.dictionaryObject);
           responseModel?.data = data;
           responseModel?.jsonData = json;
           responseModel?.result  = json?[target.resultKey].boolValue ?? false;
           responseModel?.status  = json?[target.statusKey].intValue ?? 0;
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
    
    public func requestDataAndConvertToModel<T:NetworkServiceTarget,M:Decodable>( _ target:T,
                                                                    parameters:[String:Any]? = nil,
                                                                         model:M.Type,
                                                                        result:@escaping (ResponseInfoModel<M>)->()) {
       makeRequest(target,parameters: parameters, result: { [weak self](data) in
           let res = NetworkService.dataConvertToJson(target:target,data: data, fail: nil);
           if (res.1 != nil) {
               let responseModel = ResponseInfoModel<M>.makeErrorResponseModel(errorMessage: res.1, error: nil);
               result(responseModel);
               return;
           }
           let json = res.0;
           let responseModel = ResponseInfoModel<M>();
           responseModel.data = data;
           responseModel.jsonData = json;
           responseModel.result  = json?[target.resultKey].boolValue ?? false;
           responseModel.status  = json?[target.statusKey].intValue ?? 0;
           responseModel.errorCode = json?[target.errorCodeKey].stringValue;
           responseModel.errorMessage = json?[target.errorMessageKey].stringValue;
           if let jsonData = json?[target.bodyKey] {
               if jsonData.object is [Any] {
                   var temp = [String:Any]();
                   temp.updateValue(jsonData.arrayObject ?? [], forKey: "models");
                   do {
                       let tempData = try JSONSerialization.data(withJSONObject: temp)
                       let convertModel = try self?.jsonDecoder.decode(ResponseArrayConvertModel<M>.self, from: tempData);
                       responseModel.models = convertModel?.models;
                   } catch let e {
                       jsonDecoderErrorHandler(error: e);
                   }
               }else if jsonData.object is [String:Any]{
                   do {
                       let tempData = try jsonData.rawData()
                       let convertModel = try self?.jsonDecoder.decode(M.self, from: tempData);
                       responseModel.model = convertModel;
                   } catch let e {
                       jsonDecoderErrorHandler(error: e);
                   }
               }else if jsonData.object is String {
                   responseModel.model = jsonData.stringValue as? M
               }else if jsonData.object is NSNumber{
                   responseModel.model = jsonData.numberValue as? M
               }else if jsonData.object is Bool {
                   responseModel.model = jsonData.boolValue as? M
               }
           }
           result(responseModel);
       }, fail: {  (message,error) in
           result(ResponseInfoModel<M>.makeErrorResponseModel(errorMessage: message,error: error));
       })
    }
    

    
    
    //MARK 返回自定义数据模型
   public func requestCustomDataModel<T:BaseNetworkServiceTarget,M:Decodable>( _ target:T,
                                                                             parameters:[String:Any]? = nil,
                                                                                  model:M.Type,
                                                                                 result:@escaping (Bool,String?,M?)->()) {
       makeRequest(target,parameters: parameters,result: { [weak self](data) in
           do {
               let json = try JSON.init(data: data, options: .fragmentsAllowed);
               if target.enableLog(path: target.path) {
                   LYLog("=请求路径===\(target.path)==数据返回=",json);
               }
               target.didReceiveData(path: target.path, error: nil, data: data, json: json);
               let model = try self?.jsonDecoder.decode(model, from: data);
               result(true, nil, model);
           }catch let error{
               LYLog(error)
               target.didReceiveData(path: target.path, error: LYError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)), data: data, json: nil);
               result(false,error.localizedDescription,nil);
           }
       }, fail: {  (message,error) in
           result(false,message,nil);
       })
    }
    
    public func requestJson<T:NetworkServiceTarget>( _ target:T,
                                                   parameters:[String:Any]? = nil,
                                                     _ result:@escaping (_ responseModel:ResponseModel)->()) {
        makeRequest(target,parameters: parameters,result: { (data) in
            let res = NetworkService.dataConvertToJson(target:target,data: data, fail: nil);
            let json = res.0;
            if res.1 != nil {
                let responseModel = ResponseModel.makeResponseModel(errorMessage: res.1, error: nil);
                result(responseModel);
            }else{
                let responseModel = ResponseModel();
                responseModel.result  = json?[target.resultKey].boolValue ?? false;
                responseModel.status  = json?[target.statusKey].intValue ?? 0;
                responseModel.errorCode = json?[target.errorCodeKey].stringValue;
                responseModel.errorMessage = json?[target.errorMessageKey].stringValue;
                responseModel.data = data;
                responseModel.jsonData = json;
                responseModel.body = json?[target.bodyKey];
                result(responseModel);
            }
        }, fail: {  (message,error) in
           let responseModel = ResponseModel.makeResponseModel(errorMessage: message, error: error);
            result(responseModel);
        })
     }

    class func dataConvertToJson<T:BaseNetworkServiceTarget>(target:T,data:Data,fail:FailureClosure?) -> (JSON?,String?) {
        do {
            let json = try JSON.init(data: data, options: .fragmentsAllowed);
            if target.enableLog(path: target.path) {
                LYLog("=请求路径===\(target.path)==数据返回=",json);
            }
            target.didReceiveData(path: target.path, error: nil, data: data, json: json);
            return (json,nil);
        }catch let error{
            LYLog(error)
            target.didReceiveData(path: target.path, error: LYError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)), data: data, json: nil);
            fail?("数据异常",nil)
            return (nil,"数据异常");
        }
    }

}
