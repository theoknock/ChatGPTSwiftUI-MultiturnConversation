//
//  ContentView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/8/23.
//

import SwiftUI

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
    let id: String
}

class ThreadObject: ObservableObject {
    @Published var id: String = "Thread ID"
}

struct ThreadKey: Codable {
    let id: String
}

struct ContentView: View {
    @ObservedObject var assistantID = AssistantObject()
    @ObservedObject var threadID = ThreadObject()
    
    var body: some View {
        VStack {
            // Outer VStack
            VStack {
                // List VStack
                List {
                    GroupBox(label: Text("ASSISTANT ID").font(.caption2), content: {
                        TextField("", text: $assistantID.id)
                        TextField("", text: $threadID.id)
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
                
                
                
            }
        }
        
        HStack {
            HStack {
                ZStack(alignment: .trailing) {
                    TextField("Placeholder", text: .constant(""))
                        .padding(.all)
                        .background(Color(uiColor: UIColor.init(white: 1.0, alpha: 0.15)))
                        .foregroundColor(Color(uiColor: UIColor.lightText))
                    
                    HStack {
                        Spacer()
                        Button("Button") {
                            getAssistant(assistantID: assistantID)
                            createThread(threadID: threadID)
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
    request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
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
                    print("id:\t\(id ?? "")")
                    DispatchQueue.main.async {
                        assistantID.id = id ?? "No ID"
                    }
                    print(assistant_response)
                }
            
                
            } catch {
                print("Error")
            }
        }
    }
    
    task.resume()
}

func createThread(threadID: ThreadObject) {
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
            do {
                if let thread_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        let id = thread_response["id"] as? String
                    print("Thread id:\t\(id ?? "")")
                    DispatchQueue.main.async {
                        threadID.id = id ?? "No thread ID"
                    }
                    print(thread_response)
                }
            
                
            } catch {
                print("Error")
            }
        }
    }
    
    task.resume()
    
    // Response
    //
    /*
     {
       "id": "thread_abc123",
       "object": "thread",
       "created_at": 1698107661,
       "metadata": {}
     }
     */
}


#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}


