//
//  ListView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/9/23.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var chatData : ChatData
    
    var body: some View {
        GroupBox(label: Text("CHAT").font(.caption2), content: {
            TextField(chatData.assistant_id, text: $chatData.assistant_id).font(.caption)
            TextField(chatData.thread_id, text: $chatData.thread_id).font(.caption)
        })
        .groupBoxStyle(.automatic)
        .border(Color.white, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        
        List {
            
            ForEach(1...100, id: \.self) {_ in
                
                CompletionView()
                    .border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                
            }
            
            
        }
        .border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        .listStyle(.grouped)
        
        
        
    }
}

#Preview {
    ListView()
        .preferredColorScheme(.dark)
        .environmentObject(ChatData())
}
