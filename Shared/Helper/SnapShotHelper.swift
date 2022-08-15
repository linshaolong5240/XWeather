//
//  SnapShotHelper.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI

extension View {
    #if canImport(AppKit)
    func snapshot() -> CrossImage? {
        let controller = CrossHostingController(rootView: self)
        let targetSize = controller.view.intrinsicContentSize
        let contentRect = NSRect(origin: .zero, size: targetSize)
        let window = NSWindow(
            contentRect: contentRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window.contentView = controller.view
        
        guard
            let bitmapRep = controller.view.bitmapImageRepForCachingDisplay(in: contentRect)
        else { return nil }
        
        controller.view.cacheDisplay(in: contentRect, to: bitmapRep)
        let image = NSImage(size: bitmapRep.size)
        image.addRepresentation(bitmapRep)

        return image
    }
    #endif
    
    #if canImport(UIKit)
    func asImageOffScreen(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self.ignoresSafeArea())

        // locate far out of screen
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: size)
        controller.view.backgroundColor = .clear
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()

        let image = controller.view.snapshotWithTransparent()
        controller.view.removeFromSuperview()
        return image
    }
    
    func snapshot() -> UIImage? {
        let controller = UIHostingController(rootView: self.ignoresSafeArea())
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        #if DEBUG
        print("\(#function)targetSize: \(targetSize)")
        #endif
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let imageData = renderer.pngData { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
        
        return UIImage(data: imageData)
    }
    #endif
}

#if canImport(UIKit)
extension UIView {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)

        return  renderer.image { rendererContext in
            // [!!] Uncomment to clip resulting image
            //             rendererContext.cgContext.addPath(
            //                UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath)
            //            rendererContext.cgContext.clip()
            
            // As commented by @MaxIsom below in some cases might be needed
            // to make this asynchronously, so uncomment below DispatchQueue
            // if you'd same met crash
            //            DispatchQueue.main.async {
            layer.render(in: rendererContext.cgContext)
            //            }
        }
    }
    
    func snapshotWithTransparent() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        // renderer.pngData convert to Image will display not correct when image convert to UIColor(patternImage:)
        let imageData = renderer.pngData { rendererContext in
            // [!!] Uncomment to clip resulting image
            //             rendererContext.cgContext.addPath(
            //                UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath)
            //            rendererContext.cgContext.clip()
            
            // As commented by @MaxIsom below in some cases might be needed
            // to make this asynchronously, so uncomment below DispatchQueue
            // if you'd same met crash
            //            DispatchQueue.main.async {
            layer.render(in: rendererContext.cgContext)
            //            }
        }
        return  UIImage(data: imageData)!
    }
}
#endif
