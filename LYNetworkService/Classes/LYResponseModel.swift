//
//  LYResponseModel.swift
//  neverStop
//
//  Created by developer_m1 on 2022/1/20.
//  Copyright © 2022 dongqiangbin. All rights reserved.
//

import UIKit
import HandyJSON
public class LYResponseModel<T:HandyJSON> :HandyJSON {
    public var result : Bool = false;
    public var status:Int = 0;
    public var errorCode : String?
    public var errorMessage : String?
    public var error:LYError?
    public var data : Data?;//原始数据
    public var model : T?;
    public var models:[T]?;
    
  public func mapping(mapper: HelpingMapper) {
      mapper >>> model
      mapper >>> models
      mapper >>> data
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
