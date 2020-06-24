//
//  ChangeView.swift
//  News
//
//  Created by 潘昱任 on 2020/6/9.
//  Copyright © 2020 ntouyujen. All rights reserved.
//

import SwiftUI

struct ChangeView: View {
    var body: some View {
            TabView {
                SelectNewsView()
                    .tabItem {
                        Image(systemName: "tv")
                        Text("新聞隨意看")
                }
                UnsplashView()
                    .tabItem {
                        Image(systemName: "photo")
                        Text("UnSplash圖庫")
                }
                RAndMView()
                    .tabItem {
                        Image(systemName: "flame")
                        Text("瑞克莫蒂人物列表")
                }
            }
        }
    }

struct ChangeView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeView()
    }
}
