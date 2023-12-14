//
//  ListView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/9/23.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var chatData : ChatData
    
    var body: some View {
        GroupBox(label: Text("CHAT").font(.caption2), content: {
            TextField(chatData.assistant_id, text: $chatData.assistant_id).font(.caption)
            TextField(chatData.thread_id, text: $chatData.thread_id).font(.caption)
            TextField(chatData.run_id, text: $chatData.run_id).font(.caption)
        })
        .groupBoxStyle(.automatic)
        .border(Color.white, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        
        List {
            ForEach(chatData.messages) { message in
                Section {
                    GroupBox(label: Text("PROMPT").font(.caption2), content: {
                        TextField(message.prompt, text: .constant(message.prompt))
                    })
                    GroupBox(label: Text("RESPONSE").font(.caption2), content: {
                        TextField(message.response, text: .constant(message.response))
                    })
                }
                
//                CompletionView()
//                    .border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                
            }
            
            
        }
        .border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        .listStyle(.grouped)
        
        
        
    }
}
