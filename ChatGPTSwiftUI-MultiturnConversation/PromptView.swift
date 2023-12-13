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
    @EnvironmentObject var chatData : ChatData
    
    var body: some View {
        HStack {
            //            ZStack(alignment: .trailing) {
            HStack {
                TextField("Message ChatGPT...", text: $senderMessage)
                    .foregroundColor(Color.primary)
                    .safeAreaPadding(.all)
                    .textFieldStyle(.roundedBorder)
            }
            HStack {
                Button("", systemImage: "play") {
                    addMessage(message: senderMessage)
                }
                .safeAreaPadding(.trailing)
                .buttonStyle(.bordered)
            }
            
        }
        .background(Color(uiColor: .quaternarySystemFill))
        .task {
            do {
                try await assistant()
            } catch {
                print("Error")
            }
            
            do {
                try await thread()
            } catch {
                print("Error")
            }
        }
    }
    
    func assistant() async throws -> () {
        let url = URL(string: "https://api.openai.com/v1/assistants")!
        //print(url)
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
        let task = try await session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                do {
                    if let assistant_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        //                        //print(assistant_response)
                        let id = assistant_response["id"] as? String
                        chatData.assistant_id = id ?? "No ID"
                        //print(assistant_response)
                        
                    }
                    
                } catch {
                    //print("Error")
                }
            }
        }
        task.resume()
    }
    
    func thread() async throws -> () {
        let url = URL(string: "https://api.openai.com/v1/threads")!
        //print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = try await session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                do {
                    if let thread_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        let id = thread_response["id"] as? String
                        DispatchQueue.main.async {
                            chatData.thread_id = id ?? "No thread ID"
                        }
                    }
                    
                    
                } catch {
                    print("Error")
                }
            }
        }
        
        task.resume()
    }
    
    func addMessage(message: String) {
        let message_request: Dictionary = ["role": "user", "content": message] as [String : Any]
        
        let url = URL(string: "https://api.openai.com/v1/threads/" + chatData.thread_id + "/messages")!
        //print(url)
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
                        //                        //print("Message:\t\(message_response)")
                        print(message_request)
                        print("----------------")
                        print(message_response)
                        run()
                    }
                } catch {
                    //print("Error")
                }
            }
        }
        
        task.resume()
    }
    
    func run() -> () {
        let run_request: Dictionary = ["assistant_id": chatData.assistant_id] as [String : Any]
        
        let url = URL(string: "https://api.openai.com/v1/threads/" + chatData.thread_id + "/runs")!
        //print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let jsonData = try! JSONSerialization.data(withJSONObject: run_request, options: [])
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                do {
                    if let run_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        let id = run_response["id"] as? String
                        DispatchQueue.main.async {
                            chatData.run_id = id ?? "No run ID"
                            //print(run_response)
                            retrieve()
                        }
                    }
                    
                    
                } catch {
                    //print("Error")
                }
            }
        }
        
        task.resume()
    }
    
    func retrieve() -> () {
        let url = URL(string: "https://api.openai.com/v1/threads/" + chatData.thread_id + "/runs/" + chatData.run_id)!
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                do {
                    if let retrieve_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        let delayInSeconds = 5.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                            print("\nList response:\t\(retrieve_response)\n")
                            list()
                        }
                        
                    }
                } catch {
                    //print("Error")
                }
            }
        }
        
        task.resume()
    }
    
    /// <#Description#>
    /// - Returns: <#description#>
    func list() -> () {
        let url = URL(string: "https://api.openai.com/v1/threads/" + chatData.thread_id + "/messages")!
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                do {
                    if let list_response: [String: Any] = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        let delayInSeconds = 5.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                            print("\nList response:\t\(list_response)\n")
                            DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
                                print("\nList response:\t\(list_response)\n")
                            }
                        }
                        
                    }
                    
                    
                } catch {
                    //print("Error")
                }
            }
        }
        
        task.resume()
    }
    
    func fast(message: String) -> () {
        /*
         https://api.openai.com/v1/threads/runs \
         -H "Authorization: Bearer $OPENAI_API_KEY" \
         -H "Content-Type: application/json" \
         -H "OpenAI-Beta: assistants=v1" \
         -d '{
         "assistant_id": "asst_abc123",
         "thread": {
         "messages": [
         {"role": "user", "content": "Explain deep learning to a 5 year old."}
         ]
         }
         }'
         */
        
        /*
         var payload: [String: Any] = [
         "model": "gpt-4",
         "messages": [[String: Any]](),
         "temperature": 1,
         "max_tokens": 256,
         "top_p": 1,
         "frequency_penalty": 0,
         "presence_penalty": 0
         ]
         var message_values: [String]
         for message in messages {
         let role = message.type == .prompt ? "user" : "assistant"
         let messageDict = ["role": "\(role)", "content": "\(message.text)"]
         //            payload.app/end(messageDict)
         }
         */
        
        let assistant_dict: Dictionary = ["assistant_id": "\(chatData.assistant_id)"] as [String : Any]
        let message_dict: [Dictionary] = [["role": "user", "content": "\(message)"]]
        var messages_dict: Dictionary = ["messages": [Dictionary<String, Any>]()] as [String : Any]
        messages_dict.updateValue(message_dict, forKey: "messages")
        let thread_dict: Dictionary = ["thread": [messages_dict]] as [String : Any]
        
        //        let fast_request: [String: Any] = [
        //            "assistant_id": "\(chatData.assistant_id)",
        //            "thread": thread_dict["thread"]!
        //        ]
        
        var fast_request: [String: Any] = [
            "assistant_id": (chatData.assistant_id),
            "thread": [[[String: Any]]]()
        ]
        fast_request.updateValue("\(chatData.assistant_id)", forKey: "assistant_id")
        fast_request.updateValue(messages_dict, forKey: "thread")
        //print(fast_request)
        
        let url = URL(string: "https://api.openai.com/v1/threads/" + chatData.thread_id + "/messages")!
        //print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData = try! JSONSerialization.data(withJSONObject: fast_request, options: [])
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
                        //                        //print("Message:\t\(message_response)")
                        //print(message_response)
                        list()
                    }
                } catch {
                    //print("Error")
                }
            }
        }
        
        task.resume()
    }
}

#Preview {
    PromptView()
        .preferredColorScheme(.dark)
        .environmentObject(ChatData())
}
