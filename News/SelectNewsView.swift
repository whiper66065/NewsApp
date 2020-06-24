//
//  SelectNewsView.swift
//  News
//
//  Created by 潘昱任 on 2020/6/15.
//  Copyright © 2020 ntouyujen. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit
import SafariServices

struct SelectNewsView: View {
    
    @State private var rotateDegree: Double = 0
    @State var showTWSafari = false
    @State var TWNewsUrlString = "https://www.youtube.com/watch?v=Hu1FkdAOws0"
    @State var showUSSafari = false
    @State var USNewsUrlString = "https://www.youtube.com/watch?v=w_Ma8oQLmSM"
    
    var body: some View {
        
                NavigationView {
                    ZStack{
                        Image("goodview")
                            .resizable()
                        
                        
                        
                      VStack {
                        
                        Button(action: {
                            self.rotateDegree = 360
                        }){
                            Image("newslogo")
                            
                            .rotationEffect(.degrees(rotateDegree))
                            .animation(
                              Animation.linear(duration: 3)
                               .repeatCount(1, autoreverses: false)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                         NavigationLink(destination: ContentView()) {
                             Text("國內文字新聞")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                           
                         }
                        
                        HStack {
                            Text("➡️")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            
                            
                            Button(action: {
                                    self.TWNewsUrlString = "https://www.youtube.com/watch?v=Hu1FkdAOws0"
                                    self.showTWSafari = true
                             }){
                                Text("TVBS News直播")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                               
                                
                            }.sheet(isPresented: $showTWSafari) {
                                TWSafariView(TWurl:URL(string: self.TWNewsUrlString)!)
                            }
                            
                            
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: USANewsView()) {
                            Text("國外文字新聞")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                            
                        }
                        
                        HStack {
                            Text("➡️")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            
                            
                            Button(action: {
                                    self.USNewsUrlString = "https://www.youtube.com/watch?v=w_Ma8oQLmSM"
                                    self.showUSSafari = true
                             }){
                                Text("ABC News直播")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                                
                                
                            }.sheet(isPresented: $showUSSafari) {
                                USSafariView(USurl:URL(string: self.USNewsUrlString)!)
                            }
                        }
                       }
                        .frame(width: 300, height: 200)
                       .navigationBarTitle("今天想看什麼新聞？")
                }
        }
    }
}

struct SelectNewsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectNewsView()
    }
}


struct TWSafariView: UIViewControllerRepresentable {

    let TWurl: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<TWSafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: TWurl)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<TWSafariView>) {

    }

}

struct USSafariView: UIViewControllerRepresentable {

    let USurl: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<USSafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: USurl)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<USSafariView>) {

    }

}

