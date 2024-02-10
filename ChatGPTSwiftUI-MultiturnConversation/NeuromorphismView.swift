//
//  NeuromorphismView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/27/23.
//

import SwiftUI

struct NeumorphismView: View {
    @ObservedObject var chatData: ChatData
    @State private var prompt: String = String()
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            color.BaseColor
                .edgesIgnoringSafeArea(.all)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 150, height: 150)            
        }
    }
}

struct NeumorphismModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(color.ForegroundColor)
            .shadow(color: color.LightShadowColor, radius: 10.0, x: 5.0, y: 5.0)
            .shadow(color: color.DarkShadowColor, radius: 10.0, x: -5.0, y: -5.0)
    }
}

class color {
    static let BaseColor: Color = Color(red: 0.09019608050584793, green: 0.45490193367004395, blue: 0.8549019694328308)
    static let LightShadowColor: Color = Color(red: 0.01176470797508955, green: 0.37647056579589844, blue: 0.7764706015586853)
    static let DarkShadowColor: Color = Color(red: 0.16862747073173523, green: 0.5333333015441895, blue: 0.9333333373069763)
    static let ForegroundColor: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(red: 0.05098039423133813, green: 0.4156862473955341, blue: 0.815686283158321), Color(red: 0.12941176678035773, green: 0.4941176199445538, blue: 0.8941176557073406)]), startPoint: .topLeading, endPoint: .bottomTrailing)
}

struct NeumorphismView_Previews: PreviewProvider {
    static var previews: some View {
        NeumorphismView(chatData: ChatData())
            .preferredColorScheme(.dark)
    }
}
