//
//  UnsplashView.swift
//  News
//
//  Created by 潘昱任 on 2020/6/9.
//  Copyright © 2020 ntouyujen. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct UnsplashView: View {
    var body: some View {
        
        Main()
    }
}

struct UnsplashView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Main : View {
    
    @State var expand = false
    @State var search = ""
    @ObservedObject var RandomImages = getUnsplashData()
    @State var page = 1
    @State var isSearching = false
    
    var body: some View{
        
        VStack(spacing: 0){
            
            HStack{
                
                // 搜尋欄展開會關掉標頭View
                
                if !self.expand{
                    
                    VStack(alignment: .leading, spacing: 8) {
                        
                        Text("UnSplash")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                        
                        Text("美好的圖片都在這")
                            .font(.caption)
                    }
                    .foregroundColor(.black)
                }

                
                Spacer(minLength: 0)
                
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        
                        withAnimation{
                            
                            self.expand = true
                        }
                }
                
                // 搜尋欄展開出現textfield
                
                if self.expand{
                    
                    TextField("想找什麼圖片...", text: self.$search)
                    
                    // 出現關閉x的按鈕
                    
                    // 搜尋的textfield有輸入字後才出現搜尋的按鈕
                    
                    if self.search != ""{
                        
                        Button(action: {
                            
                            
                            self.RandomImages.Images.removeAll()
                            
                            self.isSearching = true
                            
                            self.page = 1
                            
                            self.SearchData()
                            
                        }) {
                            
                            Text("搜尋")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    
                    Button(action: {
                        
                        withAnimation{
                            
                            self.expand = false
                        }
                        
                        self.search = ""
                        
                        if self.isSearching{
                            
                            self.isSearching = false
                            self.RandomImages.Images.removeAll()
                            
                            self.RandomImages.updateData()
                        }
                        
                    }) {
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.black)
                    }
                    .padding(.leading,10)
                }
                
            }
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .padding()
            .background(Color.white)
            
            if self.RandomImages.Images.isEmpty{
                
                
                Spacer()
                
                if self.RandomImages.noresults{
                    
                    Text("找不到您想要的圖片...")
                }
                else{
                    
                    Indicator()
                }
                
                Spacer()
            }
            else{
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    
                    
                    VStack(spacing: 15){
                        
                        ForEach(self.RandomImages.Images,id: \.self){ i in
                            
                            HStack(spacing: 20){
                                
                                ForEach(i){j in
                                    
                                    AnimatedImage(url: URL(string: j.urls["thumb"]!))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    // padding on both sides 30 and spacing 20 = 50
                                        .frame(width: (UIScreen.main.bounds.width - 50) / 2, height: 180)
                                    .cornerRadius(15)
                                    .contextMenu {
                                            
                                        
                                        
                                        Button(action: {
                                            
                                            
                                            SDWebImageDownloader().downloadImage(with: URL(string: j.urls["small"]!)) { (image, _, _, _) in
                                                
                                            
                                                UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
                                            }
                                            
                                        }) {
                                            
                                            HStack{
                                                
                                                Text("儲存")
                                                
                                                Spacer()
                                                
                                                Image(systemName: "square.and.arrow.down.fill")
                                            }
                                            .foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        if !self.RandomImages.Images.isEmpty{
                            
                            if self.isSearching && self.search != ""{
                                
                                HStack{
                                    
                                    Text("第 \(self.page) 頁")
                                    .background(Color.yellow)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        self.RandomImages.Images.removeAll()
                                        self.page += 1
                                        self.SearchData()
                                        
                                    }) {
                                        
                                        Text("下一頁")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .background(Color.yellow)
                                            .cornerRadius(.infinity)
                                    }
                                }
                                .padding(.horizontal,25)
                            }
                            
                            else{
                                
                                HStack{
                                    
                                    Text("第 \(self.page) 頁")
                                    .background(Color.yellow)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        self.RandomImages.Images.removeAll()
                                        self.page += 1
                                        self.RandomImages.updateData()
                                        
                                    }) {
                                        
                                        Text("下一頁")
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                            .background(Color.yellow)
                                            .cornerRadius(.infinity)
                                    }
                                }
                                .padding(.horizontal,25)
                            }
                        }
                    }
                    .padding(.top)
                }
            }
        }
        .background(Color.black.opacity(0.07).edgesIgnoringSafeArea(.all))
        .edgesIgnoringSafeArea(.top)
    }
    
    func SearchData(){
        
        let key = "2SYpP0gVFVB-jjqu-3wWDBiEVDUYNJGf6YQEt7qtddI"
        
        let query = self.search.replacingOccurrences(of: " ", with: "%20")
        
        let url = "https://api.unsplash.com/search/photos/?page=\(self.page)&query=\(query)&client_id=\(key)"
        
        self.RandomImages.SearchData(url: url)
    }
}


class getUnsplashData : ObservableObject{
    
    @Published var Images : [[Photo]] = []
    @Published var noresults = false
    
    init() {
        
        updateData()
    }
    
    func updateData(){
        
        self.noresults = false
        
        let key = "2SYpP0gVFVB-jjqu-3wWDBiEVDUYNJGf6YQEt7qtddI"
        let url = "https://api.unsplash.com/photos/random/?count=12&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }

            
            do{
                
                let json = try JSONDecoder().decode([Photo].self, from: data!)
                
                
                for i in stride(from: 0, to: json.count, by: 2){
                    
                    var ArrayData : [Photo] = []
                    
                    for j in i..<i+2{
                        
                        
                        if j < json.count{
                            
                        
                            ArrayData.append(json[j])
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.Images.append(ArrayData)
                    }
                }
            }
            catch{
                
                print(error.localizedDescription)
            }
            
            
        }
        .resume()
    }
    
    func SearchData(url: String){
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            
            do{
                
                let json = try JSONDecoder().decode(SearchPhoto.self, from: data!)
                
                
                if json.results.isEmpty{
                    
                    self.noresults = true
                }
                else{
                    
                    self.noresults = false
                }
                
                
                for i in stride(from: 0, to: json.results.count, by: 2){
                    
                    var ArrayData : [Photo] = []
                    
                    for j in i..<i+2{
                        
                        if j < json.results.count{
                            
                        
                            ArrayData.append(json.results[j])
                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.Images.append(ArrayData)
                    }
                }
            }
            catch{
                
                print(error.localizedDescription)
            }
            
            
        }
        .resume()
    }
}

struct Photo : Identifiable,Decodable,Hashable{
    
    var id : String
    var urls : [String : String]
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
        
    }
}


struct SearchPhoto : Decodable{

    var results : [Photo]
}
