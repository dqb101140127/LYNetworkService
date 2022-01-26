# LYNetworkService

<<<<<<< HEAD
[![CI Status](https://img.shields.io/travis/董强彬/LYNetworkService.svg?style=flat)](https://travis-ci.org/董强彬/LYNetworkService)
[![Version](https://img.shields.io/cocoapods/v/LYNetworkService.svg?style=flat)](https://cocoapods.org/pods/LYNetworkService)
[![License](https://img.shields.io/cocoapods/l/LYNetworkService.svg?style=flat)](https://cocoapods.org/pods/LYNetworkService)
[![Platform](https://img.shields.io/cocoapods/p/LYNetworkService.svg?style=flat)](https://cocoapods.org/pods/LYNetworkService)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LYNetworkService is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LYNetworkService', :git => 'https://gitee.com/dongluoyi/LYNetworkService.git'
```

## Author

Lorry, dongqiangbin@foxmail.com

## License

LYNetworkService is available under the MIT license. See the LICENSE file for more info.
=======
#### 使用说明
struct TestModel:HandyJSON  {
    
}
extension NetworkServiceTarget {
    var resultKey: String {
        return "result"
    }
    var statusKey: String {
        return "status";
    }
    var errorMessageKey: String {
        return "message";
    }
    var errorCodeKey: String {
        return "errorCode"
    }
    var bodyKey: String {
        return "data";
    }
}

enum PublicAPI {
    case testRequest(code:String);

}

extension PublicAPI:NetworkServiceTarget {
  
    var baseURL: String {
        switch self {
        case .testRequest(_):
            return "";
        }
    }
    
    var path: String {
        switch self {
        case .testRequest(_):
            return "";
        }
    }
    func parameters() -> [String : Any]? {
        switch self {
        case .testRequest(let code):
            return ["code":code];
        }
    }
    
    func method(path: String) -> HTTPMethod {
        switch self {
        case .testRequest(_):
            return .get
        }
    }
      
    
}
    NetworkService.requestDataModel(PublicAPI.testRequest(code: "021"), model: TestModel.self) { responseModel in
        
        print(responseModel);
        
    }
