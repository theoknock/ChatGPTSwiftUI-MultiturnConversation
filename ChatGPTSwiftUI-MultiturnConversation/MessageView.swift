//
//  MessageView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/24/23.
//

import SwiftUI

struct MessageView: View {
    @ObservedObject var chatData: ChatData
    @State private var prompt: String = String()
    
    var body: some View {
        HStack {
            HStack {
                //                        Group {
                TextField(("Message ChatGTP..."), text: $prompt, axis: .vertical)
                    .padding()
                //                .padding(.horizontal)
                //                .blur(radius: 3.0, opaque: false)
            }
            
            HStack {
                Button(action: {
                    Task {
                        let prompt_tidy = prompt.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                        prompt = prompt_tidy
                        chatData.addMessage(message: prompt_tidy)
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        prompt = String()
                    }
                }, label: {
                    Label("", systemImage: "arrow.up.circle")
                    //                    .foregroundStyle(LinearGradient(gradient: .init(colors: [Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58), Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27)]), startPoint: .topTrailing, endPoint: .bottomLeading))
                    //                    .background(LinearGradient(gradient: .init(colors: [ Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58)]), startPoint: .bottomTrailing, endPoint: .center))
                        .symbolRenderingMode(.hierarchical)
                        .font(.largeTitle)
                        .imageScale(.large)
                        .labelStyle(.iconOnly)
                        .clipShape(Capsule())
                })
                //            .ignoresSafeArea()
                //            .shadow(color: .white, radius: 5)
                //                        }
                
                
                
                
                //                .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.2)))
                //                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
                //                Button(action: {
                //
                //                }, label: {
                //                    Label("", systemImage: "arrow.up")
                //                        .lineLimit(3)
                //                        .padding()
//                                        .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.2)))
                //                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
                //                        .labelStyle(.iconOnly)
                //                        .font(.largeTitle)
                //                        .lineLimit(3)
                //                        .padding()
                //                        .foregroundStyle(Color.primary)
                //                        .background(Color.initiColor: UIColor(white: 1.0, alpha: 0.2)))
                //                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
                
                //                    Image(systemName: <#T##String#> systemImage: "arrow.up.circle")
                //                        .resizable()
                //                        .font(.largeTitle)
                //                        .imageScale(.large)
                //                        .foregroundColor(Color.secondary)
                //                        .symbolRenderingMode(.hierarchical)
                
                //                })
                //                .fixedSize(horizontal: true, vertical: true)
                //        }:
            }
            .ignoresSafeArea()
            .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.2)))
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous))
        }
        .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.2)))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous))
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(chatData: ChatData())
            .preferredColorScheme(.dark)
    }
}

