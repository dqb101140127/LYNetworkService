//
//  TestModel.swift
//  LYNetworkService_Example
//
//  Created by dong on 2022/2/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import LYNetworkService
import HandyJSON


struct TestModel: ModelJSON,HandyJSON {
    var headLine:[HeadLine]?;
    
}


struct HeadLine:ModelJSON,HandyJSON{
    var showId:Int?
    var showName:String?
    
}
