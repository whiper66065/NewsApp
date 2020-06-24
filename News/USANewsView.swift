//
//  USANewsView.swift
//  News
//
//  Created by 潘昱任 on 2020/6/16.
//  Copyright © 2020 ntouyujen. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit

struct USANewsView: View {
    @ObservedObject var list = getUSANewsData()
        
        var body: some View {
            
            
             
                List(list.datas){ i in
                    
                    NavigationLink (destination:
                        
                    USANewswebView(url: i.url)
                        .navigationBarTitle("", displayMode: .inline)) {
                        
                        HStack (spacing: 15) {
                         
                            VStack (alignment: .leading, spacing: 10) {
                                
                                Text(i.title)
                                    .fontWeight(.heavy)
                                Text(i.desc)
                                .lineLimit(2)
                                
                            }
                            
                            if i.image != ""{
                                
                                WebImage(url: URL(string: i.image)!, options: .highPriority, context: nil)
                                .resizable()
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.red, lineWidth: 4))
                                
                                
                            }
                            
                        }.padding(.vertical, 15)
                    }
                }.navigationBarTitle("國際新聞")
            
        }
    }

struct USANewsView_Previews: PreviewProvider {
    static var previews: some View {
        USANewsView()
    }
}


struct USANewsdataType : Identifiable {
    
    var id : String
    var title : String
    var desc : String
    var url : String
    var image : String
}

class getUSANewsData : ObservableObject {
    
    @Published var datas = [USANewsdataType]()
    
    init() {
        
        let source = "https://newsapi.org/v2/top-headlines?country=us&apiKey=ff178e0f80a34c8da6ad52166a2b73ee"
        
        let url = URL(string: source)!
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, _, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            let json = try! JSON(data: data!)
            
            for i in json["articles"]{
                
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url = i.1["url"].stringValue
                let image = i.1["urlToImage"].stringValue
                let id = i.1["publishedAt"].stringValue
                
                DispatchQueue.main.async {
                    self.datas.append(USANewsdataType(id: id, title: title, desc: description, url: url, image: image))
                }
            }
        }.resume()
    }
}

struct USANewswebView : UIViewRepresentable {
    
    var url : String
    
    func makeUIView(context: UIViewRepresentableContext<USANewswebView>) -> WKWebView{
        
        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<USANewswebView>) {
        
    }
}
