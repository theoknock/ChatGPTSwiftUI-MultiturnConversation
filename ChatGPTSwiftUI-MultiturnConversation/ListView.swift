//
//  ListView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/9/23.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var chatData: ChatData

    var body: some View {
        List {
            ForEach(chatData.messages) { message in
                Section {
                    VStack(alignment: .leading) {
                        HStack(alignment: .firstTextBaseline) {
                            Image(systemName: "questionmark.bubble")
                            Text(message.prompt)
                                .font(.body)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)

                        HStack(alignment: .firstTextBaseline) {
                            Image(systemName: "exclamationmark.bubble")
                            Text(message.response)
                                .font(.body)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                }
            }
        }
        .listStyle(.grouped)
        .listRowSeparator(.visible)
    }
}
