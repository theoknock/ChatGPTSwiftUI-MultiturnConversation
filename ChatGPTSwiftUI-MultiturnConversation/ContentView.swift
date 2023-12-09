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
}

struct AssistantKey: Codable {
    var id: String
}

struct ThreadKey: Codable {
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


//func getAssistant(assistantID: String) {
//    let url = URL(string: "https://api.openai.com/v1/assistants")!
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
//    request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
//    request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
//
//    let type: [Dictionary] = [["type": "code_interpreter"]]
//    let assistant_request: Dictionary =
//    [
//        "instructions": "You are a personal math tutor. When asked a question, write and run Python code to answer the question.",
//        "name": "Math Tutor",
//        "tools": type,
//        "model": "gpt-4"
//    ] as [String : Any]
//
//    let jsonData = try! JSONSerialization.data(withJSONObject: assistant_request, options: [])
//    request.httpBody = jsonData
//
//    let session = URLSession.shared
//    let task = session.dataTask(with: request) { (data, response, error) in
//        if error == nil && data != nil {
//            do {
//                if let assistant_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
//                    let id = assistant_response["id"] as? String
//                    DispatchQueue.main.async {
//                        assistant_id = id ?? "No ID"
//                    }
//                }
//
//
//            } catch {
//                print("Error")
//            }
//        }
//    }
//
//    task.resume()
//}
//
//func createThread(_ threadID: String) -> String {
//    let url = URL(string: "https://api.openai.com/v1/threads")!
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
//    request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
//    request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
//
//    let session = URLSession.shared
//    let task = session.dataTask(with: request) { (data, response, error) in
//        if error == nil && data != nil {
//            do {
//                if let thread_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
//                    let id = thread_response["id"] as? String
//                    DispatchQueue.main.async {
//                        thread_id = id ?? "No thread ID"
//                    }
//                }
//
//
//            } catch {
//                print("Error")
//            }
//        }
//    }
//
//    task.resume()
//    sleep(1)
//    return thread_id
//}
//
//func addMessage(message: String, threadID: String) {
//    let message_request: Dictionary = ["role": "user", "content": "\(message)"] as [String : Any]
//
//    let url = URL(string: "https://api.openai.com/v1/threads/" + thread_id + "/messages")!
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//
//    let jsonData = try! JSONSerialization.data(withJSONObject: message_request, options: [])
//    request.httpBody = jsonData
//
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
//    request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
//    request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
//
//    let session = URLSession.shared
//    let task = session.dataTask(with: request) { (data, response, error) in
//        if error == nil && data != nil {
//            do {
//                if let message_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
//                    print("Message:\t\(message_response)")
//                }
//            } catch {
//                print("Error")
//            }
//        }
//    }
//
//    task.resume()
//}
