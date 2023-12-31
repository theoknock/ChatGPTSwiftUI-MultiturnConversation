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
                VStack(alignment: .leading, spacing: 0.0, content: {
                    Section {
                        Text(message.prompt)
                        ////                            .frame(width: UIScreen.main.bounds.width)
                        //                            .padding(.top)
                        //                            .foregroundStyle(Color.primary)
                        ////                            .background(Color.clear)
                        //                        //                            .background(LinearGradient(colors: [Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58)], startPoint: .top, endPoint: .bottom))
                        //                            .lineLimit(nil)
                        //                            .fixedSize(horizontal: true, vertical: false)
                        //                            .onTapGesture {
                        //                                UIPasteboard.general.string = message.prompt
                        //                            }
                        //                            .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 10.0,  bottomLeading: 0.0, bottomTrailing: 0.0, topTrailing: 10.0), style: .continuous))
                        
                    }.listRowSeparator(.hidden)
                    //                        .padding()
                    //                        .background(LinearGradient(gradient: Gradient(colors: [Color.init(uiColor: .systemBlue), Color.clear]), startPoint: .leading, endPoint: .trailing))
                    //                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
                    //                        .listRowInsets(.init(top: 0, leading: 100, bottom: 0, trailing: 0))
                    
                    Section {
                        Text(message.response)
                        ////                            .frame(idealWidth: UIScreen.main.bounds.width)
                        //                            .padding(.bottom)
                        //                            .foregroundStyle(Color.primary)
                        ////                            .background(Color.clear)
                        //                        //                            .background(LinearGradient(colors: [Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58)], startPoint: .bottom, endPoint: .top))
                        //                            .lineLimit(nil)
                        //                            .fixedSize(horizontal: true, vertical: false)
                        //                            .onTapGesture {
                        //                                UIPasteboard.general.string = message.response
                        //                            }
                        //                            .clipShape(UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 0.0,  bottomLeading: 10.0, bottomTrailing: 10.0, topTrailing: 0.0), style: .continuous))
                        //
                        //
                        //
                    }.listRowSeparator(.hidden)
                    //                        .padding()
                    //                        .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.clear]), startPoint: .leading, endPoint: .trailing))
                    //                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10), style: .continuous))
                })
                .background(Color.clear)
            }
            
        }
        .listStyle(.plain)
        .background(Color.clear)
        
        //        .background(LinearGradient(gradient: .init(colors: [Color(hue: 0.5916666667, saturation: 1.0, brightness: 0.27), Color(hue: 0.5861111111, saturation: 0.55, brightness: 0.58)]), startPoint: .topTrailing, endPoint: .bottomLeading))
        
        //                        .listSectionSpacing(0)
        
        
        
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
