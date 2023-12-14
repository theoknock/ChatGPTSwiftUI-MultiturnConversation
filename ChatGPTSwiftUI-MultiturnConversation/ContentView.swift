//
//  ContentView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/8/23.
//

import SwiftUI
import CryptoKit

@MainActor class ChatData : ObservableObject {
    @Published var assistant_id: String = "assistant_id"
    @Published var thread_id: String = "thread_id"
    @Published var run_id: String = "run_id"
    @Published var messages: [Message] = [Message]()
}

func sha256() -> String {
    let hash = SHA256.hash(data: String(Date().timeIntervalSince1970).data(using: .utf8)!)
    return hash.compactMap { String(format: "%02x", $0) }.joined()
}

struct Message: Identifiable, Equatable, Hashable {
    var id: String
    var prompt: String
    var response: String
}

struct ContentView: View {
    @StateObject var chatData = ChatData()
    
    var body: some View {
        VStack {
            ChatView(chatData: chatData)
            ListView(chatData: chatData)
            PromptView(chatData: chatData)
                .safeAreaPadding(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
