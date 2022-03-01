//
//  BaseNetworkService.swift
//  neverStop
//
//  Created by developer_m1 on 2022/1/20.
//  Copyright © 2022 dongqiangbin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Foundation

public typealias ErrorMessage = String?
public typealias LYError = Alamofire.AFError;
public typealias ParameterEncoding = Alamofire.ParameterEncoding;
public typealias HTTPMethod = Alamofire.HTTPMethod;
public typealias FailureClosure = (ErrorMessage,LYError?)->();
public typealias SuccessClosure = (Data) -> ();
public enum LYNetworkStatus : Int {
    case notReachable = 0
    case wifi = 1
    case cellular = 2
    case unknown = 3
}

public protocol BaseNetworkServiceTarget {
    var baseURL:String {get}
    var path : String {get}
//    var parameters:[String:Any]? {get}
    var isJsonEncoding:Bool {get}
    func parameters() -> [String:Any]?;
    func parameterEncoding(path:String) -> ParameterEncoding;
    func allowDuplicateRequest(path:String) -> Bool;
    func enableLog(path:String) -> Bool;
    func method(path:String) -> HTTPMethod;
    func headers(path:String) -> [String:String]?;
    func cookies(url:URL) -> [HTTPCookie]?;
    func didReceiveData(error:LYError?,data:Data);
}
public extension BaseNetworkServiceTarget {
    func parameters() -> [String:Any]? {
        return nil
    }
    var isJsonEncoding:Bool {
        return true;
    }
    func allowDuplicateRequest(path:String) -> Bool {
        return false;
    }
    func enableLog(path:String) -> Bool {
        return true;
    }
    func method(path:String) -> HTTPMethod {
        return .post;
    }
    func headers(path:String) -> [String:String]?{
        return nil;
    }
    func didReceiveData(error:LYError?,data:Data) {
        LYLog("didReceiveData-方法未实现")
    }
    func cookies(url:URL) -> [HTTPCookie]? {
        return nil;
    }
    func parameterEncoding(path:String) -> ParameterEncoding {
        let md = method(path: path);
        if md == .get {
            return URLEncoding.default;
        }
        return isJsonEncoding ? JSONEncoding.default:URLEncoding.httpBody;
    }
}


public class BaseNetworkService: NSObject {
    private static var dataRequests = [String:DataRequest]();
    private static var userHeaders = [String:String]();
    private static let  sessionManager : Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 40
        configuration.urlCache = nil;
        configuration.headers = NetworkService.makeHttpHeaders();
        let manager = Alamofire.Session.init(configuration: configuration, startRequestsImmediately: true);
        return manager
    }()

    public class func createCookie(name:String,value:String,domain:String) -> HTTPCookie? {
        var propertys = [HTTPCookiePropertyKey :Any]();
        propertys[.name] = name;
        propertys[.value] = value;
        propertys[.domain] = domain;
        propertys[.path] = "/";
        let cookie = HTTPCookie(properties: propertys);
        return cookie;
    }
    
  
    public class func makeRequest<T:BaseNetworkServiceTarget>(_ target:T,
                                                                result:@escaping SuccessClosure,
                                                                  fail:@escaping FailureClosure) {
        let path = target.path;
        let urlString = target.baseURL + path;
        guard let url : URL = URL.init(string: urlString) else {return}
        let allowDuplicateRequest = target.allowDuplicateRequest(path: path);
        let customHeader = target.headers(path: path)
        let cookies = target.cookies(url: url)
        let enableLog = target.enableLog(path: path);
        let method = target.method(path: path);
        let encoding = target.parameterEncoding(path: path);
        let parameters = target.parameters();
        request(urlString: urlString, parameters: parameters, method: method, header: customHeader, encoding: encoding, cookies: cookies, enableLog: enableLog, allowDuplicateRequest: allowDuplicateRequest, result: result, fail: fail);
    }

    public class func request(urlString:String,
                             parameters:[String:Any]?,
                                 method:HTTPMethod = .post,
                                 header:[String:String]? = nil,
                               encoding:ParameterEncoding? = nil,
                                cookies:[HTTPCookie]? = nil,
                           jsonEncoding:Bool = true,
                              enableLog:Bool = true,
                  allowDuplicateRequest:Bool = false,
                                 result:@escaping SuccessClosure,
                                   fail:@escaping FailureClosure) {
        guard let url : URL = URL.init(string: urlString) else {return};
        if let _ = BaseNetworkService.dataRequests[urlString], !allowDuplicateRequest {
            fail("努力加载中...",nil);
            return;
        }
        var _encoding :ParameterEncoding;
        if let encoding = encoding {
            _encoding = encoding;
        }else{
            if method == .get {
                _encoding = URLEncoding.default
            }else{
                _encoding = jsonEncoding ? JSONEncoding.default : URLEncoding.httpBody;
            }
        }

        var headers = BaseNetworkService.makeHttpHeaders();
        if let customHeader = header {
            for (key,value) in customHeader {
                if headers.value(for: key) == nil {
                    headers.add(name: key, value: value);
                }else{
                    headers.update(name: key, value: value);
                }
            }
        }
        BaseNetworkService.addCookies(cookies: cookies);
        let request = BaseNetworkService.sessionManager.request(url, method:method, parameters: parameters, encoding:_encoding, headers: headers)
        if !allowDuplicateRequest {
            BaseNetworkService.dataRequests.updateValue(request, forKey: urlString);
        }
        if enableLog {
            let para = JSON(parameters ?? "");
            LYLog("=请求地址===\(urlString)==请求参数=",para);
        }
        request.responseData(queue: DispatchQueue.main) { (response) in
            if enableLog,let data = response.data {
                let json = try? JSON.init(data: data, options: .fragmentsAllowed);
                LYLog("=请求地址===\(urlString)==数据返回=",json);
            }
            switch response.result {
            case .success(let data):
                result(data);
            case .failure(let error):
                fail(error.errorMsg,error);
                break;
            }
            dataRequests.removeValue(forKey: urlString);
        }
    }
    
    
    public class func addCookies(cookies:[HTTPCookie]?){
        if let cookies = cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.setCookie(cookie);
            }
        }
    }
    
    private class func uploadImageAppendParameters(formData:Alamofire.MultipartFormData,parameters:[String:String]?,thumbMark:Bool = true) {
        if let params = parameters {
            for (key,value) in params {
                if let data = value.data(using: .utf8) {
                    formData.append(data, withName: key);
                }
            }
        }
    }

    private class func uploadImageAppendImages(formData:Alamofire.MultipartFormData,images:[UIImage],compressSize:Int) {
        for (index,image) in images.enumerated(){
            if let data = compressImageData(image:image,maxLength: (500 * 1024)) {
                let timeInterval = NSDate().timeIntervalSince1970 * 1000;
                let imageName = String(format: "%f%d.jpg", timeInterval,index)
                formData.append(data, withName: "image", fileName: imageName, mimeType: "image/jpeg");
            }
        }
    }

        
   class func uploadImages(images:[UIImage],thumbMark:Bool = true,parameters:[String:String]? = nil,progressClosure:((Progress) -> Void)? = nil,successCallback:@escaping SuccessClosure,fail:@escaping FailureClosure) {
        uploadImagesSimply(images: images, thumbMark: thumbMark, parameters: parameters, progressClosure: progressClosure, successCallback:successCallback, fail: fail)
    }

   class func uploadImagesSimply(images:[UIImage],compressSize:Int = 0,thumbMark:Bool = true,parameters:[String:String]? = nil,urlString:String? = nil,progressClosure:((Progress) -> Void)? = nil,successCallback:@escaping SuccessClosure,fail:@escaping FailureClosure) {
        if images.count == 0 {
            fail("未获取到图片信息",nil);
            return;
        }
        let urlStr = urlString ?? "";
        guard let url : URL = URL.init(string:urlStr) else {return};
    //    sessionManager.sessionConfiguration.timeoutIntervalForRequest = 60;
        let uploadRequest = sessionManager.upload(multipartFormData: { (formData) in
            uploadImageAppendParameters(formData: formData, parameters: parameters);
            uploadImageAppendImages(formData: formData, images: images,compressSize:compressSize);
        }, to: url);
        uploadRequest.uploadProgress { (progress) in
            if progressClosure != nil {
                progressClosure!(progress);
            }
            LYLog(progress);
        }
        uploadRequest.responseData(queue: DispatchQueue.main) { (response) in
            switch response.result {
            case .success(let data):
                successCallback(data);
            case .failure(let error):
                fail(error.errorMsg,error);
                break;
            }
        }
    }
    
    private class func makeHttpHeaders() -> HTTPHeaders {
        var headers = HTTPHeaders.default;
        for (key,value) in userHeaders {
            if headers.value(for: key) == nil {
                headers.add(name: key, value: value);
            }else{
                headers.update(name: key, value: value);
            }
        }
        return headers;
    }

    public class func addHeader(name: String, value: String) {
        userHeaders.updateValue(value, forKey: name);
    }
    
    func netWorkStatus(resultCallBack:@escaping (LYNetworkStatus) -> ()) {
        let netWorkManager = NetworkReachabilityManager.init();
        netWorkManager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                resultCallBack(LYNetworkStatus.notReachable);
            case .reachable(.ethernetOrWiFi):
                resultCallBack(LYNetworkStatus.wifi);
            case .reachable(.cellular):
                resultCallBack(LYNetworkStatus.cellular);
            case.unknown:
                resultCallBack(LYNetworkStatus.unknown);
            }
        })
    }
}


extension LYError {
    var errorMsg:String {
        var msg:String? = errorDescription;
        if let underlyingError = self.underlyingError{
            if let urlError = underlyingError as? URLError {
                switch urlError.code
                {
                case .networkConnectionLost:
                    msg = "未能连接到服务器";
                case .cannotConnectToHost:
                    msg = "未能连接到服务器";
                case .timedOut:
                    msg = "连接超时,请稍后再试";
                case .notConnectedToInternet:
                    msg = "未能连接到网络,请检查网络设置";
                default:
                    msg = errorDescription;
                }
            }
        }
        return msg ?? "未知错误";
    }
    
}
