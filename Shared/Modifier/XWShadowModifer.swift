//
//  XWShadowModifer.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI

struct XWShadowModifer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .gray, radius: 3, x: 0, y: 10)
    }
}
//
//struct XWShadowModifer_Previews: PreviewProvider {
//    static var previews: some View {
//        XWShadowModifer()
//    }
//}
