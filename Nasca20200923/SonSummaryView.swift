//
//  SonSummaryView.swift
//  Nasca20200923
//
//  Created by masaki on 2020/09/26.
//

import SwiftUI


//struct SonSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        let tophide = false
//        SonSummaryView(tophide : tophide)
//    }
//}



struct SonSummaryView: View {
    
    var animation : Namespace.ID
      var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 2)
      @State var selected : Travel = data[0]
      @State var show = false
      @Binding var tophide : Bool
      @Binding var bottomhide : Bool
    
      @Namespace var namespace
      // to load Hero View After Animation is done....
      @State var loadView = false
      
      var body: some View{
        
        NavigationView{
        
          ZStack{
              
            if show != true {
              ScrollView(.vertical, showsIndicators: false) {
                  // Grid View...
                  
                  LazyVGrid(columns: columns,spacing: 25){
                      
                      ForEach(data){travel in
                          
                          VStack(alignment: .center, spacing: 10){
                              
                            ZStack {
                                
                                
                                Image(travel.image)
                                      .resizable()
                                      .frame(height: 180)
//                                      .cornerRadius(15)
                                    .blur(radius: travel.developing ? 0 : 2)
                                      .matchedGeometryEffect(id: travel.image, in: animation)
                                      // assigning ID..
                                      .onTapGesture {
                                        if travel.developing {
                                          withAnimation(.spring()){
//                                            tophide.toggle()
                                              show.toggle()
                                              selected = travel
                                              DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                  
                                                  loadView.toggle()
                                              }
                                          }}
                                  }
                                
                                Circle()
                                    .foregroundColor(travel.developing ? Color("primary") : Color.clear)
                                    .background(Color.clear)
                                    .frame(width : 50 ,height : 50)
                                    .overlay(
                                        Circle().stroke(lineWidth: 5).foregroundColor(travel.developing ? Color("top") : Color.clear))

                                Circle()
                                    .foregroundColor(travel.developing ? Color("top") : Color.clear)
                                    .background(Color.clear)
                                    .frame(width : 30 ,height : 30)
                                    .overlay(
                                        Circle().stroke(lineWidth: 5).foregroundColor(travel.developing ? Color("top") : Color.clear))
                                
                                if travel.developing != true {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
//                                            .frame(width: UIScreen.main.bounds.width/2)
                                            .foregroundColor(.white)
                                            .opacity(0.4)
                                            .blur(radius:2)
//                                            .frame(width : UIScreen.main.bounds.width / 3,height : 80)
                                        Text("開発中")
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        HStack{
                                            Button(action:{}){
                                        Image(systemName: "hand.thumbsup.fill")
                                            .font(.title2)
                                            .foregroundColor(.blue)
                                            }
                                            
                                            
                                        Text("気になる？")
                                            .fontWeight(.bold)
                                            .font(.caption)
                                            .foregroundColor(.black)
//                                            .padding(.top,10)
                                        }.frame(width : 160,height : 150,alignment : .bottom)
                                    }
                                }
                            }
                            
//                          .overlay(
//                            Circle().stroke(lineWidth: 80).foregroundColor(.white))
//                            .overlay(
//                              Circle().stroke(lineWidth: 70).foregroundColor(.black))
                            .clipShape(Circle())
                        
                          .shadow(radius : 5, x : 0, y : 5)
                                  
                              
                              Text(travel.title)
                                  .fontWeight(.bold)
                                   .matchedGeometryEffect(id: travel.title, in: animation)
                                  .foregroundColor(.black)
                                .frame(alignment : .center)
                                
                                  
                          }
                      }
                  }
                  .zIndex(2)
                  .offset(y:100)
                  .padding([.horizontal,.bottom])
                
                Spacer()
                    .frame(height:300)
              }
              
              
              .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            }
              // Hero View....
              
              if show{
                
                  VStack{
                    
                    ScrollView(showsIndicators: false) {
                    
                      ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                        GeometryReader{ g in
                        
                            Image(selected.image)
                                .resizable()
                                .frame(height : 250)
                                
                                .offset(y : g.frame(in : .global).minY > 0 ? -g.frame(in : .global).minY : 0)
                                .frame(height : g.frame(in : .global).minY > 0 ? UIScreen.main.bounds.height / 2.5 + g.frame(in : .global).minY :
                                        UIScreen.main.bounds.height / 2.5)
                                .matchedGeometryEffect(id: selected.image, in: animation)
//                                .frame(height: 300)
                        }.frame(height : UIScreen.main.bounds.height / 2.5)
                        .edgesIgnoringSafeArea(.top)
                          
                          
                          if loadView{
                              
                              
                              HStack{
                                  
                                  Button {
                                      
                                      loadView.toggle()
                                      
                                      withAnimation(.spring()){
                                          
                                          show.toggle()
//                                        self.tophide.toggle()
                                      }
                                      
                                  } label: {
                                   
                                      Image(systemName: "xmark")
                                          .foregroundColor(.white)
                                          .padding()
                                          .background(Color.black.opacity(0.5))
                                          .clipShape(Circle())
                                  }
  
                                  Spacer()
                                  
                                  Button {
                                      
                                      
                                  } label: {
                                   
                                      Image(systemName: "suit.heart.fill")
                                          .foregroundColor(.red)
                                          .padding()
                                          .background(Color.white)
                                          .clipShape(Circle())
                                  }
                              }
                              .padding(.top,35)
                              .padding(.horizontal)
                              
                          }
                      }
                      .offset(y : 100)
                      .frame(height : UIScreen.main.bounds.height / 2.5)
                    
                      
                      
                      // you will get this warning becasue we didnt hide the old view so dont worry about that it will work fine...
                      
                      // Detail View....
                      
//                      ScrollView(.vertical, showsIndicators: false) {
                        
                        
                          
                          // loading after animation completes...
                          
                          if loadView{
                              
                              VStack{
                                  
                                  HStack{
                                    
                                      Text(selected.title)
                                          .font(.title)
                                          .fontWeight(.bold)
                                          .foregroundColor(.black)
                                      Spacer()
                                  }
//                                  .matchedGeometryEffect(id: selected.title, in: animation)
                                  .padding(.top)
                                  .padding(.horizontal)
                                  
                                  // some sample txt...
                                  
                                Text(selected.text)
                                      .multilineTextAlignment(.leading)
                                      .foregroundColor(.black)
                                      .padding(.top)
                                      .padding(.horizontal)
                                  
                                  HStack{
                                      
                                      Text("この遊びで出たアイディア")
                                          .font(.title)
                                          .fontWeight(.bold)
                                          .foregroundColor(.black)
                                      
                                      Spacer()
                                  }
                                  .padding(.top)
                                  .padding(.horizontal)
                                  
                                  HStack(spacing: 0){
                                      
                                      ForEach(1...5,id: \.self){i in
                                          
                                          Image("r\(i)")
                                              .resizable()
                                              .aspectRatio(contentMode: .fill)
                                              .frame(width: 50, height: 50)
                                              .clipShape(Circle())
                                              .offset(x: -CGFloat(i * 20))
                                      }
                                      
                                      Spacer(minLength: 0)
                                      
                                      Button(action: {}) {
                                          
                                          Text("全て見る")
                                              .fontWeight(.bold)
                                      }
                                  }
                                  // since first is moved -20
                                  .padding(.leading,20)
                                  .padding(.top)
                                  .padding(.horizontal)
                                  
                                  // Carousel...
                                  
                                  HStack{
                                      
                                      Text("他の遊び方")
                                          .font(.title)
                                          .fontWeight(.bold)
                                          .foregroundColor(.black)
                                      
                                      Spacer()
                                  }
                                  .padding(.top)
                                  .padding(.horizontal)
                                  
                                  TabView{
                                      
                                      ForEach(1...6,id: \.self){i in
                                          
                                          // ignoring the current Hero Image...
                                          
                                          if "p\(i)" != selected.image{
                                            ZStack {
                                              Image("p\(i)")
                                                  .resizable()
                                                  .cornerRadius(15)
                                                .blur(radius: 0.5)
                                                  .padding(.horizontal)
                                                .onTapGesture {
                                                    withAnimation(.spring()){
                                                    selected = data[i-1]
                                                    }
                                                }
                                                
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .frame(width: UIScreen.main.bounds.width/2)
                                                        .foregroundColor(.white)
                                                        .opacity(0.5)
                                                        .blur(radius:10)
                                                        .frame(width : UIScreen.main.bounds.width / 3,height : 80)
                                                Text("\(data[i-1].title)")
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.black)
                                                    
                                                }
                                            }
                                          }
                                      }
                                  }
                                  .frame(height: 250)
                                  .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                  .padding(.top)
                                  
                                  // Button..
                                NavigationLink(destination:Nasca_game1(bottomhide : $bottomhide, animation: animation)){
                                      
                                      Text("始める")
                                          .fontWeight(.bold)
                                          .foregroundColor(.white)
                                          .padding(.vertical)
                                          .frame(width: UIScreen.main.bounds.width - 50)
                                          .background(Color("top"))
                                          .cornerRadius(15)
                                  }
                                  .padding(.top,10)
                                  .padding(.bottom)
                              }
                              
                          }
                        
                        Spacer()
                            .frame(height :300)
                      }
//                      .background(Color("primary"))
                      
                  }
                                    .zIndex(1)
//                  .background(Color("primary"))
              }
          }
          .background(Color("primary").edgesIgnoringSafeArea(.all))
          .frame(height : UIScreen.main.bounds.height + 100)
//          .offset(y : -30)
          // hiding for hero Vieww.....
//          .statusBar(hidden: show ? true : false)

      }
        
      }
  }
  
  // sample Data...
  
  struct Travel : Identifiable {
      
      var id : Int
      var image : String
      var title : String
      var text : String
      var developing : Bool
  }
  
  var data = [
  
    Travel(id: 0, image: "p1", title: "Tinder風連想",text : "このゲームは、Tinderのように表示される単語や画像をピックアップして、選んだものを基にアイディアを出すものです。ゲームを実施した後に他のプレイヤーがこのゲームでどんなアイディアを出したのかを確認することも可能です。",developing: true),
             Travel(id: 1, image: "p2", title: "お題ベース",text : "xceptionally simple way to build user interfaces across all Apple platforms with the power of Swift. Build user interfaces for any Apple device using just one set of tools and APIs",developing: true),
             Travel(id: 2, image: "p3", title: "最近のトレンドベース", text: "e. With a declarative Swift syntax that’s easy to read and natural to write, SwiftUI works seamlessly with new Xcode design tools to keep your code and design perfectly in syn",developing: true),
             Travel(id: 3, image: "p4", title: "雑学系", text : "c. Automatic support for Dynamic Type, Dark Mode, localization, and accessibility means your first line of SwiftUI code is already",developing: true),
             Travel(id: 4, image: "p5", title: "宇宙の始まりから",text : ",  the most powerful UI code you’ve ever wr",developing: true),
             Travel(id: 5, image: "p6", title: "ナスカの地上絵", text: "asdfasdfafdaf",developing: false),
             Travel(id: 6, image: "i2", title: "海亀のスープ", text: "asdfasdfafdaf",developing: false),
             Travel(id: 7, image: "i1", title: "美術品を眺めて", text: "asdfasdfafdaf",developing: false),
  
  ]

