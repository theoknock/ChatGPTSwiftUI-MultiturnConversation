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
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "questionmark.bubble")
                            .foregroundColor(Color.blue)
                        Text(message.prompt)
                            .foregroundStyle(Color.primary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: UIScreen.main.bounds.width)
                    }
                    .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.1)))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
                    .safeAreaPadding(.horizontal)
//                    .frame(maxWidth: UIScreen.main.bounds.width * 0.75, alignment: .topTrailing)
//                    .padding(.leading, UIScreen.main.bounds.width * 0.15)
                }
                .listSectionSpacing(.compact)
                .listRowBackground(
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous)
                        .foregroundStyle(Color.init(uiColor: .tertiarySystemFill))
                        .padding(.leading, UIScreen.main.bounds.width * 0.15)
                        .shadow(color: Color.init(uiColor: .darkText), radius: 3, x: 1, y: 1)
                )
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
                
                Section {
                    HStack(alignment: .firstTextBaseline) {
                        Image(systemName: "exclamationmark.bubble")
                            .foregroundColor(Color.green)
                        
                        Text(message.response)
                            .foregroundStyle(Color.primary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.75)
                    }
                    .background(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.1)))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
                    .safeAreaPadding(.horizontal)
//                    .frame(maxWidth: UIScreen.main.bounds.width * 0.15, alignment: .topLeading)
                }
                .listSectionSpacing(.compact)
                .listRowBackground(
                    RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous)
                        .foregroundStyle(Color.init(uiColor: .tertiarySystemFill))
                        .padding(.trailing, UIScreen.main.bounds.width * 0.15)
                        .shadow(color: Color.init(uiColor: .darkText), radius: 3, x: 2, y: 2)
                )
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.grouped)
    }
}

struct ListView_Previews: PreviewProvider {
    @ObservedObject var chatData: ChatData
    
    static var previews: some View {
        ListView(chatData: ChatData())
            .preferredColorScheme(.dark)
    }
}
