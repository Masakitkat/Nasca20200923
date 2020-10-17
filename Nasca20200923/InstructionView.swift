//
//  InstructionView.swift
//  Nasca20200923
//
//  Created by masaki on 2020/09/24.
//

import SwiftUI

struct InstructionView: View {
    
    @State private var scaleYleft = false
    @State private var scaleXleft = false
    @State private var scaleYmiddle = false
    @State private var scaleXmiddle = false
    @State private var scaleYright = false
    @State private var scaleXright = false
    
    @State var pageindex : Int = 0
    @State var pageindex_temp : Int = 0
    
    @State var test = false

    
    @Binding var selected : String
    
    @State var str = ["Nascaへようこそ。初めに、このアプリの使い方をご紹介致します。右側のバーをドラッグすると次のページに進むことができます。",                 "このアプリは、あなたの思いつきをまとめ、広げる支援をします。必要であれば、あなた自身の本当にやりたいことを探すお手伝いもできればと思っています。",
                      "初めに、あなたが思いつくことが一度でもある分野を教えてもらえますか？",
                      "選択した分野はタグとして、いつでも増やしたり減らしたりすることができます。",
                      "せっかくなので、選択していただいた分野の中で、過去に思いついたことのあるアイディアを書いてみましょう。私たちが用意しているデフォルトの評価項目で点数をつけることもできます。",
                      "記録できましたか？このような形で、思いついたタイミングや、思い出したタイミングで記録してみて下さい。",
                      "記録したアイディアは、リスト画面で一覧を確認できます。気に入ったアイディアの詳細を詰めることもできます。",
                      "他にも、あなたのような他のクリエイターの投稿を見て刺激を受けたり、あなたのアイディアを分析してあなた自身の興味関心を知るための機能も用意しています。使い方自体はあなた自身で探検してみてください。","それでは、早速使ってみましょう。"]
    
    @State var texti : [String] = ["","","","","","","","","","","","",""]
    @State var textii = "|"
    @State var count = 0
    
    @State var offset : CGFloat = 0
    
//    let animation : Namespace.ID

    
    func loop() {
        var i : [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        self.pageindex_temp = self.pageindex
        

        func nextIteration() {
            
            if self.pageindex_temp == self.pageindex {
                
                if i[self.pageindex_temp] <= str[self.pageindex].count {

                        
                    self.texti[self.pageindex_temp] = String(str[self.pageindex_temp].prefix(i[self.pageindex_temp]))
                    
                    
                    i[self.pageindex_temp] += 1
                    
                    if self.texti[self.pageindex_temp].suffix(1) == "。" || self.texti[self.pageindex_temp].suffix(1) == "、" || self.texti[self.pageindex_temp].suffix(1) == "？" {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6058) {
                            nextIteration()
                        }
                    }
                    else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0658) {
                            nextIteration()
                        }
                    }
                }
                
                else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0928) {
                    nextIteration()
                }
                }
                
            }
            
            else {
                
                self.pageindex_temp = self.pageindex
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2558) {
                    nextIteration()
                }
            }
            
        }
        
        nextIteration()
    }
    
        var body: some View {
            
            
            GeometryReader{
                geometry in

                ZStack {
                    LiquidSwipeView(pageIndex: $pageindex)
                    VStack
                    {
                        Spacer()
                        Text(self.texti[self.pageindex] + self.textii)
                            .font(.title3)
                            .bold()
                            .padding()
                            .foregroundColor(self.pageindex % 2 == 0 ? .black : .white)
                        
                        
                            
                        Spacer()
//                            .frame(height : 100)
                           
                    }
                    .frame(width: geometry.size.width - 50, height :geometry.size.height - 50, alignment : .center)
                .onAppear(){
                    self.loop()
                }
                    
                    if self.pageindex == 8 && str[self.pageindex].count ==  self.texti[8].count{
                        
                        Button(action:{
                            withAnimation(.interactiveSpring()){
                                
                                self.selected = "Memo"
                            }
                        }){
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 180,height :45)
                                    .padding()
                               
                                Text("Begin your journey")
                                    .foregroundColor(.white)
                                
                            }
                        }.frame(width: 100, height: 300, alignment: .bottom)
                        
                    }
                
                    HStack(alignment: .center) {
                        
                        ZStack {
//                                Circle()
//                                    .frame(width:15,height:15)
//                                    .opacity(0.3)
                            Circle()
                                .frame(width:15,height:15)
                                .opacity(0.8)
                                .foregroundColor(Color(#colorLiteral(red: 0.8964173198, green: 0.3757638931, blue: 0.4421405494, alpha: 1)))
                                .scaleEffect(x: scaleXleft ? 1 : 0.7, y : scaleYleft ? 1 : 0.3, anchor : .center)
                                .animation(Animation.easeInOut(duration:0.8).repeatCount(150, autoreverses: true))
                                .onAppear(){
                                    self.scaleYleft.toggle()
                                    self.scaleXleft.toggle()
                                }
                        }
                        ZStack{
//                                Circle()
//                                    .frame(width:10,height:10)
//                                    .opacity(0.3)
                            
                            Circle()
                                .frame(width:13,height:13)
                                .opacity(0.8)
                                .foregroundColor(Color(#colorLiteral(red: 0.1428147554, green: 0.191432029, blue: 0.9183178544, alpha: 1)))
                                .scaleEffect(x: scaleXmiddle ? 1 : 0.7, y : scaleYmiddle ? 1 : 0.5, anchor : .bottom)
                                .animation(Animation.easeInOut(duration:0.7).repeatCount(150, autoreverses: true).delay(0.2))
                                .onAppear(){
                                    self.scaleYmiddle.toggle()
                                    self.scaleXmiddle.toggle()
                                }
                    }
                        
                        
                        ZStack{
//                                Circle()
//                                    .frame(width:10,height:10)
//                                    .opacity(0.3)
//
                            Circle()
                                .frame(width:11,height:11)
                                .opacity(0.7)
                                .foregroundColor(Color(#colorLiteral(red: 0.9531899095, green: 0.7879680991, blue: 0, alpha: 1)))
                                .scaleEffect(x: scaleXright ? 1 : 0.7, y : scaleYright ? 1 : 0.3, anchor : .bottom)
                                .animation(Animation.easeInOut(duration:0.9).repeatCount(150, autoreverses: true).delay(0.1))
                                .onAppear(){
                                    self.scaleYright.toggle()
                                    self.scaleXright.toggle()
                                }
                    }
                    
                    }
                    .frame(width: geometry.size.width - 80, height :geometry.size.height - 80,alignment :.bottom)
                    
                    ZStack {
                Button(action:{
                    
                    self.selected = "Memo"
                }){
                Text("> Skip")
                    .font(.callout)
                    .foregroundColor(self.pageindex % 2 == 0 ? .black : .white)
                    .opacity(0.5)
                    }
                } .frame(width : geometry.size.width - 50 , height : geometry.size.height - 80 , alignment : .bottomTrailing)
                    
                    if self.pageindex == 2 && str[self.pageindex].count ==  self.texti[2].count{
                    BottomSheet(offset: $offset, value: (-geometry.frame(in: .global).height + 15))
                        
//                        .padding(.horizontal,10)
                        .offset(y: geometry.frame(in: .global).height - 100)
                        .offset(y:offset)
                        .gesture(DragGesture().onChanged({ (value) in
                            
                            withAnimation{
                                
                                // checking the direction of scroll....
                                
                                // scrolling upWards....
                                // using startLocation bcz translation will change when we drag up and down....
                                
                                if value.startLocation.y > geometry.frame(in: .global).midX{
                                    
                                    if value.translation.height < 0 && offset > (-geometry.frame(in: .global).height + 600){
                                        
                                        offset = value.translation.height
                                    }
                                }
                                
                                if value.startLocation.y < geometry.frame(in: .global).midX{
                                    
                                    if value.translation.height > 0 && offset < 0{
                                        
                                        offset = (-geometry.frame(in: .global).height + 600) + value.translation.height
                                    }
                                }
                            }
                            
                        }).onEnded({ (value) in
                            
                            withAnimation{
                                
                                // checking and pulling up the screen...
                                
                                if value.startLocation.y > geometry.frame(in: .global).midX{
                                    
                                    if -value.translation.height > geometry.frame(in: .global).midX{
                                        
                                        offset = (-geometry.frame(in: .global).height + 600)
                                        
                                        return
                                    }
                                    
                                    offset = 0
                                }
                                
                                if value.startLocation.y < geometry.frame(in: .global).midX{
                                    
                                    if value.translation.height < geometry.frame(in: .global).midX{
                                        
                                        offset = (-geometry.frame(in: .global).height + 600)
                                        
                                        return
                                    }
                                    
                                    offset = 0
                                }
                            }
                        }))
                    }


                    if self.pageindex == 4 && str[self.pageindex].count ==  self.texti[4].count{
                        BottomSheet2(offset: $offset,value: (-geometry.frame(in: .global).height + 150))
                        .offset(y: geometry.frame(in: .global).height - 100)
                        .offset(y:offset)
                        .gesture(DragGesture().onChanged({ (value) in

                            withAnimation{

                                // checking the direction of scroll....

                                // scrolling upWards....
                                // using startLocation bcz translation will change when we drag up and down....

                                if value.startLocation.y > geometry.frame(in: .global).midX{

                                    if value.translation.height < 0 && offset > (-geometry.frame(in: .global).height + 150){

                                        offset = value.translation.height
                                    }
                                }

                                if value.startLocation.y < geometry.frame(in: .global).midX{

                                    if value.translation.height > 0 && offset < 0{

                                        offset = (-geometry.frame(in: .global).height + 150) + value.translation.height
                                    }
                                }
                            }

                        }).onEnded({ (value) in

                            withAnimation{

                                // checking and pulling up the screen...

                                if value.startLocation.y > geometry.frame(in: .global).midX{

                                    if -value.translation.height > geometry.frame(in: .global).midX{

                                        offset = (-geometry.frame(in: .global).height + 150)

                                        return
                                    }

                                    offset = 0
                                }

                                if value.startLocation.y < geometry.frame(in: .global).midX{

                                    if value.translation.height < geometry.frame(in: .global).midX{

                                        offset = (-geometry.frame(in: .global).height + 150)

                                        return
                                    }

                                    offset = 0
                                }
                            }
                        }))
                    }
//
            }
                
            }
            .sheet(isPresented: self.$test, content: {
                MemoModalView()
            })
    //        .offset(y : check)
            .background(Color(#colorLiteral(red: 0.9454948306, green: 0.9048054814, blue: 0.8575084209, alpha: 1)))
            .edgesIgnoringSafeArea(.all)
            
        }
    }

struct BottomSheet : View {
    
    @State var txt = ""
    @Binding var offset : CGFloat
    var value : CGFloat
    
    @FetchRequest(entity : Tag.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Tag.date,ascending:true)]) var tags : FetchedResults<Tag>
    
    var body: some View{
        
        VStack{
            
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 50, height: 5)
                .padding(.top)
                .padding(.bottom,5)
            
            Text("タグを３つ選んでみましょう")
                .fontWeight(.bold)
                .font(.title2)
                .padding()
                .frame(alignment : .leading)
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 10, content: /*@START_MENU_TOKEN@*/{
                    ForEach(self.tags, id: \.self) { tag in
                        
                        let tagtext = tag.text ?? ""
                        let tagcolor = tag.color ?? ""
                        
                        Button(action:{}){
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color(hex : tagcolor))
                            Text(tagtext)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }.frame(height : 80)
                        }
                    }
                })
                .padding()
                .padding(.top)
                
                Spacer()
                    .frame(height : 1000)
            })
        }
        .background(BlurView(style: .systemMaterial))
        .cornerRadius(15)
    }
}

struct BottomSheet2 : View {
    
    @State var txt = ""
    @Binding var offset : CGFloat
//    let animation : Namespace.ID
    var value : CGFloat
    
    var body: some View{
        
        VStack{
            
            Capsule()
                .fill(Color.gray.opacity(0.5))
                .frame(width: 50, height: 5)
                .padding(.top)
                .padding(.bottom,5)
            
            Text("アイディアを書いてみましょう")
                .fontWeight(.bold)
                .font(.title2)
                .padding()
                .frame(alignment : .leading)
            MemoModalView()
        }
        .background(Color("primary"))
//        .background(BlurView(style: .systemMaterial))
        .cornerRadius(15)
    }
}

struct BlurView : UIViewRepresentable {
    
    var style : UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView{
        
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
        
    }
}
