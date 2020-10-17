//
//  MemoModalView.swift
//  Nasca20200923
//
//  Created by masaki on 2020/09/27.
//

import SwiftUI

struct MemoModalView_huyou: View {

    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity : Idea.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Idea.date,ascending:true)]) var ideas : FetchedResults<Idea>
    
    @FetchRequest(entity : Tag.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Tag.date,ascending:true)]) var tags : FetchedResults<Tag>
    
    var hex = ["#EBCA3F","#D26873","#D26873","#2A34E1","#2A34E1","#EBCA3F","486d8b","d22b55","81b27f"]
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State var initial_tags : [Tag] = []
    
    @State var selected : [Double] = [1,2,3]
    @State private var ideaTitle : String = ""
    @State private var ideatext : String = ""
    @State private var tagName : String = ""
    @State private var tagcolor : String = "#031b4e"
    
    @State var isChanged = false
    @State var tagEdited = false
    @State var isSaved = false
    @State var tagdeleting = false
    @State var popup = false
    @State var tagcrating = false
    @State var tagselecting = false
    @State var tag_show = false
    @State var eval_show = false
    @State var evals_show : [Bool] =  [false,false,false]
    @State var eval_selected : [String] = ["新規性","拡張性","親和性"]
    
    var proverbs = data_proverb.shuffled()
    
    func add() {

            let newidea = Idea(context: viewContext)
            var count = 0
            
            newidea.id = UUID()
            newidea.title = ideaTitle
            newidea.text = ideatext
            newidea.eval1 = Int16(selected[0])
            newidea.eval2 = Int16(selected[1])
            newidea.eval3 = Int16(selected[2])
            newidea.date = Date()
            
            
        while count < initial_tags.count || count == 0 && initial_tags.count != 0 {
                newidea.addToTag(initial_tags[count])
                count += 1
            }
            
            do {
                try viewContext.save()
            } catch {
                print(error)
                viewContext.delete(newidea)
            }
        }
    
    func tagAdd() {
        let addedTag = Tag(context : viewContext)
            addedTag.id = UUID()
            addedTag.color = tagcolor
            addedTag.text = tagName
            addedTag.date = Date()
            let check = tags.compactMap({$0.text}).contains(addedTag.text)
            let index = tags.compactMap({$0.text}).firstIndex(of: addedTag.text)
            if check {
                viewContext.delete(addedTag)
                if initial_tags.compactMap({$0.text}).contains(addedTag.text) != true {
                initial_tags.append(tags[index!])
                }
            }
            else
            {
            initial_tags.append(addedTag)
                do {
                    try viewContext.save()
                } catch {
                    print(error)
                    viewContext.delete(addedTag)
                }
            }

        }
    
    var body: some View {

        
        GeometryReader{
            geometry in
            
            
            ZStack {
                VStack {
                    VStack(alignment : .leading) {
                        Text(self.proverbs[1].text)
                            .font(.system(size:20))
                            .fontWeight(.heavy)
                        Spacer().frame(height : 5)
                        Text(self.proverbs[1].author)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 30)
                    .frame(width: geometry.size.width - 50)
                    
                    ZStack(alignment: .center) {
                        
                        RoundedRectangle(cornerRadius:15 ,style: .continuous)
                            .fill(Color(#colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1)))
                        .frame(width:geometry.size.width - 20, height: geometry.size.height/4)
//                        .shadow(radius: 5,
//                                x: 0,
//                                y: -10)
                    
                    VStack {
                        TextField("思いついたことを書いてみよう！",text: self.$ideatext)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .frame(width: geometry.size.width - 100, height: geometry.size.height/5)
                            .lineLimit(nil)
                        
                        
                    }.frame(width:geometry.size.width, height: geometry.size.height/4)
                    
                    
                        
                        
                }
                
                    ZStack(alignment: .bottomTrailing) {
                        
                    
                ScrollView {
                   
                    DisclosureGroup("タグ",isExpanded : self.$tag_show){
                        
                        ScrollView(showsIndicators: false){
                            LazyVGrid(columns: [GridItem(.adaptive(minimum:160))], alignment: .leading, spacing: 10, pinnedViews: [], content: /*@START_MENU_TOKEN@*/{
                        ForEach(self.tags, id :\.self){ tag in
                            
                            let tagtext = tag.text ?? ""
                            let tagcolor = tag.color ?? ""
                            
                            ZStack(alignment : .leading){
                  
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(hex :tagcolor).opacity(0.5))
                                Text(tagtext)
                                    .padding()
                            }
                            .contextMenu{
                                Button(action: {
                                        viewContext.delete(tag)
                                    try! viewContext.save()
                                }, label: {
                                    Text("Delete")
                                })
                            }
                        }
                            
                            Button(action:{
                                
                                self.tagEdited.toggle()
                            }){
                            ZStack(alignment : .leading) {

                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color.white.opacity(0.3))
                                
                                Label(title :
                                        {Text("タグを追加する")},
                                      icon :
                                        {Image(systemName: "plus")}
                                    )
                                .foregroundColor(Color.blue)
                                .padding()
                                
                            }
                            }
                            
                        })
                        }
                        .animation(.default)
                        .padding(.top)
                        .frame(height:150,alignment: .top)
                        
                    }
                    .padding(.all)
                    .background(Color.black.opacity(0.06))
                    .cornerRadius(12)
                    
                    DisclosureGroup("評価",isExpanded : self.$eval_show){
                    
                    VStack {

                        DicloseView(expand_key: self.evals_show[0], text1: self.$eval_selected[0], text2 : "\(self.eval_selected[0])")
                        
                        Slider(value : self.$selected[0], in: 0...100,step:1,
                               minimumValueLabel: Text("0"),
                               maximumValueLabel: Text("100"),
                               label: { EmptyView() }
                        ).frame(alignment: .top)
                        
                    }
                    .padding(.vertical)
                    
                    VStack {

                        DicloseView(expand_key: self.evals_show[1], text1: self.$eval_selected[1], text2 : "\(self.eval_selected[1])")
                        
                        Slider(value : self.$selected[1], in: 0...100,step:1,
                               minimumValueLabel: Text("0"),
                               maximumValueLabel: Text("100"),
                               label: { EmptyView() }
                        ).frame(alignment: .top)
                        
                    }
                    .padding(.vertical)
                    
                    VStack {
                       
                        DicloseView(expand_key: self.evals_show[2], text1: self.$eval_selected[2], text2 : "\(self.eval_selected[2])")
                        
                        
                        Slider(value : self.$selected[2], in: 0...100,step:1,
                               minimumValueLabel: Text("0"),
                               maximumValueLabel: Text("100"),
                               label: { EmptyView() }
                        ).frame(alignment: .top)
                        
                    }
                    .padding(.vertical)
                    }
                    .padding(.all)
                    .background(Color(hex: "E8D6AE").opacity(0.6))
//                    .background(Color.black.opacity(0.06))
                    .cornerRadius(12)
                    
                    
                    Spacer()
                        .frame(height:100)
                    
//                    HStack(alignment : .center, spacing: 15) {
//
//
//                    Text("Tag")
//                        .bold()
//                        .font(.system(size:20))
////                        .frame(width : geometry.size.width - 50, alignment: .leading)
//
//
//                    LazyHGrid(rows: [GridItem(.adaptive(minimum: 40), spacing : -10)], spacing:5){
//
//                        ForEach(self.initial_tags, id:\.self){ tag in
//
//                            ZStack {
//
//                            RoundedRectangle(cornerRadius: 10)
//                                .foregroundColor(Color(hex : tag.color ?? ""))
//                                .frame(width : 80, height: 20)
//                                Text("#" + "\(tag.text ?? "")")
//                                .frame(width : 70)
//                                .lineLimit(1)
//                                .foregroundColor(Color.white)
//                            }
//
//                        }
//
////                        ForEach(self.initial_tags, id : \.self){ obj in
////
////
////                            ZStack {
////                                RoundedRectangle(cornerRadius: 10)
////                                    .foregroundColor(Color(hex : obj.color ?? ""))
////                                    .frame(width : 80, height: 20)
////                                Text(obj.text ?? "ABC")
////                                    .frame(width : 70)
////                                    .lineLimit(1)
////                                    .foregroundColor(Color.white)
////                            }
////
////                        }
//
//                    }.frame(width : geometry.size.width - 120, height : geometry.size.height/20, alignment:  .center)
//
//
//                    Button(action: {
//
//                        withAnimation(){
//                            self.popup.toggle()
//                            self.tagEdited.toggle()}
//                    }){
//                        Image(systemName: "plus.circle.fill")
//                            .font(.system(size:20))
//                            .foregroundColor(Color.gray)
//                    }
//                    .foregroundColor(.white)
//
//                }
//                    .padding(.leading)
//                    .padding(.trailing)
//
//                    VStack {
//
//                        DisclosureGroup("評価1 : \(self.eval_selected[0])", isExpanded: self.$eval_show[0]){
//
//                            ScrollView{
//
//                                LazyVStack(alignment: .leading, spacing: 15, pinnedViews: [], content: {
//                                    ForEach(1...20, id : \.self) { count in
//
//                                        Button(action:{
//                                            withAnimation{
//                                            self.eval_selected[0] = "評価" + String(count)
//                                            self.eval_show[0].toggle()
//                                            }
//                                        }){
//                                            Text("Country \(count)")}
//
//
//
//                                    }
//                                })
//                            }
//                            .animation(.default)
//                            .padding(.top)
//                            .frame(height:150,alignment: .top)
//                        }
//                        .padding(.all)
//                        .background(Color.black.opacity(0.06))
//                        .cornerRadius(12)
////                        .padding(.horizontal)
//
//                        Slider(value : self.$selected[0], in: 0...100,step:1,
//                               minimumValueLabel: Text("0"),
//                               maximumValueLabel: Text("100"),
//                               label: { EmptyView() }
//                        ).frame(alignment: .top)
//
//                    }
//                    .padding(.all)
//
//                    VStack {
//                        DisclosureGroup("評価2 : \(self.eval_selected[1])", isExpanded: self.$eval_show[1]){
//
//                            ScrollView{
//
//                                LazyVStack(alignment: .leading, spacing: 15, pinnedViews: [], content: {
//                                    ForEach(1...20, id : \.self) { count in
//                                        Button(action:{
//                                            self.eval_selected[1] = "Eval" + String(count)
//                                            self.eval_show[1].toggle()
//                                        }){
//                                        Text("Country \(count)")
//                                        }
//                                    }
//                                })
//                            }
//                            .padding(.top)
//                            .frame(height:150,alignment: .top)
//                        }
//                        .padding(.all)
//                        .background(Color.black.opacity(0.06))
//                        .cornerRadius(12)
////                        .padding(.horizontal)
//
//                        Slider(value : self.$selected[1], in: 0...100,step:1,
//                               minimumValueLabel: Text("0"),
//                               maximumValueLabel: Text("100"),
//                               label: { EmptyView() }
//                        ).frame(alignment: .top)
//
//                    }
//                    .padding(.all)
//
//                    VStack {
//                        DisclosureGroup("評価3 : \(self.eval_selected[2])", isExpanded: self.$eval_show[2]){
//
//                            ScrollView{
//
//                                LazyVStack(alignment: .leading, spacing: 15, pinnedViews: [], content: {
//                                    ForEach(1...20, id : \.self) { count in
//                                        Button(action : {
//                                            self.eval_selected[2] = "評価" + String(count)
//                                            self.eval_show[2].toggle()
//                                        }){
//                                        Text("評価 \(count)")
//                                    }
//                                    }
//                                })
//                            }
//                            .padding(.top)
//                            .frame(height:150,alignment: .top)
//                        }
//                        .padding(.all)
//                        .background(Color.black.opacity(0.06))
//                        .cornerRadius(12)
////                        .padding(.horizontal)
//
//                        Slider(value : self.$selected[2], in: 0...100,step:1,
//                               minimumValueLabel: Text("0"),
//                               maximumValueLabel: Text("100"),
//                               label: { EmptyView() }
//                        ).frame(alignment: .top)
//
//                    }
//                    .padding(.all)
//
//
//                    Spacer()
//                        .frame(height:100)
                    
                    }.padding(.all)
                //Saveボタンでアイディアを保存する処理
                        Button(action:{
                            withAnimation(){
                                self.add()
                                self.ideatext = ""
                            }
                        }){
                            
                            ZStack() {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width : 80,height : 30)
                                Text("Save")
                                    .foregroundColor(Color.white)
                                
                                
                            }
                            .shadow(radius:1,x:0,y:4)
                            .frame(width : 120,height : 30)
                            .padding(.bottom, 40)
                        }
                    }
                    
                }.padding(.bottom)
                
                if self.tagEdited {
//                    ZStack {
                        
                        RoundedRectangle(cornerRadius:10 ,style: .continuous)
                            .stroke(lineWidth: 10)
                            .fill(Color(hex:self.tagcolor))
                            .background(Color.white)
                            .frame(width:geometry.size.width - 15, height: geometry.size.height/3)
                        
                    VStack{
                        HStack {
                            Spacer()
                            Button(action: {
                                self.tagEdited.toggle()
                                self.popup.toggle()
                            }){
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.red)
                            }
                        }.frame(width:geometry.size.width - 50)
                        
                        
                        Text("タグを追加")
                            .bold()
                            .underline()
                        TextField("タグ名", text: self.$tagName)
                            .foregroundColor(Color(hex:self.tagcolor))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width:geometry.size.width - 200,alignment:.center)
                            
                        HStack{
                            ForEach(0..<9, id:\.self){
                                i in
                                HStack{
                                    Button(action: {
                                        self.tagcolor = self.hex[i]
                                       
                                    }){
                                    Circle()
                                    .fill(Color(hex: self.hex[i]))
                                        .frame(width:20,height:20)}
                                }
                            }
                        }
                        
                        Button(action: {
                            self.tagEdited.toggle()
                            self.tagAdd()
                        })
                        {
                            ZStack {
                                
                                RoundedRectangle(cornerRadius:10 ,style: .continuous)
                                .frame(width:80,height:30)
                                .foregroundColor(Color.blue)
                                Text("保存")
                                .foregroundColor(Color.white)
                                
                                
                            }
                        }
                    }
//                    }.animation(.default)
                }
            }
            
        }
        .background(Color("primary"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct MemoModalView_Previews: PreviewProvider {
    static var previews: some View {
        MemoModalView()
    }
}

struct Proverb : Identifiable {
    
    var id = UUID()
    var text : String
    var author : String
}

var data_proverb = [
    Proverb(text: "子供は子どもは誰でも芸術家だ。問題は大人になっても、芸術家でいられるかどうかだ",author: "パブロ・ピカソ"),
    Proverb(text: "もう描けない”という心の声を聞いても、とにかく描きなさい。そうすれば内なる声は聞こえなくなる", author: "ゴッホ"),
    Proverb(text: "最も良いアイデアは最初まずいアイデアに見えるものだ", author: "ポール・グレアム"),
    Proverb(text: "私はこれまで偶然のひらめきで価値ある発明をしたことなど一度もない。全ての発明というのは、その発明に関わった人の想像を絶するような熱意が注ぎ込まれているものなんだよ", author: "トーマス・エジソン"),
    Proverb(text: "アイデアという物は浮かんで直ぐに実行するより、少し寝かせて熟成させた方がいい場合が多い", author: "孫正義"),
    Proverb(text: "ボツになったアイデアは記録しておくべきだ。ボツになったアイデアの山が、別の人のインスピレーションの源となる場合もある", author: "フィリップ・コトラー")
]
