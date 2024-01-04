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
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func resultUseAwait<M:ModelJSON>(model:M.Type,
                                         parameters:[String:Any]? = nil) async -> ResponseInfoModel<M> {
        return await NetworkService.share.requestDataAndConvertToModel(self, parameters: parameters, model: model);
    }

    //MARK ModelJSON
    public func result<M:ModelJSON>(model:M.Type,
                               parameters:[String:Any]? = nil,
                                 _ result:@escaping (_ responseModel:ResponseInfoModel<M>)->()) {
        NetworkService.share.requestDataAndConvertToModel(self,parameters: parameters, model: model, result: result);
    }
    //MARK Decodable 返回指定的响应模型
    public func response<M:Decodable>(model:M.Type,
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
    
    //MARK HandyJSON 返回指定的响应模型
    @available(*,deprecated, message: "HandyJSON作者已不再维护")
    public func result<M:HandyJSON>(model:M.Type,
                               parameters:[String:Any]? = nil,
                                 _ result:@escaping (_ responseModel:LYResponseModel<M>)->()) {
        NetworkService.share.requestDataModel(self,parameters: parameters, model: model, result: result);
    }

}
