//
//  TestUserResponseModel.swift
//  LYNetworkService_Example
//
//  Created by dong on 2022/11/23.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import LYNetworkService

struct TestUserResponseModel<T:ModelJSON>: ModelJSON {
    var result:Int?;
    var message:String?;
    var errorCode:String?;
    var data:T?;
    
    enum CodingKeys:String, CodingKey {
        case result = "status"
        case message
        case errorCode
        case data
    }
    


}
