
import SwiftyJSON

public protocol LYCompatible {}
public struct LY<Base> {
    public var base:Base;
    init(_ base: Base) {
        self.base = base;
    }
}
extension LYCompatible {
    public var ly: LY<Self> {
        get {
            LY(self)
        }
        set{
        }
    }
    public static var ly: LY<Self>.Type {
        get{
            LY<Self>.self
        }
        set{}
    }
}


public protocol ModelJSON:Codable{
    func copyModel() -> Self?;
    func toJson() -> [String: Any]?;
}

//extension String:HandyJSON{}
//extension NSNumber:HandyJSON {}
//extension Bool:HandyJSON {}
public struct UnParserModel {}
extension String:ModelJSON{}
extension Double:ModelJSON {}
extension Int:ModelJSON {}
extension Bool:ModelJSON {}
extension UnParserModel:ModelJSON {}

extension ModelJSON {
    public func copyModel() -> Self? {
        let enCoder = JSONEncoder();
        if let data = try? enCoder.encode(self) {
            let model = try? JSONDecoder().decode(Self.self, from: data);
            return model;
        }
        return nil;
    }
    public func toJson() -> [String: Any]?{
        let enCoder = JSONEncoder();
        if let data = try? enCoder.encode(self) {
            let result = try? JSON(data: data);
            return result?.dictionaryObject;
        }
        return nil;
    }
    
    
}

public extension Collection where Iterator.Element: ModelJSON {
    func toJSON() -> [[String: Any]?] {
        return self.map{ $0.toJson() }
    }
}


//let currentScreenHeight = UIScreen.main.bounds.height
///// 屏幕高度
//let currentScreenWidth = UIScreen.main.bounds.width
//
//let appDisplayName : String = (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? ""
//
//let documentPaths : String = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first ?? ""
//let libraryPaths : String = NSSearchPathForDirectoriesInDomains(.libraryDirectory,.userDomainMask,true).first ?? ""
//let cachePath : String = NSSearchPathForDirectoriesInDomains(.cachesDirectory,.userDomainMask,true).first ?? ""

public func LYLog(_ log: Any?..., fileName: String = #file, methodName: String =   #function, lineNumber: Int = #line) {
    //        print(#file)    //获取当前print所在的文件路径
    //        print(#function)    //获取当前print所在的方法名称
    //        print(#line)    //获取当前print所在的行数
    ///判断是否打印debug
    #if DEBUG
    print((fileName as NSString).pathComponents.last!,methodName,lineNumber,log)
    #else
    #endif
}

func compressImageData(image:UIImage,maxLength: Int) -> Data? {
        var compression: CGFloat = 1
    guard var data = image.jpegData(compressionQuality: compression),
          data.count > maxLength else { return image.jpegData(compressionQuality: compression) }
        // Compress by size
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = image.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!

        if data.count < maxLength { return data }

        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                    height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = resultImage.jpegData(compressionQuality: compression)!;
        }
        return nil
}


extension UIImage {
    /**
     *  等比率缩放
     */
    func scaleImage(maxLength:CGFloat)-> UIImage {
        var count = self.size.width * self.size.height;
        var scaleSize:CGFloat = 1;
        while count > maxLength,scaleSize > 0{
            scaleSize -= 0.05
            count = count * scaleSize;
        }
    
        let reSize = CGSize(width:self.size.width * scaleSize, height:self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)-> UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x:0, y:0, width:reSize.width, height:reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
}

