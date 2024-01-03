//
//  ViewController.swift
//  LYNetworkService
//
//  Created by 董强彬 on 01/25/2022.
//  Copyright (c) 2022 董强彬. All rights reserved.
//

import UIKit
import LYNetworkService

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testRequest1();
//        testRequest2();
//        if #available(iOS 13.0, *) {
//            testRequest3()
//        } else {
//            // Fallback on earlier versions
//        };
    }
    
    func testRequest1() {
//        NetworkService.share.requestDataModel(PublicAPI.testRequest(code: "021"), model: TestModel.self) { responseModel in
//            print(responseModel);
//        }
        
        PublicAPI.testRequest(code: "021").result(model: TestModel.self) { responseModel in
            LYLog(responseModel.model?.toJson());
        }
    }
    
    func testRequest2() {
//        PublicAPI.testRequest(code: "021").customResult(model: TestUserResponseModel<TestModel>.self) { res, message, model in
//            print(model?.data?.copyModel()?.headLine?.first?.showName);
//        }
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testRequest3() {
       Task {
            let result = await PublicAPI.testRequest(code: "021").awaitResult(model:  TestModel.self);
           LYLog(result.model?.toJson());
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

