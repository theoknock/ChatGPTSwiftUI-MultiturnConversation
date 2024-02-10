//
//  SwiftUIView.swift
//  ChatGPTSwiftUI-MultiturnConversation
//
//  Created by Xcode Developer on 12/27/23.
//

import SwiftUI

public struct P190_GlassShape: View {
    
    public init() {}
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.clear
                GlassBackground()
                ZStack {
                    CardView()
                        .overlay(
                            CardOverlayView(chatData: ChatData())
                        )
                        .cornerRadius(16)
                }
                
            }
        }
    }
}

fileprivate
struct GlassBackground: View {
    var body: some View {
        GeometryReader { proxy in
            Circle()
                .fill(LinearGradient(colors: [Color.white,
                                              Color(#colorLiteral(red: 0.8745391965, green: 0.8059151769, blue: 0.5692914128, alpha: 1))],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .frame(width: 160, height: 160)
                .position(x: proxy.size.width * 0.3, y: proxy.size.height * 0.65)
            
            Circle()
                .fill(LinearGradient(colors: [Color(#colorLiteral(red: 0.4453554153, green: 0.8331344724, blue: 0.9538539052, alpha: 1)),
                                              Color(#colorLiteral(red: 0.3030822277, green: 0.6314095855, blue: 0.9446666241, alpha: 1))],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .frame(width: 280, height: 280)
                .position(x: proxy.size.width * 0.6, y: proxy.size.height * 0.4)
            
            Circle()
                .fill(LinearGradient(colors: [Color(#colorLiteral(red: 0.7405367494, green: 0.361433506, blue: 0.5888115168, alpha: 1)),
                                              Color(#colorLiteral(red: 0.8903778791, green: 0.4748723507, blue: 0.3938084245, alpha: 1))],
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing))
                .frame(width: 100, height: 100)
                .position(x: proxy.size.width * 0.7, y: proxy.size.height * 0.65)
        }
        .background(LinearGradient(colors: [Color.white, Color(uiColor: UIColor(Color(hue: 214.0/360.0, saturation: 0.76, brightness: 0.74)))],
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
    }
}

fileprivate
struct CardView: View {
    var body: some View {
        if #available(macOS 12.0, *) {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 300, height: 200)
                .background(.ultraThinMaterial)
        } else {
            Rectangle()
                .fill(Color.clear)
                .frame(width: 300, height: 200)
                .background(Color.white.opacity(0.6))
        }
    }
}

fileprivate
struct CardOverlayView: View {
    @ObservedObject var chatData: ChatData
    @State private var prompt: String = String()
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack {
            
            VStack {
                VStack(alignment: .leading) {
                    HStack {
                        HStack {
                            TextField(("Message ChatGTP..."), text: $prompt, axis: .vertical)
                                .padding()
                                .focused($isTextFieldFocused)
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                        }
                        
                        
                        HStack {
                            Button(action: {
                                Task {
                                    let prompt_tidy = prompt.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                                    prompt = prompt_tidy
                                    chatData.addMessage(message: prompt_tidy)
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                    prompt = String()
                                }
                            }, label: {
                                Label("", systemImage: "arrow.up.circle")
                                    .foregroundColor(Color.init(uiColor: UIColor(white: 1.0, alpha: 0.3125))) // isTextFieldFocused ? Color.white : Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2)))
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                    .labelStyle(.iconOnly)
        //                            .clipShape(Circle())
                            })
                            .background(
                                Circle()
                                    .fill(Color(#colorLiteral(red: 0.2714048326, green: 0.3794743717, blue: 0.5048485994, alpha: 1)))
                                    .modifier(NeumorphismModifier())
                            )
                            
                        }
                        .ignoresSafeArea()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(LinearGradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0), Color.white.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                        )
                        
        //                .background(
        //                    RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous)
        //                        .fill(Color(#colorLiteral(red: 0.2714048326, green: 0.3794743717, blue: 0.5048485994, alpha: 1)))
        //                        .modifier(NeumorphismModifier())
        //                )
                        //                .background(
                        //                    RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous)
                        //                        .fill(Color(#colorLiteral(red: 0.2714048326, green: 0.3794743717, blue: 0.5048485994, alpha: 1)))
                        //                        .modifier(NeumorphismModifier())
                        //                )
                        //                .clipShape(/*RoundedRectangle(cornerSize: CGSize(width: 25, height: 25), style: .continuous)*/)
                    }
                    
                }
                .foregroundColor(Color.white.opacity(0.5))
            }
        }
//        .frame(idealWidth: UIScreen.main.bounds.width, idealHeight: UIScreen.main.bounds.height * 0.125)
//        .fixedSize(horizontal: false, vertical: true)
//        .safeAreaPadding(.bottom)
    }
}

struct P190_GlassShape_Previews: PreviewProvider {
    static var previews: some View {
        P190_GlassShape()
    }
}
