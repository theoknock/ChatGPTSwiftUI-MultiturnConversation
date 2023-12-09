//
//  PromptView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/9/23.
//

import SwiftUI

struct PromptView: View {
    @State private var senderMessage: String = ""
    @EnvironmentObject var chatData : ChatData
    
    var body: some View {
        HStack {
//            ZStack(alignment: .trailing) {
                HStack {
                    TextField("Message ChatGPT...", text: $senderMessage)
                        .foregroundColor(Color.primary)
                        .safeAreaPadding(.all)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    Button("Send") {
                        //                            getAssistant(assistantID: assistantID)
                        //                            sleep(1)
                        //                            threadID = createThread(threadID)
                        //                            sleep(1)
                        //                            addMessage(message: senderMessage, threadID: threadID)
                    }
                    .safeAreaPadding(.trailing)
                    .buttonStyle(.bordered)
                }
                
//            }
        
            
        }
        .background(Color(uiColor: .quaternarySystemFill))
    }
}

#Preview {
    PromptView()
        .preferredColorScheme(.dark)
        .environmentObject(ChatData())
}
