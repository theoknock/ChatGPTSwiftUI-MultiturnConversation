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
}

struct AssistantKey: Codable {
    var id: String
}

struct ThreadKey: Codable {
    var id: String
}

struct RunKey: Codable {
    var id: String
}

func sha256() -> String {
    let hash = SHA256.hash(data: String(Date().timeIntervalSince1970).data(using: .utf8)!)
    return hash.compactMap { String(format: "%02x", $0) }.joined()
}

enum MessageType {
    case prompt
    case response
}

struct Message: Identifiable, Equatable, Hashable {
    let id: String = sha256()
    let text: String
    let type: MessageType
}

struct Completion: Identifiable, Equatable, Hashable {
    var id: String          = sha256()
    var date: String        = Date().description
    var messages: [Message] = [Message]()
}

struct ContentView: View {
    @State private var senderMessage: String = ""
    @StateObject var chatData = ChatData()
    
    var body: some View {
        VStack {
            ListView()
                .border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            PromptView()
                .border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        }
        .environmentObject(chatData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
