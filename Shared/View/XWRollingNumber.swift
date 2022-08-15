//
//  XWRollingNumber.swift
//  XWeather
//
//  Created by teenloong on 2022/7/26.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI

struct XWRollingNumber: View {
    let font: Font
    @Binding var value: Int
    @State private var animationRange: [Int] = []
        
    init(font: Font, value: Binding<Int>) {
        self.font = font
        self._value = value
        let stringValue = "\(value.wrappedValue)"
        var range = Array(repeating: 0, count: stringValue.count)
        for (index, value) in zip(0..<stringValue.count, stringValue) {
            range[index] = Int(String(value)) ?? 0
        }
        self._animationRange = .init(initialValue: range)
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<animationRange.count, id: \.self) { item in
                Text("8")
                    .font(font)
                    .opacity(0)
                    .overlay(
                        GeometryReader { geometry in
                            let size = geometry.size
                            VStack(spacing: 0) {
                                ForEach(0...9, id: \.self) { item in
                                    Text("\(item)")
                                        .font(font)
                                        .frame(width: size.width, height: size.height, alignment: .center)
                                }
                            }
                            .offset(y: -CGFloat(animationRange[item]) * size.height)
                        }
                        .clipped()
                    )
            }
        }
        .onAppear {
//            #if DEBUG
//            print(Self.self, "onAppear: \(value)")
//            #endif
//            if animationRange.isEmpty {
//                animationRange = Array(repeating: 0, count: "\(value)".count)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    updateText()
//                }
//            }
            
//            updateText()
        }
        .onChange(of: value) { newValue in
            let delta = String(newValue).count - animationRange.count
            if delta > 0 {
                for _ in 0..<delta {
                    withAnimation(.easeIn(duration: 0.1)) {
                        animationRange.insert(0, at: 0)
                    }
                }
            } else {
                for _ in 0..<(-delta) {
                    withAnimation(.easeIn(duration: 0.1)) {
                        animationRange.removeFirst()
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                updateText()
            }
        }
    }
    
    func updateText() {
        let stringValue = "\(value)"
        for (index, value) in zip(0..<stringValue.count, stringValue) {
            let fraction = min(Double(index) * 0.15, 1.5)
            
            withAnimation(.spring(response: 0.8, dampingFraction: 1 + fraction, blendDuration: 1 + fraction)) {
                animationRange[index] = Int(String(value)) ?? 0
            }
        }
    }
}

struct XWRollingNumberDemoView: View {
    @State private var value: Int = 0
    
    var body: some View {
        VStack {
            XWRollingNumber(font: .system(size: 60, weight: .bold), value: $value)
            
            Button {
                value = Int.random(in: 1000...95000)
            } label: {
                Text("Random Number: \(value)")
            }
        }
    }
}

#if DEBUG
struct XWRollingNumber_Previews: PreviewProvider {
    static var previews: some View {
        XWRollingNumberDemoView()
    }
}
#endif
