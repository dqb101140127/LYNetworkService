//
//  LYResponseModel.swift
//  neverStop
//
//  Created by developer_m1 on 2022/1/20.
//  Copyright © 2022 dongqiangbin. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON


public class ResponseModel {
    public var result : Bool = false;
    public var status:Int?;
    public var errorCode : String?
    public var errorMessage : String?
    public var error:LYError?
    public var data : Data?;//原始数据
    public var jsonData : JSON?;//原始数据
    public var body:JSON?;
    
    class func makeResponseModel(errorMessage:String?,error:LYError?) -> ResponseModel {
        let responseModel = ResponseModel();
        responseModel.result = false;
        responseModel.errorMessage = errorMessage;
        responseModel.error = error;
        return responseModel;
    }
}
public class LYResponseModel<T:HandyJSON>:HandyJSON {
    public var result : Bool = false;
    public var status:Int?;
    public var errorCode : String?
    public var errorMessage : String?
    public var error:LYError?
    public var data : Data?;//原始数据
    public var jsonData : JSON?;//原始数据
    public var model : T?;
    public var models:[T]?;
  
    public func mapping(mapper: HelpingMapper) {
        mapper >>> model
        mapper >>> models
        mapper >>> data
        mapper >>> jsonData
    }
    public required init() {}
    class func makeErrorResponseModel(errorMessage:String?,error:LYError?) -> LYResponseModel<T> {
        let responseModel = LYResponseModel<T>();
        responseModel.result = false;
        responseModel.errorMessage = errorMessage;
        responseModel.error = error;
        return responseModel;
    }
}

public class ResponseInfoModel<T:Decodable> {
    public var result : Bool = false;
    public var status:Int?;
    public var errorCode : String?
    public var errorMessage : String?
    public var data : Data?;//原始数据
    public var jsonData : JSON?;//原始数据
    public var error:LYError?;
    public var model : T?;
    public var models:[T]?;
    
    public required init() {}
    class func makeErrorResponseModel(errorMessage:String?,error:LYError?) -> ResponseInfoModel<T> {
        let responseModel = ResponseInfoModel<T>();
        responseModel.result = false;
        responseModel.errorMessage = errorMessage;
        responseModel.error = error;
        return responseModel;
    }
}

class ResponseArrayConvertModel<T:Decodable>: Decodable {
    var models:[T]?;
}

class ResponseDictionaryConvertModel<T:Decodable>: Decodable {
    var model:T?;
}

