#  Code Cemetary

```func fast(message: String) {
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
        ////print(fast_request)
        
        let url = URL(string: "https://api.openai.com/v1/threads/" + chatData.thread_id + "/messages")!
        ////print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let jsonData = try! JSONSerialization.data(withJSONObject: fast_request, options: [])
        request.httpBody = jsonData
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer ", forHTTPHeaderField: "Authorization")
        request.addValue("org-jGOqXYFRJHKlnkff8K836fK2", forHTTPHeaderField: "OpenAI-Organization")
        request.addValue("assistants=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                do {
                    if let message_response = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                        list()
                    }
                } catch {
                    ////print("Error")
                }
            }
        }
        
        task.resume()
    }```
    



    
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



    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        VStack {
//                            Text("Chat \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                            MainView(chatData: chatData)
//                        }
//                    } label: {
//                        //                        MainView(chatData: chatData)
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("New Chat", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select a chat")
//        }
    }




//    func saveChat() {
//        let id = ChatModel(id: chatData.messages.last!.id)
//        let prompt = ChatModel(id: chatData.messages.last!.prompt)
//        let response = ChatModel(id: chatData.messages.last!.response)
//
//        modelContext.insert(id)
//        modelContext.insert(prompt)
//        modelContext.insert(response)
//    }
