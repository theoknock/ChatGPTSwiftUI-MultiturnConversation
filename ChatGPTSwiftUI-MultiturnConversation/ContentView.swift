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

class GlobalData: ObservableObject {
    @Published var someGlobalData: String = "Assistant ID"
}

struct ContentView: View {
    @ObservedObject var globalData = GlobalData()
    
    var body: some View {
        VStack {
            // Outer VStack
            VStack {
                // List VStack
                List {
                    GroupBox(label: Text("ASSISTANT ID").font(.caption2), content: {
                        TextField("", text: $globalData.someGlobalData)
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
                            getAssistant(globalData: globalData)
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

struct Assistant: Codable {
    let id: String
}

func getAssistant(globalData: GlobalData) {
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
                        globalData.someGlobalData = id ?? "No ID"
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


#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}


