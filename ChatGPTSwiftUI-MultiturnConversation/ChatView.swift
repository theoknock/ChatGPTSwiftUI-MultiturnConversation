//
//  ChatView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/13/23.
//

import SwiftUI

struct ChatView: View {
    @State private var chatSession: String = ""
    
    @ObservedObject var chatData : ChatData
    
    var body: some View {
        HStack {
            HStack {
                TextField(text: $chatSession, prompt: Text("Untitled chat")) {
                    
                }.textFieldStyle(.roundedBorder)
                .safeAreaPadding(.leading)
                
            }
            HStack {
                Button("New") {
                    
                }
                .safeAreaPadding(.trailing)
                .buttonStyle(.bordered)
            }
            
        }
        
        
//        GroupBox(label: Text("CHAT").font(.caption2), content: {
//            TextField(chatData.assistant_id, text: $chatData.assistant_id).font(.caption)
//            TextField(chatData.thread_id, text: $chatData.thread_id).font(.caption)
//            TextField(chatData.run_id, text: $chatData.run_id).font(.caption)
//        })
//        .groupBoxStyle(.automatic)
    }
}
