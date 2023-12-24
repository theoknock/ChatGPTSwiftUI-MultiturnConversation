//
//  PromptView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/9/23.
//

import SwiftUI
import Foundation

struct PromptView: View {
    @State private var prompt: String = String()
    @ObservedObject var chatData: ChatData
    @State private var myValue: CGFloat = 40.0
    
    var body: some View {
        //        HStack {
        HStack(alignment: .center, spacing: nil, content: {
            HStack {
                    TextField(("Message ChatGTP..."), text: $prompt, axis: .vertical)
                        .foregroundColor(Color.black)
                        .lineLimit(3)
                        .padding()
                        .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.1)))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
            
                Button(action: {
                    Task {
                        let prompt_tidy = prompt.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                        prompt = prompt_tidy
                        chatData.addMessage(message: prompt_tidy)
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        prompt = String()
                    }
                }, label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .symbolRenderingMode(.multicolor)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    //                                                .frame(idealWidth: geometry.size.height, idealHeight: geometry.size.height)
                        .fixedSize(horizontal: true, vertical: true)
                    //                        .frame(height: geometry.size.width)
                })
                .buttonStyle(.borderedProminent)
                //                .fixedSize(horizontal: true, vertical: true)
                
                
                //                Button(action: {
                //                    Task {
                //                        let prompt_tidy = prompt.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                //                        prompt = prompt_tidy
                //                        chatData.addMessage(message: prompt_tidy)
                //                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                //                        prompt = String()
                //                    }
                //                }, label: {
                //                    Image(systemName: "arrow.up.circle.fill")
                //                        .symbolRenderingMode(.multicolor)
                //                        .aspectRatio(1.0, contentMode: .fit)
                //                }.resizable()))
                //                .safeAreaPadding(.top)
                //                .safeAreaPadding(.bottom)
                //                .safeAreaPadding(.trailing)
                
            }
            .background(Color.gray)
            .geometryGroup()
        })
    }
}

struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        PromptView(chatData: ChatData())
            .preferredColorScheme(.dark)
    }
}
