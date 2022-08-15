//
//  CrossHelper.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI
#if canImport(AppKit)
import AppKit
public typealias CrossColor = NSColor
public typealias CrossHostingController = NSHostingController
public typealias CrossImage = NSImage
public typealias CrossFont = NSFont
public typealias CrossScreen = NSScreen
public typealias CrossView = NSView
public typealias CrossViewRepresent = NSViewRepresent
public typealias CrossViewControllerRepresent = NSViewControllerRepresent
#endif
#if canImport(UIKit)
import UIKit
public typealias CrossColor = UIColor
public typealias CrossImage = UIImage
public typealias CrossFont = UIFont
public typealias CrossScreen = UIScreen
public typealias CrossView = UIView
public typealias CrossViewRepresent = UIViewRepresent
public typealias CrossViewControllerRepresent = UIViewControllerRepresent
#endif

extension Image {
    public init(crossImage: CrossImage) {
        #if canImport(AppKit)
        self.init(nsImage: crossImage)
        #endif
        #if canImport(UIKit)
        self.init(uiImage: crossImage)
        #endif
    }
}

#if canImport(AppKit)
@available(macOS 10.15, *)
public struct NSViewRepresent<T: NSView>: NSViewRepresentable {
    public let view: T
    
    public init(_ view: T) {
        self.view = view
    }

    public func makeNSView(context: Context) -> T {
        return view
    }
    
    public func updateNSView(_ uiView: T, context: Context) {
        
    }
    
    public typealias NSViewType = T
}

@available(macOS 10.15, *)
public struct NSViewControllerRepresent<T: NSViewController>: NSViewControllerRepresentable {
    public let viewController: T
    
    public init(_ viewController: T) {
        self.viewController = viewController
    }
    
    public func makeNSViewController(context: Context) -> NSViewControllerType {
        return viewController
    }
    
    public func updateNSViewController(_ uiViewController: NSViewControllerType, context: Context) {
        
    }
    
    public typealias NSViewControllerType = T
}

#endif

#if canImport(UIKit)
@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct UIViewRepresent<T: UIView>: UIViewRepresentable {
    public let view: T
    
    public init(_ view: T) {
        self.view = view
    }

    public func makeUIView(context: Context) -> T {
        return view
    }
    
    public func updateUIView(_ uiView: T, context: Context) {
        
    }
    
    public typealias UIViewType = T
}

@available(iOS 13.0, tvOS 13.0, *)
@available(macOS, unavailable)
@available(watchOS, unavailable)
public struct UIViewControllerRepresent<T: UIViewController>: UIViewControllerRepresentable {
    public let viewController: T
    
    public init(_ viewController: T) {
        self.viewController = viewController
    }
    
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        return viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    public typealias UIViewControllerType = T
}
#endif
