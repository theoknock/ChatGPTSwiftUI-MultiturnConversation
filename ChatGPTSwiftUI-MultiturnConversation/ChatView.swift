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
                TextField("Untitled chat", text: $chatSession)
                    .foregroundColor(Color.primary)
                    .safeAreaPadding(.all)
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                Button(action: {
                    Task {
                        chatData.save()
                        chatData.assistant()
                        chatData.thread()
                    }
                }) {
                    Image(systemName: "arrow.up.doc")
                        .aspectRatio(contentMode: .fit)
                        .symbolRenderingMode(.monochrome)
                        .fontWeight(.thin)
                        .foregroundStyle(Color.secondary)
                }
                .safeAreaPadding(.trailing)
                .buttonStyle(.bordered)
            }
            HStack {
                Button(action: {
                    Task {
                        chatData.load()
                    }
                }) {
                    Image(systemName: "arrow.down.doc")
                        .aspectRatio(contentMode: .fit)
                        .symbolRenderingMode(.monochrome)
                        .fontWeight(.thin)
                        .foregroundStyle(Color.secondary)
                }
                .safeAreaPadding(.trailing)
                .buttonStyle(.bordered)
            }
        }
        .background(Color(uiColor: .quaternarySystemFill))
        
        
        //        GroupBox(label: Text("CHAT").font(.caption2), content: {
        //            TextField(chatData.assistant_id, text: $chatData.assistant_id).font(.caption)
        //            TextField(chatData.thread_id, text: $chatData.thread_id).font(.caption)
        //            TextField(chatData.run_id, text: $chatData.run_id).font(.caption)
        //        })
        //        .groupBoxStyle(.automatic)
    }
    
    
    
}
