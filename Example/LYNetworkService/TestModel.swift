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



class BrandModel:Codable {
    var brandName:String?;
    var brandId:Int?;
    var brandIcon:String?;
    
    enum CodingKeys: CodingKey {
        case brandName
        case brandIcon
        case brandId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.brandName = try container.decodeIfPresent(String.self, forKey: .brandName)
            
        self.brandIcon = try container.decodeIfPresent(String.self, forKey: .brandIcon)
        
        do {
            self.brandId = try container.decode(Int.self, forKey: .brandId)
        } catch _ {
            self.brandId = 0;
        }
        

        
        print("------------------BrandModel-----decoder---------------");

    }

}

class TestModel: ModelJSON {
    var headLine:[HeadLine]?;
    var brandList:[BrandModel]?
    var productType:[ProductTypeModel]?
    
    enum CodingKeys: CodingKey {
        case headLine
        case brandList
        case productType //忽略变量-> 重写encode decoder方法
    }
    //encode
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encodeIfPresent(self.headLine, forKey: .headLine)
//        try container.encodeIfPresent(self.brandList, forKey: .brandList)
//        try container.encodeIfPresent(self.productType, forKey: .productType)
//
//    }
    //decoder
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.headLine = try container.decodeIfPresent([HeadLine].self, forKey: .headLine)
        self.brandList = try container.decodeIfPresent([BrandModel].self, forKey: .brandList)
        self.productType = try container.decodeIfPresent([ProductTypeModel].self, forKey: .productType)

    }
}


struct HeadLine:ModelJSON,HandyJSON{
    var showId:Int?
    var showName:String?
    
}

struct ProductTypeModel:ModelJSON {
    var productTypeName:String?
    var productTypeId:Int?
    var productTypeIcon:String?
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.productTypeName = try container.decodeIfPresent(String.self, forKey: .productTypeName)
//        self.productTypeId = try container.decodeIfPresent(Int.self, forKey: .productTypeId)
//        self.productTypeIcon = try container.decodeIfPresent(String.self, forKey: .productTypeIcon)
//
//        print("------------------ProductTypeModel-----decoder---------------");
//    }
    
}

