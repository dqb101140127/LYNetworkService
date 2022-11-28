//
//  NetworkServiceTarget+extension.swift
//  LYNetworkService
//
//  Created by dong on 2022/2/21.
//
import HandyJSON

public protocol NetworkServiceTarget:BaseNetworkServiceTarget {
    var resultKey:String{get}//状态字段 返回LYResponseModel->result(bool类型)
    var statusKey:String{get}//状态字段 返回LYResponseModel->status (int类型）
    var errorMessageKey:String{get}
    var errorCodeKey:String{get}
    var bodyKey:String{get}
}

extension NetworkServiceTarget {
    public var ly: NetworkService.Type {
        get{
            NetworkService.self
        }
        set{}
    }
    
    //MARK 返回指定的响应模型
    public func result<M:HandyJSON>(model:M.Type,
                               parameters:[String:Any]? = nil,
                                 _ result:@escaping (_ responseModel:LYResponseModel<M>)->()) {
        NetworkService.share.requestDataModel(self,parameters: parameters, model: model, result: result);
    }
    //MARK 返回指定的响应模型
    public func result<M:Decodable>(model:M.Type,
                               parameters:[String:Any]? = nil,
                                 _ result:@escaping (_ responseModel:ResponseInfoModel<M>)->()) {
        NetworkService.share.requestDataAndConvertToModel(self,parameters: parameters, model: model, result: result);
    }
    // MARK: 返回自定义模型
    public func customResult<M:Decodable>(model:M.Type,
                                     parameters:[String:Any]? = nil,
                                       _ result:@escaping (_ res:Bool,_ message:String?,_ model:M?)->()) {
        NetworkService.share.requestCustomDataModel(self,parameters: parameters, model: model, result: result);
    }
    
    public func responseJson(parameters:[String:Any]? = nil,
                                _ result:@escaping (_ responseModel:ResponseModel)->()) {
        NetworkService.share.requestJson(self,parameters: parameters, result);
    }
}
