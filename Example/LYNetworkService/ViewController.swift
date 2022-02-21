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
//        testRequest1();
        testRequest2();
    }
    
    func testRequest1() {
        NetworkService.requestDataModel(PublicAPI.testRequest(code: "021"), model: TestModel.self) { responseModel in
            print(responseModel);
        }
    }
    
    func testRequest2() {
        PublicAPI.testRequest(code: "021").result(model: TestModel.self) { responseModel in
            print(responseModel.model?.headLine as Any);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

