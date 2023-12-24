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
            Group {
                TextField(("Message ChatGTP..."), text: $prompt, axis: .vertical)
                    .lineLimit(3)
                    .padding()
                    .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.5)))
                    .foregroundColor(Color.primary)
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
                        .resizable()
                        .font(.largeTitle)
                        .symbolRenderingMode(.multicolor)
                        .imageScale(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
                })
                .fixedSize(horizontal: true, vertical: true)
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(chatData: ChatData())
            .preferredColorScheme(.dark)
    }
}

