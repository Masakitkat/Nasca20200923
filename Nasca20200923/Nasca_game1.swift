//
//  Nasca_game1.swift
//  Nasca20200923
//
//  Created by masaki on 2020/10/09.
//

import SwiftUI

struct Nasca_game1: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity : Idea.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Idea.date,ascending:true)]) var ideas : FetchedResults<Idea>
    
    @FetchRequest(entity : Tag.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Tag.date,ascending:true)]) var tags : FetchedResults<Tag>
    
    @State var ideatext = ""
    
    @State var conc = false
    @State var abst = false
    @State var conc_image = Color.blue
    @State var conc_text = ""
    @State var abst_image = Color.white
    @State var abst_text = ""
    
    @Binding var bottomhide : Bool
    
    @State var modal = false
    
    let animation : Namespace.ID
    
    func add() {
            let newidea = Idea(context: viewContext)
            
            newidea.id = UUID()
            newidea.title = ""
            newidea.text = ideatext
            newidea.date = Date()
        
            do {
                try viewContext.save()
            } catch {
                print(error)
                viewContext.delete(newidea)
            }
        }
    
    var body: some View {
        VStack{
//            Text("ナスカの地上絵")
//                .font(.title)
//                .bold()
//                .frame(width :UIScreen.main.bounds.width - 50, alignment : .leading)
            
//            ScrollView(.vertical, showsIndicators: true){
//            ZStack{
            VStack{
                
                
                VStack{
             Text("具体的なワード")
                .bold()
                .frame(width:UIScreen.main.bounds.width - 50,alignment : .leading)
            
                    if self.conc == false {
                        
                TabView{
                    
                   
                    
                    ForEach(0...6,id: \.self){i in
                        
                        // ignoring the current Hero Image...
                          ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(LinearGradient(gradient: Gradient(colors: [gamedata1[i].image, Color.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                
                                .overlay(RoundedRectangle(cornerRadius: 30)
//                                            .stroke(lineWidth: 5)
                                            .fill(Color.white.opacity(0.9))
                                            .blur(radius : 10)
                                            .frame(width : UIScreen.main.bounds.width - 80, height : 150)
                                )
//                            Image("special\(i)")
//                                .resizable()
//                                .cornerRadius(15)
//                              .blur(radius: 3)
                                .padding(.horizontal,3)
                              .onTapGesture {
                                withAnimation{
                                    
                                    self.conc_image = gamedata1[i].image
                                    self.conc_text = gamedata1[i].title
                                    
                                    self.conc = true
                                }
                                
                              }
                              
                              ZStack {
//                                  RoundedRectangle(cornerRadius: 5)
//                                      .frame(width: UIScreen.main.bounds.width - 100)
//                                      .foregroundColor(.white)
//                                      .opacity(0.5)
//                                      .blur(radius:10)
//                                      .frame(width : UIScreen.main.bounds.width / 3,height : 80)
                              Text("\(gamedata1[i].title)")
                                  .fontWeight(.bold)
                                .font(.title2)
                                  .foregroundColor(.black)
                                
                                
                                Image(systemName: "lock.open")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .frame(width : UIScreen.main.bounds.width - 100,height: 150,alignment : .topLeading)
                                  
                              }
                          }
                        }
                    }
                .frame(width : UIScreen.main.bounds.width - 50,height: 200)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                .padding(.trailing)
                    
                    }
                    
                    else {
                        
                        ZStack {
                            
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(LinearGradient(gradient: Gradient(colors: [self.conc_image, Color.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                
                                .overlay(RoundedRectangle(cornerRadius: 30)
//                                            .stroke(lineWidth: 5)
                                            .fill(Color.white.opacity(0.9))
                                            .blur(radius : 10)
                                            .frame(width : UIScreen.main.bounds.width - 80, height : 150))
                            
                            
//                            Image(self.conc_image)
//                              .resizable()
//                              .cornerRadius(15)
//                            .blur(radius: 3)
                              .padding(.horizontal,3)
                            .onTapGesture {
                              withAnimation{
                                  
                                  self.conc = false
                              }
                              
                            }
                            
                            ZStack {
//                                RoundedRectangle(cornerRadius: 5)
//                                    .frame(width: UIScreen.main.bounds.width - 100)
//                                    .foregroundColor(.white)
//                                    .opacity(0.5)
//                                    .blur(radius:10)
//                                    .frame(width : UIScreen.main.bounds.width / 3,height : 80)
                                Text(self.conc_text)
                                .fontWeight(.bold)
                              .font(.title2)
                                .foregroundColor(.black)
                                
                                Image(systemName: "lock")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .frame(width : UIScreen.main.bounds.width - 100,height: 150,alignment : .topLeading)
                                
                            }
                        }
                        .frame(width : UIScreen.main.bounds.width - 50,height: 200)
//                        .padding(.trailing)
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                }.padding(.horizontal)
//                .padding(.top)
               
                
                Text("×")
                    .bold()
                    .font(.title2)
//                    .frame(alignment : .center)
//                    .padding(.trailing)
                
                VStack{
             Text("抽象的なワード")
                .bold()
                .frame(width:UIScreen.main.bounds.width - 50,alignment : .leading)
            
                    
                    if self.abst == false {
                TabView{
                    
                    ForEach(0...6,id: \.self){i in
                        
                        // ignoring the current Hero Image...
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(LinearGradient(gradient: Gradient(colors: [gamedata2[i].image, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                
                                .overlay(RoundedRectangle(cornerRadius: 30)
//                                            .stroke(lineWidth: 5)
                                            .fill(Color.white.opacity(0.9))
                                            .blur(radius : 10)
                                            .frame(width : UIScreen.main.bounds.width - 80, height : 150)
                                )
                                
                                
                                ////                            Image("p\(i)")
                                ////                                .resizable()
                                ////                                .cornerRadius(15)
                                //                              .blur(radius: 3)
                                .padding(.horizontal,3)
                                .onTapGesture {
                                    withAnimation{
                                        self.abst_image = gamedata2[i].image
                                        self.abst_text = gamedata2[i].title
                                        self.abst = true
                                    }
                                }
                            
                              ZStack {
//                                  RoundedRectangle(cornerRadius: 5)
//                                      .frame(width: UIScreen.main.bounds.width - 100)
//                                      .foregroundColor(.white)
//                                      .opacity(0.5)
//                                      .blur(radius:10)
//                                      .frame(width : UIScreen.main.bounds.width / 3,height : 80)
                              Text("\(gamedata2[i].title)")
                                  .fontWeight(.bold)
                                .font(.title2)
                                  .foregroundColor(.black)
                                
                                
                                Image(systemName: "lock.open")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .frame(width : UIScreen.main.bounds.width - 100,height: 150,alignment : .topLeading)
                            
                                
                              }
                          }
                    }
                    }
                .frame(width : UIScreen.main.bounds.width - 50,height: 200)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                

                }
                    else {
                        
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(LinearGradient(gradient: Gradient(colors: [self.abst_image, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                
                                .overlay(RoundedRectangle(cornerRadius: 30)
//                                            .stroke(lineWidth: 5)
                                            .fill(Color.white.opacity(0.9))
                                            .blur(radius : 10)
                                            .frame(width : UIScreen.main.bounds.width - 80, height : 150)
                                )
                            
//                            Image(self.abst_image)
//                              .resizable()
//                              .cornerRadius(15)
//                            .blur(radius: 3)
                              .padding(.horizontal,3)
                            .onTapGesture {
                              withAnimation{
                                  
                                  self.abst = false
                              }
                              
                            }
                            
                            ZStack {
//                                RoundedRectangle(cornerRadius: 5)
//                                    .frame(width: UIScreen.main.bounds.width - 100)
//                                    .foregroundColor(.white)
//                                    .opacity(0.5)
//                                    .blur(radius:10)
//                                    .frame(width : UIScreen.main.bounds.width / 3,height : 80)
                                Text(self.abst_text)
                                .fontWeight(.bold)
                              .font(.title2)
                                .foregroundColor(.black)
                                
                                Image(systemName: "lock")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                    .frame(width : UIScreen.main.bounds.width - 100,height: 150,alignment : .topLeading)
                                
                            }
                        }
                        .frame(width : UIScreen.main.bounds.width - 50,height: 200)
                    }
                    
                }.padding(.horizontal)
                
                
                Spacer(minLength: 0)
                    .frame(height : 50)
                
                HStack(alignment : .center, spacing : 60){
                    
                    
                    
                    Button(action:{}){
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("top").opacity(0.9))
//                            .frame(width : 80)
                        Text("要素を\n追加する")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }.frame(width : 70)
                    }.buttonStyle(GradientButtonStyle())
                    
                   
                    
                    Button(action:{
                        
                        self.modal.toggle()
                        
                    }){
                        
                        ZStack{
                        Circle()
                            .fill(Color.yellow)
                            .frame(width : 50, height : 50)
                        Image(systemName:"plus")
                            .font(.title3)
                            .foregroundColor(.gray)
                        }
                        
                    }.buttonStyle(GradientButtonStyle())
                    
                    
                    Button(action:{}){
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("top").opacity(0.9))
//                            .fill(Color.yellow)
                            .frame(width : 70)
                        Text("他人のアイディアを見る")
                            .font(.caption)
                            .foregroundColor(.white)
                    }.frame(width : 70)
                    }.buttonStyle(GradientButtonStyle())
                    
                    
                    
                }.frame(width : UIScreen.main.bounds.width - 20, height : 60, alignment : .center)
                
                Spacer(minLength: 0)
                    .frame(height : 20)
                
                
            }
            
//            }
        .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height,alignment : .center)
            .padding()
            
        }.frame(width : UIScreen.main.bounds.width , height : UIScreen.main.bounds.height)
        .background(Color("primary").edgesIgnoringSafeArea(.all))
        .onAppear(perform: {
            withAnimation(){
            self.bottomhide = true
            }
        })
        .onDisappear(perform: {
            withAnimation(){
            self.bottomhide = false
            }
        })
        .sheet(isPresented: self.$modal, content: {
            MemoModal_game(conc_image : self.conc_image, conc_text : self.conc_text,abst_image : self.abst_image, abst_text : self.abst_text)
        })
    }
}

//struct Nasca_game1_Previews: PreviewProvider {
//    static var previews: some View {
//        Nasca_game1()
//    }
//}

struct arrow_down: Shape {
    func path( in rect : CGRect) -> Path {
        Path { path in
            let scale = min(rect.width,rect.height)
            
            
            
            path.addLines([
            
                CGPoint(x : UIScreen.main.bounds.width/2 - 150, y: scale * 1),
                CGPoint(x : UIScreen.main.bounds.width/2 , y: scale * 1.618 * 2),
                CGPoint(x : UIScreen.main.bounds.width/2 + 150, y: scale * 1),
            ])
            path.closeSubpath()
        }
    }
}

struct game : Identifiable {
    
    var id : Int
    var image : Color
    var title : String
    var text : String
    var developing : Bool
}

var gamedata1 = [

    game(id: 0, image: .blue, title: "パンを食べて",text : "このゲームは、Tinderのように表示される単語や画像をピックアップして、選んだものを基にアイディアを出すものです。ゲームを実施した後に他のプレイヤーがこのゲームでどんなアイディアを出したのかを確認することも可能です。",developing: true),
    game(id: 1, image: .green, title: "スマホを触って",text : "xceptionally simple way to build user interfaces across all Apple platforms with the power of Swift. Build user interfaces for any Apple device using just one set of tools and APIs",developing: true),
    game(id: 2, image: .orange, title: "散歩に出掛けて", text: "e. With a declarative Swift syntax that’s easy to read and natural to write, SwiftUI works seamlessly with new Xcode design tools to keep your code and design perfectly in syn",developing: true),
    game(id: 3, image: .yellow, title: "電車に乗って", text : "c. Automatic support for Dynamic Type, Dark Mode, localization, and accessibility means your first line of SwiftUI code is already",developing: true),
    game(id: 4, image: .red, title: "友達と旅行に行って",text : ",  the most powerful UI code you’ve ever wr",developing: true),
    game(id: 5, image: .purple, title: "飲み会で騒いで", text: "asdfasdfafdaf",developing: false),
    game(id: 6, image: .blue, title: "布団で寝ながら", text: "asdfasdfafdaf",developing: false),
    game(id: 7, image: .gray, title: "Twitterをチェックしつつ", text: "asdfasdfafdaf",developing: false),

]

var gamedata2 = [

    game(id: 0, image: .blue, title: "貧困を解決するには？",text : "このゲームは、Tinderのように表示される単語や画像をピックアップして、選んだものを基にアイディアを出すものです。ゲームを実施した後に他のプレイヤーがこのゲームでどんなアイディアを出したのかを確認することも可能です。",developing: true),
    game(id: 1, image: .green, title: "地球をクリーンにするには？",text : "xceptionally simple way to build user interfaces across all Apple platforms with the power of Swift. Build user interfaces for any Apple device using just one set of tools and APIs",developing: true),
    game(id: 2, image: .red, title: "組織で目立つためには？", text: "e. With a declarative Swift syntax that’s easy to read and natural to write, SwiftUI works seamlessly with new Xcode design tools to keep your code and design perfectly in syn",developing: true),
    game(id: 3, image: .orange, title: "バズるYoutuberになるには？", text : "c. Automatic support for Dynamic Type, Dark Mode, localization, and accessibility means your first line of SwiftUI code is already",developing: true),
    game(id: 4, image: .purple, title: "宇宙に行くには？",text : ",  the most powerful UI code you’ve ever wr",developing: true),
    game(id: 5, image: .green, title: "ムキムキになるには？", text: "asdfasdfafdaf",developing: false),
    game(id: 6, image: .gray, title: "食生活を改善するには？", text: "asdfasdfafdaf",developing: false),
    game(id: 7, image: .yellow, title: "隣人を笑顔にするためには？", text: "asdfasdfafdaf",developing: false),

]

