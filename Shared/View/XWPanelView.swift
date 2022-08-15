//
//  XWPanelView.swift
//  XWeather
//
//  Created by teenloong on 2022/5/22.
//  Copyright © 2022 com.teenloong. All rights reserved.
//

import SwiftUI

struct XWPanelView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(#colorLiteral(red: 0.9372649789, green: 0.9375118613, blue: 0.9451228976, alpha: 1)), Color(#colorLiteral(red: 0.8744205236, green: 0.8786126971, blue: 0.886306107, alpha: 1))], startPoint: .top, endPoint: .bottom)
            RoundedRectangle(cornerRadius: 10).stroke(LinearGradient(colors: [Color(#colorLiteral(red: 0.7410820127, green: 0.7451506257, blue: 0.7490388751, alpha: 1)), Color(#colorLiteral(red: 0.7960784435, green: 0.7960784435, blue: 0.7960784435, alpha: 1))], startPoint: .top, endPoint: .bottom), lineWidth: 3)
            RoundedRectangle(cornerRadius: 8).stroke(LinearGradient(colors: [Color(#colorLiteral(red: 0.7920830846, green: 0.7966516614, blue: 0.8157544136, alpha: 0.5)), Color(#colorLiteral(red: 0.8391366601, green: 0.8435787559, blue: 0.8588795662, alpha: 1))], startPoint: .top, endPoint: .bottom), lineWidth: 12)
                .padding(2)
                .blur(radius: 6)
                .offset(x: 0, y: 6)
                .mask(RoundedRectangle(cornerRadius: 10))
        }
        .mask(RoundedRectangle(cornerRadius: 10))
    }
}

#if DEBUG
struct XWPanelView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            XWBackgroundView()
            XWPanelView()
                .frame(height: 250)
            .padding(.horizontal)
        }
    }
}
#endif
