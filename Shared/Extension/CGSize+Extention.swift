//
//  CGSize+Extention.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGSize {
    
    var ratio: CGFloat { width / height }
    
    func adapterSize(to size: CGSize) -> CGSize {
        return width < size.width && height < size.height ? self : fitSize(to: size)
    }
    
    func fitSize(to size: CGSize) -> CGSize {
        let minLength = min(size.width, size.height)
        if ratio == 1.0 {
            return CGSize(width: minLength, height: minLength)
        } else if ratio < 1.0 {
            let width = size.height * ratio
            let height = size.height
            return CGSize(width: width, height: height)
        } else {
            let width = size.width
            let height = size.width / ratio
            return CGSize(width: width, height: height)
        }
    }
}
