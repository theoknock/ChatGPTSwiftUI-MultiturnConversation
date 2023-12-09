//
//  ContentView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/8/23.
//

import SwiftUI
import CryptoKit

struct PlainTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(.black) // Set the text color here
    }
}

class AssistantObject: ObservableObject {
    @Published var id: String = "Assistant ID"
}

struct AssistantKey: Codable {
    var id: String
}

class ThreadObject: ObservableObject {
    @Published var id: String = "Thread ID"
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
    @ObservedObject var assistantID = AssistantObject()
    @ObservedObject var threadID = ThreadObject()
    
    @State private var senderMessage: String = ""
    
    var body: some View {
        VStack {
            // Outer VStack
            VStack {
                // List VStack
                List {
                    GroupBox(label: Text("CHAT DATA").font(.caption2), content: {
                        TextField("", text: $assistantID.id).font(.caption)
                        TextField("", text: $threadID.id).font(.caption)
                    })
                    
                    ForEach(1...100, id: \.self) {_ in
                        Section {
                            ForEach(0...1, id: \.self) { index in
                                GroupBox(label: Text((index == 0) ? "PROMPT" : "RESPONSE").font(.caption2), content: {
                                    TextField("", text: .constant("Content"))
                                })
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                
                
                
            }
        }
        
        HStack {
            HStack {
                ZStack(alignment: .trailing) {
                    TextField("Placeholder", text: $senderMessage)
                        .padding(.all)
                        .background(Color(uiColor: UIColor.init(white: 1.0, alpha: 0.15)))
                        .foregroundColor(Color(uiColor: UIColor.lightText))
                    
                    HStack {
                        Spacer()
                        Button("Button") {
                            getAssistant(assistantID: assistantID)
                            sleep(1)
                            threadID.id = createThread(threadID)
                            sleep(1)
                            addMessage(message: senderMessage, threadID: threadID)
                        }
                        .padding(.trailing)
                    }
                }
                .background(.clear)
            }
        }
        .cornerRadius(10)
        .safeAreaPadding()
        
    }
}



func getAssistant(assistantID: AssistantObject) {
    let url = URL(string: "https://api.openai.com/v1/assistants")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
    request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
    request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
    
    let type: [Dictionary] = [["type": "code_interpreter"]]
    let assistant_request: Dictionary =
    [
        "instructions": "You are a personal math tutor. When asked a question, write and run Python code to answer the question.",
        "name": "Math Tutor",
        "tools": type,
        "model": "gpt-4"
    ] as [String : Any]
    
    let jsonData = try! JSONSerialization.data(withJSONObject: assistant_request, options: [])
    request.httpBody = jsonData
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        if error == nil && data != nil {
            do {
                if let assistant_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    let id = assistant_response["id"] as? String
                    DispatchQueue.main.async {
                        assistantID.id = id ?? "No ID"
                    }
                }
                
                
            } catch {
                print("Error")
            }
        }
    }
    
    task.resume()
}

func createThread(_ threadID: ThreadObject) -> String {
    let url = URL(string: "https://api.openai.com/v1/threads")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
    request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
    request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        if error == nil && data != nil {
            do {
                if let thread_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    let id = thread_response["id"] as? String
                    DispatchQueue.main.async {
                        threadID.id = id ?? "No thread ID"
                    }
                }
                
                
            } catch {
                print("Error")
            }
        }
    }
    
    task.resume()
    sleep(1)
    return threadID.id
}

func addMessage(message: String, threadID: ThreadObject) {
    let message_request: Dictionary = ["role": "user", "content": "\(message)"] as [String : Any]
    
    let url = URL(string: "https://api.openai.com/v1/threads/" + threadID.id + "/messages")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let jsonData = try! JSONSerialization.data(withJSONObject: message_request, options: [])
    request.httpBody = jsonData
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
    request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
    request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
    
    let session = URLSession.shared
    let task = session.dataTask(with: request) { (data, response, error) in
        if error == nil && data != nil {
            do {
                if let message_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    print("Message:\t\(message_response)")
                }
            } catch {
                print("Error")
            }
        }
    }
    
    task.resume()
}


#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}


