//
//  ChatModel.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/21/23.
//

import Foundation
import SwiftData
import SwiftUI

@Model class ChatModel {
    var id: String
    var prompt: String
    var response: String
    
    init(id: String = sha256(), prompt: String = String(), response: String = String()) {
        self.id = id
        self.prompt = prompt
        self.response = response
    }
}
