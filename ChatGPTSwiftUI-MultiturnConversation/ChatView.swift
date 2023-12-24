//
//  ListView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/9/23.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var chatData: ChatData
    
    var body: some View {
        List {
            ForEach(chatData.messages) { message in
                Section {
                    HStack(alignment: .firstTextBaseline) {
                        Text(message.prompt)
                            .foregroundStyle(Color.primary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .onTapGesture {
                                UIPasteboard.general.string = message.prompt
                            }
                    }
                }.listRowSeparator(.hidden)
                .padding()
//                .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.1)))
                .background(LinearGradient(gradient: Gradient(colors: [Color.init(uiColor: .systemBlue), Color.clear]), startPoint: .leading, endPoint: .trailing))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
                .listRowInsets(.init(top: 0, leading: 100, bottom: 0, trailing: 0))
                
                Section {
                    HStack(alignment: .firstTextBaseline) {
                        Text(message.response)
                            .foregroundStyle(Color.primary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .onTapGesture {
                                UIPasteboard.general.string = message.response
                            }
                    }
                }.listRowSeparator(.hidden)
                .padding()
//                .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.1)))
                .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.clear]), startPoint: .leading, endPoint: .trailing))
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
                
            }
        }
        .listStyle(.plain)
        .listSectionSpacing(0)
        .task {
            chatData.assistant()
        }
        
        
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatData: ChatData())
            .preferredColorScheme(.dark)
    }
}

/*
 .padding()
 .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.3)))
 .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
 */
