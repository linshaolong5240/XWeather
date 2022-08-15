//
//  ImageHelper.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI

extension URL {
    var image: CrossImage? { CrossImage(contentsOfFile: path) }
}

//Basic Extension
#if canImport(AppKit)
extension NSImage {
    func pngData() -> Data? {
        guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.png, properties: [:])!
        return jpegData
    }
    
    func jpegData(compressionQuality: Double = 1.0) -> Data? {
        guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
        let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
        return jpegData
    }
}

extension NSView {
    var nsImage: NSImage? {
        guard let rep = bitmapImageRepForCachingDisplay(in: bounds) else {
            return nil
        }
        cacheDisplay(in: bounds, to: rep)
        guard let cgImage = rep.cgImage else {
            return nil
        }
        return NSImage(cgImage: cgImage, size: bounds.size)
    }
}
#endif

//resize
extension CrossImage {
    #if canImport(AppKit)
    var cgImage: CGImage? {
        cgImage(forProposedRect: nil, context: nil, hints: nil)
    }
    #endif
    
    func crop(ratio: CGFloat) -> CrossImage? {
        var newSize: CGSize = .zero
        if size.width / size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else {
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
     
        var rect: CGRect = .zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
         
        return crop(rect: rect)
    }
    
    func crop(rect: CGRect) -> CrossImage? {
        guard let cropedCGImage = cgImage?.cropping(to: rect) else {
            return nil
        }
        #if canImport(AppKit)
        return CrossImage(cgImage: cropedCGImage, size: .init(width: cropedCGImage.width, height: cropedCGImage.height))
        #endif
        #if canImport(UIKit)
        return CrossImage(cgImage: cropedCGImage)
        #endif
    }
    
    func resize(to size: CGSize) -> CrossImage? {
        guard let cgImage = cgImage else {
            return nil
        }
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)

        let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
        let destBytesPerRow = width * bytesPerPixel


        guard let colorSpace = cgImage.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: destBytesPerRow, space: colorSpace, bitmapInfo: cgImage.alphaInfo.rawValue) else { return nil }

        context.interpolationQuality = .high
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let resizedCGImage = context.makeImage() else {
            return nil
        }

        #if canImport(AppKit)
        return context.makeImage().flatMap { CrossImage(cgImage: $0, size: size) }
        #endif
        #if canImport(UIKit)
        return CrossImage(cgImage: resizedCGImage)
        #endif
    }
}

#if canImport(UIKit)
import UIKit

extension UIImage {
    // 截取部分图片
    func cropAtRect(rect: CGRect) -> UIImage {
            var rect = rect
        rect.origin.x *= UIScreen.main.scale
        rect.origin.y *= UIScreen.main.scale
        rect.size.width *= UIScreen.main.scale
        rect.size.height *= UIScreen.main.scale
            let imageRef = self.cgImage!.cropping(to: rect)
            let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
            return image
    }
    
    //将图片裁剪成指定比例（多余部分自动删除）
    func crop(ratio: CGFloat) -> UIImage {
        //计算最终尺寸
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else {
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
     
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
         
        //绘制并获取最终图片
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
//        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        return scaledImage!
    }
    
    func resize(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
//        UIGraphicsBeginImageContext(newSize)
        //draw resized image on Context
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width.rounded(.up), height: newSize.height.rounded(.up)))
        //create UIImage
        let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImg!
    }
    
    func compress(maxOfBytes: Int64) -> UIImage? {
        guard let data = compressData(maxOfBytes: maxOfBytes) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    func compressData(maxOfBytes: Int64) -> Data? {
        let imageData = jpegData(compressionQuality: 0.7)
        guard imageData?.count ?? 0 > maxOfBytes else {
#if DEBUG
            print("compressionQuality: 0.7 bytes: \(String(describing: imageData?.count))")
#endif
            return imageData
        }
        var data = Data()
        var min: CGFloat = 0.0
        var max: CGFloat = 0.7
        var compressionQuality: CGFloat = 0
        for _ in 0 ..< 6 {
            compressionQuality = (min + max) / 2.0
            data = jpegData(compressionQuality: compressionQuality)!
            #if DEBUG
            print("compressionQuality: \(compressionQuality) bytes: \(data.count)")
            #endif
            if data.count < maxOfBytes {
                min = compressionQuality
            }else {
                max = compressionQuality
            }
        }
        return data
    }
    
    
    //SwiftUI can't use at run time with create DynamicImage
    //https://stackoverflow.com/questions/58291886/how-to-generate-a-dynamic-light-dark-mode-uiimage-from-core-graphics
    static func createDynamicImage(light: UIImage, dark: UIImage) -> UIImage {
        let imageAsset = UIImageAsset()
        
        let lightMode = UITraitCollection(traitsFrom: [.init(userInterfaceStyle: .light)])
        imageAsset.register(light, with: lightMode)
        
        let darkMode = UITraitCollection(traitsFrom: [.init(userInterfaceStyle: .dark)])
        imageAsset.register(dark, with: darkMode)
        
        return imageAsset.image(with: .current)
    }
    
    static func createDynamicImage(lightURL: URL, darkURL: URL) -> UIImage? {
        guard let lightImage = UIImage(contentsOfFile: lightURL.path) else {
            return nil
        }
        
        let imageAsset = UIImageAsset()
        
        let lightMode = UITraitCollection(traitsFrom: [.init(userInterfaceStyle: .light)])
        imageAsset.register(lightImage, with: lightMode)
        
        let darkImage = UIImage(contentsOfFile: darkURL.path) ?? lightImage
        
        let darkMode = UITraitCollection(traitsFrom: [.init(userInterfaceStyle: .dark)])
        imageAsset.register(darkImage, with: darkMode)
        
        return imageAsset.image(with: .current)
    }
    
    static func dynamicImage(withLight light: @autoclosure () -> UIImage,
                             dark: @autoclosure () -> UIImage) -> UIImage {
        
        if #available(iOS 13.0, *) {
            
            let lightTC = UITraitCollection(traitsFrom: [.current, .init(userInterfaceStyle: .light)])
            let darkTC = UITraitCollection(traitsFrom: [.current, .init(userInterfaceStyle: .dark)])
            
            var lightImage = UIImage()
            var darkImage = UIImage()
            
            lightTC.performAsCurrent {
                lightImage = light()
            }
            darkTC.performAsCurrent {
                darkImage = dark()
            }
            
            lightImage.imageAsset?.register(darkImage, with: darkTC)
            return lightImage
        }
        else {
            return light()
        }
    }
}
#endif
