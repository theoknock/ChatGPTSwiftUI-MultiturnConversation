//
//  CompletionView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/9/23.
//

import SwiftUI

struct CompletionView: View {
    @EnvironmentObject var chatData : ChatData
    
    var body: some View {
        Section {
//            ForEach(0...1, id: \.self) { index in
                Section {
                    GroupBox(label: Text("\(chatData.assistant_id)").font(.caption2), content: {
                        TextField("\(chatData.assistant_id)", text: .constant("\(chatData.assistant_id)"))
                    })
                    GroupBox(label: Text("\(chatData.thread_id)").font(.caption2), content: {
                        TextField("\(chatData.thread_id)", text: .constant("\(chatData.thread_id)"))
                    })
                }
//            }
        }
    }
}

#Preview {
    CompletionView()
        .preferredColorScheme(.dark)
        .environmentObject(ChatData())
}
