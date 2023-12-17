//
//  MessagesItem.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/15/23.
//

import Foundation
import SwiftData

@Model
final class Chat {
    let timestamp: Date
    let id: String
    var prompt: String = String()
    var response: String = String()

    init(prompt: String, response: String) {
        self.timestamp = Date.now
        self.id        = sha256()
        self.prompt    = prompt
        self.response  = response
    }
}
