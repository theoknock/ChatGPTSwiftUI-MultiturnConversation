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
            Section {
                VStack(alignment: .leading) {
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "questionmark.bubble")
                        Text("message.prompt")
                            .font(.body)
                            .foregroundStyle(Color.secondary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.bottom)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "exclamationmark.bubble")
                        Text("message.response")
                            .font(.body)
                            .foregroundStyle(Color.primary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            .listRowSeparator(.hidden)
            ForEach(chatData.messages) { message in
                Section {
                    VStack(alignment: .leading) {
                        HStack(alignment: .firstTextBaseline) {
                            Image(systemName: "questionmark.bubble")
                            Text(message.prompt)
                                .font(.body)
                                .foregroundStyle(Color.secondary)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        
                        HStack(alignment: .firstTextBaseline) {
                            Image(systemName: "exclamationmark.bubble")
                            Text(message.response)
                                .font(.body)
                                .foregroundStyle(Color.primary)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.sidebar)
    }
}

struct ListView_Previews: PreviewProvider {
    @ObservedObject var chatData: ChatData
    
    static var previews: some View {
        ListView(chatData: ChatData())
            .preferredColorScheme(.dark)
    }
}
