//
//  RAndMView.swift
//  News
//
//  Created by 潘昱任 on 2020/6/10.
//  Copyright © 2020 ntouyujen. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI
import WebKit

struct RAndMView: View {
    
    @ObservedObject var ricklist = getCharacterData()
    
    var body: some View {
        
        List(ricklist.datas){ c in
            HStack {
                
                if c.image != ""{
                    
                    WebImage(url: URL(string: c.image)!, options: .highPriority, context: nil)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.red, lineWidth: 4))
                }
                
                Spacer()
                
//                VStack (alignment: .leading, spacing: 30) {
//
//                    Text(c.name)
//                    .fontWeight(.heavy)
//                    Text(c.status)
//                    .fontWeight(.heavy)
//                    Text(c.species)
//                    .fontWeight(.heavy)
//                    Text(c.gender)
//                    .fontWeight(.heavy)
//                }
//                .background(Color.yellow)
                Text(c.name)
                .fontWeight(.heavy)
                
            }
        }
    }
}

struct RAndMView_Previews: PreviewProvider {
    static var previews: some View {
        RAndMView()
    }
}

struct Character: Identifiable {
    let id: String
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
}

class getCharacterData : ObservableObject {
    
    @Published var datas = [Character]()
    
    init() {
        
        let source = "https://rickandmortyapi.com/api/character/"
        
        let url = URL(string: source)!
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, _, err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            let json = try! JSON(data: data!)
            
            for c in json["results"]{
                
                let id = c.1["id"].stringValue
                let name = c.1["name"].stringValue
                let status = c.1["status"].stringValue
                let species = c.1["species"].stringValue
                let gender = c.1["gender"].stringValue
                let image = c.1["image"].stringValue
                
                DispatchQueue.main.async {
                    self.datas.append(Character(id: id, name: name, status: status, species: species, gender: gender, image: image))
                }
            }
        }.resume()
    }
}


struct RickwebView : UIViewRepresentable {
    
    var url : String
    func makeUIView(context: UIViewRepresentableContext<RickwebView>) -> WKWebView {
        let view = WKWebView()
        view.load(URLRequest(url: URL(string: url)!))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<RickwebView>) {
        
    }
}
