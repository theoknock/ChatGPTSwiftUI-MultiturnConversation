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
                TextField(("Message ChatGTP..."), text: $prompt, axis: .vertical)
                    .padding()
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
                        .symbolRenderingMode(.hierarchical)
                        .font(.largeTitle)
                        .imageScale(.large)
                        .labelStyle(.iconOnly)
                        .clipShape(Capsule())
                })
            }
            .ignoresSafeArea()
            .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.2)))
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous))
        }
        .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.2)))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous))
        
        // -------
        
//        HStack {
//            Spacer()
//            RoundedRectangle(cornerRadius: 4.0, style: .continuous)
//                .stroke(Color.accentColor, lineWidth: 4.0)
//                .frame(idealWidth: UIScreen.main.bounds.width * 0.875, idealHeight: 40)
//                .fixedSize(horizontal: false, vertical: true)
//            Spacer()
//            RoundedRectangle(cornerRadius: 4.0, style: .continuous)
//                .stroke(Color.accentColor, lineWidth: 4.0)
//                .frame(idealWidth: UIScreen.main.bounds.width * 0.125, idealHeight: 40)
//                .fixedSize(horizontal: true, vertical: true)
//            Spacer ()
//        }
//        .frame(idealWidth: UIScreen.main.bounds.width, idealHeight: 40)
//        .fixedSize(horizontal: true, vertical: false)
        
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(chatData: ChatData())
            .preferredColorScheme(.dark)
    }
}

