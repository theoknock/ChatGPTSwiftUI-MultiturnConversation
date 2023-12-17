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
    
    @ObservedObject var chatData : ChatData
    
    var body: some View {
        HStack {
            TextField("Message ChatGPT...", text: $prompt, axis: .vertical)
                .foregroundColor(Color.primary)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3)
            
            Button(action: {
                Task {
                    chatData.addMessage(message: prompt.trimmingCharacters(in: .whitespacesAndNewlines))
                    prompt = String()
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }) {
                Image(systemName: "square.and.arrow.up")
                    .symbolRenderingMode(.hierarchical)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.primary)
            }
            .buttonStyle(.plain)
        }
        .padding(.bottom)
    }
}

struct PromptView_Previews: PreviewProvider {
    static var previews: some View {
        PromptView(chatData: ChatData())
            .preferredColorScheme(.dark)
    }
}
