//
//  ViewController.swift
//  LYNetworkService
//
//  Created by 董强彬 on 01/25/2022.
//  Copyright (c) 2022 董强彬. All rights reserved.
//

import UIKit
import HandyJSON
import LYNetworkService

struct TestModel:HandyJSON  {
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkService.requestDataModel(PublicAPI.testRequest(id: "1043920957"), model: TestModel.self) { responseModel in
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

