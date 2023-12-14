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
        request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
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
    

