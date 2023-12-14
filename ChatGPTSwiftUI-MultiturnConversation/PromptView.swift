//
//  PromptView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/9/23.
//

import SwiftUI
import Foundation

struct PromptView: View {
    @State private var senderMessage: String = ""
    @State private var chatMessage: Message = Message(id: sha256(), prompt: "", response: "")
    
    @ObservedObject var chatData : ChatData
    
    var body: some View {
        HStack {
            HStack {
                TextField("Message ChatGPT...", text: $senderMessage)
                    .foregroundColor(Color.primary)
                    .safeAreaPadding(.all)
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                Button("Send") {
                    Task {
                        addMessage(message: senderMessage.trimmingCharacters(in: .whitespacesAndNewlines))
                        senderMessage = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .safeAreaPadding(.trailing)
                .buttonStyle(.bordered)
            }
            
        }
        
        .background(Color(uiColor: .quaternarySystemFill))
        .task {
            assistant()
            thread()
        }
    }
    
    func assistant() {
        let url = URL(string: "https://api.openai.com/v1/assistants")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let type: [Dictionary] = [["type": "code_interpreter"]]
        let assistant_request: Dictionary =
        [
            "instructions": "You are a programming language expert. When asked to write code in any programming language, you will write the code first before you explain it.",
            "name": "Code Expert",
            "tools": type,
            "model": "gpt-4"
        ] as [String : Any]
        
        let jsonData = try! JSONSerialization.data(withJSONObject: assistant_request, options: [])
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let assistant_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            let id = assistant_response["id"] as? String
                            chatData.assistant_id = id ?? "No assistant ID"
                            
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
    }
    
    func thread() {
        let url = URL(string: "https://api.openai.com/v1/threads")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let thread_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            let id = thread_response["id"] as? String
                            chatData.thread_id = id ?? "No thread ID"
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
    }
    
    func addMessage(message: String) -> () {
        let message_request: Dictionary = ["role": "user", "content": message] as [String : Any]
        
        let url = URL(string: "https://api.openai.com/v1/threads/" + chatData.thread_id + "/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData = try! JSONSerialization.data(withJSONObject: message_request, options: [])
        request.httpBody = jsonData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let message_response: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            if let contentArray = message_response["content"] as? [[String: Any]] {
                                    if let textArray = (contentArray.first)!["text"] as? [String: Any] {
                                        if let value = textArray["value"] as? String {
                                            chatData.messages.append(Message(id: sha256(), prompt: value, response: ""))
                                            run()
                                        }
                                    }
                            }
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
    }
    
    func run() -> () {
        let run_request: Dictionary = ["assistant_id": chatData.assistant_id] as [String : Any]
        
        let url = URL(string: "https://api.openai.com/v1/threads/" + chatData.thread_id + "/runs")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: run_request, options: [])
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let run_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            let id = run_response["id"] as? String
                            chatData.run_id = id ?? "No run ID"
                            retrieve()
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
    }
    
    func retrieve() {
        let url = URL(string: "https://api.openai.com/v1/threads/" + chatData.thread_id + "/runs/" + chatData.run_id)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let retrieve_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            if (retrieve_response["status"] as? String) != "completed" {
                                chatData.messages[chatData.messages.count - 1].response = (retrieve_response["status"] as? String)!
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    chatData.messages[chatData.messages.count - 1].response = ""
                                    retrieve()
                                })
                            } else {
                                list()
                            }
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
    }
    
    func list() {
        let url = URL(string: "https://api.openai.com/v1/threads/" + chatData.thread_id + "/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let list_response: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            if let dataArray = list_response["data"] as? [[String: Any]] {
                                if let contentArray = (dataArray.first)!["content"] as? [[String: Any]] {
                                    if let textArray = (contentArray.first)!["text"] as? [String: Any] {
                                        let value = textArray["value"] as! String
                                        chatData.messages[chatData.messages.count - 1].response = value
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Error")
                    }
                }
            }
        }
        task.resume()
    }
}
