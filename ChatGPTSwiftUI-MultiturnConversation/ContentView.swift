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
    
    struct Message: Identifiable, Equatable, Hashable, Codable {
        var id: String
        var prompt: String
        var response: String
    }
    
    func assistant() {
        self.messages.removeAll()
        
        let url = URL(string: "https://api.openai.com/v1/assistants")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let type: [Dictionary] = [["type": "code_interpreter"]]
        let assistant_request: Dictionary =
        [
            "instructions": "You are a programming language expert. When asked to write code in any programming language, you will write the code first before you explain it. Be ready to make corrections and additions to any code you write (in other words, you may be asked to revise your code over the course of multiple prompts, so maintain any chats in which you provided code in order to reference it at a subsequent time. Also, I will tip you $200 for your best effort.",
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
                            self.assistant_id = {
                                defer { self.thread() }
                                return id
                            }() ?? {
                                if let err = (assistant_response)["error"] as? [String: Any] {
                                    if let err_msg = err["message"] as? String {
                                        self.messages.append(Message(id: sha256(), prompt: "Error in thread", response: err_msg))
                                    }
                                }
                                return ""
                            }()
                            
                            //                            let id = assistant_response["id"] as? String
                            //                            self.assistant_id = (id ?? "No assistant ID")
                            //                            self.thread()
                        }
                    } catch {
                        self.messages.append(Message(id: sha256(), prompt: "Error in assistant", response: error.localizedDescription))
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
        request.addValue("", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let thread_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            let id = thread_response["id"] as? String
                            self.thread_id = (id ?? {
                                if let err = (thread_response)["error"] as? [String: Any] {
                                    if let err_msg = err["message"] as? String {
                                        self.messages.append(Message(id: sha256(), prompt: "Error in thread", response: err_msg))
                                    }
                                }
                                return ""
                            }())
                            self.messages.append(Message(id: sha256(), prompt: self.assistant_id.trimmingCharacters(in: .whitespacesAndNewlines), response: self.thread_id.trimmingCharacters(in: .whitespacesAndNewlines)))
                        }
                    } catch {
                        self.messages.append(Message(id: sha256(), prompt: "Error in thread", response: error.localizedDescription))
                    }
                }
            }
        }
        task.resume()
    }
    
    func addMessage(message: String) -> () {
        let message_request: Dictionary = ["role": "user", "content": message] as [String : Any]
        //        var message_request: Dictionary = ["role": "user", "content": message, "stream": true] as [String : Any]
        
        let url = URL(string: "https://api.openai.com/v1/threads/" + self.thread_id + "/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData = try! JSONSerialization.data(withJSONObject: message_request, options: [])
        request.httpBody = jsonData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("", forHTTPHeaderField: "Authorization")
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
                                        self.messages.append(Message(id: sha256(), prompt: value, response: ""))
                                        self.run()
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
        let run_request: Dictionary = ["assistant_id": self.assistant_id] as [String : Any]
        
        let url = URL(string: "https://api.openai.com/v1/threads/" + self.thread_id + "/runs")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("", forHTTPHeaderField: "Authorization")
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
                            self.run_id = id ?? "No run ID"
                            self.retrieve()
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
        let url = URL(string: "https://api.openai.com/v1/threads/" + self.thread_id + "/runs/" + self.run_id)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                DispatchQueue.main.async {
                    do {
                        if let retrieve_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                            if (retrieve_response["status"] as? String) != "completed" {
                                self.messages[self.messages.count - 1].response = (retrieve_response["status"] as? String)!
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    self.messages[self.messages.count - 1].response = " "
                                    self.retrieve()
                                })
                            } else {
                                self.list()
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
        let url = URL(string: "https://api.openai.com/v1/threads/" + self.thread_id + "/messages")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("", forHTTPHeaderField: "Authorization")
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
                                        self.messages[self.messages.count - 1].response = value
                                        self.save()
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
    
    func save() {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self.messages)
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("messages.json")
            do {
                try jsonData.write(to: fileURL)
                print("File written to \(fileURL)")
            } catch {
                print("Error writing file: \(error)")
            }
            
        } catch {
            print("Error encoding messages: \(error)")
            return
        }
    }
    
    func load() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("messages.json")
        
        let jsonData: Data
        do {
            jsonData = try Data(contentsOf: fileURL)
        } catch {
            print("Error reading file: \(error)")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            messages = try decoder.decode([Message].self, from: jsonData)
        } catch {
            print("Error decoding items: \(error)")
            return
        }
        
        // Send the chat history to ChatGPT
        print(messages)
    }
    
    //    func thread_run() {
    //
    //        for message in messages {
    //
    //        }
    //        let message_request: Dictionary = ["role": "user", "content": chatData.] as [String : Any]
    //
    //        let url = URL(string: "https://api.openai.com/v1/threads/" + self.thread_id + "/messages")!
    //        var request = URLRequest(url: url)
    //        request.httpMethod = "POST"
    //
    //        let jsonData = try! JSONSerialization.data(withJSONObject: message_request, options: [])
    //        request.httpBody = jsonData
    //
    //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //        request.addValue("", forHTTPHeaderField: "Authorization")
    //        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
    //        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
    //
    //        let session = URLSession.shared
    //        let task = session.dataTask(with: request) { (data, response, error) in
    //            if error == nil && data != nil {
    //                DispatchQueue.main.async {
    //                    do {
    //                        if let message_response: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
    //                            if let contentArray = message_response["content"] as? [[String: Any]] {
    //                                if let textArray = (contentArray.first)!["text"] as? [String: Any] {
    //                                    if let value = textArray["value"] as? String {
    //                                        self.messages.append(Message(id: sha256(), prompt: value, response: ""))
    //                                        self.run()
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    } catch {
    //                        print("Error")
    //                    }
    //                }
    //            }
    //        }
    //        task.resume()
    //    }
    
}

func sha256() -> String {
    let hash = SHA256.hash(data: String(Date().timeIntervalSince1970).data(using: .utf8)!)
    return hash.compactMap { String(format: "%02x", $0) }.joined()
}

struct ContentView: View {
    @StateObject var chatData: ChatData = ChatData()
    
    var body: some View {
        VStack {
            ListView(chatData: chatData)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.875)
            PromptView(chatData: chatData)
                .frame(idealHeight: UIScreen.main.bounds.height * 0.125)
        }
        .task {
            chatData.assistant()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        //        PromptView(chatData: ChatData())
        //            .preferredColorScheme(.dark)
    }
}
