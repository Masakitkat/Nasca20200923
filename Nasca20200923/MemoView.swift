//
//  MemoView.swift
//  Nasca20200923
//
//  Created by masaki on 2020/09/24.
//

import SwiftUI
import CoreData



struct MemoView: View {

    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity : Idea.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Idea.date,ascending:false)]) var ideas : FetchedResults<Idea>
    
    @FetchRequest(entity : Tag.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Tag.date,ascending:false)]) var tags : FetchedResults<Tag>
    
    var hex = ["#EBCA3F","#D26873","#D26873","#2A34E1","#2A34E1","#EBCA3F","486d8b","d22b55","81b27f","#EBCA3F","#D26873","#D26873","#2A34E1","#2A34E1","#EBCA3F","486d8b","d22b55","81b27f"]
    
    var edges = UIApplication.shared.windows.first?.safeAreaInsets
    
    @State var activeSheet: ActiveSheet?
    
    @StateObject var IdeaData = IdeaFB()
    @AppStorage("stored_Username") var user = ""
    
//    let animation : Namespace.ID
    @Namespace private var animation
    
    @State var initial_tags : [Tag] = []
    
    @ObservedObject var init_tagtext = ini_tag()
    
    @State var tag_selected : [Tag] = []
    
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
    
    @State var proverbs = data_proverb.shuffled()
    @State var rand_ideas : [Idea] = []
    
    @State var i = 1
    
    @Binding var modal : Bool
    @State var game : Bool = false
    @State var conc_image = Color.white.opacity(0.3)
    @State var conc_text = ""
    @State var abst_image = Color.white.opacity(0.3)
    @State var abst_text = ""
    
    @State var shared = false
    
    
    func add() {

            let newidea = Idea(context: viewContext)
            var count = 0
            
            newidea.id = UUID()
            newidea.title = ideaTitle
//            newidea.text = ideatext
            newidea.eval1 = Int16(selected[0])
            newidea.eval2 = Int16(selected[1])
            newidea.eval3 = Int16(selected[2])
            newidea.eval1_text = eval_selected[0]
            newidea.eval2_text = eval_selected[1]
            newidea.eval3_text = eval_selected[2]
            newidea.date = Date()
            newidea.shared = shared
            
            
        while count < tag_selected.count || count == 0 && tag_selected.count != 0 {
                newidea.addToTag(tag_selected[count])
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
    
    func proverb_loop() {
     
        func iteration(){
            
            let i = Double.random(in: 1 ... 5)
                
                
            self.proverbs = self.proverbs.shuffled()
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + i) {
                iteration()
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            iteration()
        }
        
    }
    
    
    var body: some View {

//        NavigationView{
            ZStack {
                
                VStack {
                    if game != true {
                    ZStack{
                        Color.white.opacity(0.7)
                            .cornerRadius(10)
                            .blur(radius:5)
                            .padding(.vertical,10)

                    VStack(alignment : .leading) {
                        Text(self.proverbs[self.i].text)
                            .font(.system(size:20))
//                            .fontWeight(.heavy)
                        Spacer().frame(height : 5)
                        HStack{
                            Text(self.proverbs[self.i].author)
                         Spacer()
                            Button(action: {
                                
                                self.proverbs = self.proverbs.shuffled()
//                                self.i = Int.random(in: 1 ..< self.proverbs.count)
                                
                            }){
                                
                                Image(systemName: "arrow.counterclockwise")
                                
                            }
                        }.font(.caption)
                        .foregroundColor(.gray)
                    }
//                    .padding(.top)
                    .padding(.horizontal)
                    
                    }
                    .onAppear(perform: {
                        proverb_loop()
                    })
                    
//                    .padding(.top, 120)
                    
                    .frame(width: UIScreen.main.bounds.width - 20, height : UIScreen.main.bounds.height/4.5)
                    }
                    
                    else {
                        VStack{
                        Text("お題")
                            .bold()
                        ZStack{
                          
                            HStack(spacing : 10){
                                
                                ZStack {
                                RoundedRectangle(cornerRadius: 25)
//                                    .fill(Color.blue)
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                                Text(conc_text + abst_text)
                                    .foregroundColor(.white)
                                    .padding()
                                    
                                }.frame(width: UIScreen.main.bounds.width/1.3,height: 100)
//
//                                ZStack{
//                                RoundedRectangle(cornerRadius: 15)
//                                    .fill(LinearGradient(gradient: Gradient(colors: [self.abst_image, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
//                                Text(abst_text)
//
//                                }
                            }
                        }
                        
                        }.padding(.top, 100)
                        .frame(width: UIScreen.main.bounds.width - 20,height: 300)
                        
                    }
                    
//                Text("")
//                    .font(.system(size:45))
//                    .fontWeight(.heavy)
//                    .fixedSize()
//                    .frame(width: geometry.size.width - 50 ,height: geometry.size.height * 0.618 / 2 , alignment : .bottomLeading)
                
                    
                    ZStack(alignment: .center) {
                        RoundedRectangle(cornerRadius:15 ,style: .continuous)
                            .fill(Color(#colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1)))
//                            .frame(width:UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height/4)
                        VStack {
                            
                            TextField("思いついたことを書いてみよう！",text: self.$ideaTitle)
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .frame(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height/5)
                        }
                    }
                    .frame(width:UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height/4)
                    
                    if self.tag_selected.count > 0 {
                        
                        ScrollView(.horizontal,showsIndicators: false){
                            LazyHGrid(rows: [GridItem(.adaptive(minimum:200))], pinnedViews: [], content: /*@START_MENU_TOKEN@*/{
                                ForEach(self.tag_selected, id :\.self){ tag in
                                    
                                    let tagtext = tag.text ?? ""
                                    let tagcolor = tag.color ?? ""
                                    Button(action:{
                                        withAnimation{
                                        let index = self.tag_selected.compactMap({$0.text}).firstIndex(of: tag.text)
                                        self.tag_selected.remove(at: index!)
                                        }
                                    }){
                                    ZStack(alignment : .center){
                                        
                                        RoundedRectangle(cornerRadius: 25)
                                            .frame(height : 40)
                                            .foregroundColor(Color(hex :tagcolor).opacity(0.5))
                                          
                                        Text(tagtext.prefix(2))
                                            .bold()
                                            .padding()
                                            
                                    }
//                                    .matchedGeometryEffect(id: tag.text, in: animation)
                                    
                                    .contextMenu{
                                        Button(action: {
                                            let index = self.tag_selected.compactMap({$0.text}).firstIndex(of: tag.text)
                                            self.tag_selected.remove(at: index!)
                                            
                                        }, label: {
                                            Text("削除する")
                                        })
                                    }
                                    }
                                }
                            })
                        }
                        .padding(.horizontal)
                        .frame(height : 40)
                    }

                    ZStack(alignment: .bottomTrailing) {
                        
                        
                        ScrollView(showsIndicators: false) {
                            
                            //
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
                            //
                            
                            VStack(spacing :10){
                                
//                                Button(action:{withAnimation{
//                                        self.tag_show.toggle()}}){
                            DisclosureGroup("タグ",isExpanded : self.$tag_show){
                                
                                ScrollView(.vertical, showsIndicators: false){
                                    LazyVGrid(columns: [GridItem(.adaptive(minimum:100))], spacing: 10, pinnedViews: [], content: /*@START_MENU_TOKEN@*/{
                                        
                                        
                                        ForEach(self.tags, id :\.self){ tag in
                                            
                                            let tagtext = tag.text ?? ""
                                            let tagcolor = tag.color ?? ""
                                            
                                            let check = self.tag_selected.compactMap({$0.text}).contains(tagtext)
                                            
                                            if check != true {
                                            
                                            Button(action:{
                                                if self.tag_selected.compactMap({$0.text}).contains(tag.text) == false {
                                                    withAnimation{
                                                    self.tag_selected.append(tag)
                                                    }
                                                }
                                                
                                            }){
                                            ZStack(alignment : .leading){
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(Color(hex :tagcolor).opacity(0.5))
                                                    .zIndex(1)
                                                Text(tagtext)
                                                    .padding()
                                                    .foregroundColor(.black)
                                                    .zIndex(5)
                                                    
                                            }
//                                            .matchedGeometryEffect(id: tag.text, in: animation)
                                            .contextMenu{
                                                Button(action: {
                                                    viewContext.delete(tag)
                                                    try! viewContext.save()
                                                }, label: {
                                                    Text("Delete")
                                                })
                                            }
                                                
                                            }
                                            }
                                        }
                                        
                                        Button(action:{
                                            
                                            self.modal.toggle()
                                            
                                        }){
                                            ZStack(alignment : .leading) {
                                                
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(Color.white.opacity(0.3))
                                                
                                                Label(title :
                                                        {Text("タグを追加")},
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
                                .frame(height:250,alignment: .top)
                                
                            }
                            .padding(.all)
//                            .foregroundColor(Color.white)
                            .background(Color(#colorLiteral(red: 0.8823529412, green: 0.777484452, blue: 0.6784313725, alpha: 1)).opacity(0.5))
                            .cornerRadius(12)
                            .onTapGesture(count: 1, perform: {
                                withAnimation{
                                    self.tag_show.toggle()
                                }
                            })
                            
                            Toggle(isOn: $shared){
                                Text("共有しない")
                                    .bold()
                            }
                            .toggleStyle(SwitchToggleStyle(tint: Color("top")))
                            .padding(.horizontal,5)
                                
//                            .onTapGesture(count: 1, perform: {
//                                withAnimation{
//                                self.tag_show = true
//                                }
//                            })
//                                }.buttonStyle(PlainButtonStyle())
                            

//                            DisclosureGroup("評価",isExpanded : self.$eval_show){
//
//                                VStack {
//
//                                    Button(action:{withAnimation{
//                                            self.evals_show[0].toggle()}}){
//                                    DicloseView(expand_key: self.$evals_show[0], text1: self.$eval_selected[0], text2 : "\(self.eval_selected[0])")
//                                    }
//
//                                    Slider(value : self.$selected[0], in: 0...100,step:1,
//                                           minimumValueLabel: Text("0"),
//                                           maximumValueLabel: Text("100"),
//                                           label: { EmptyView() }
//                                    ).frame(alignment: .top)
//
//                                }
//                                .padding(.vertical)
//
//
//                                VStack {
//
//                                    Button(action:{withAnimation{
//                                            self.evals_show[1].toggle()}}){
//                                    DicloseView(expand_key: self.$evals_show[1], text1: self.$eval_selected[1], text2 : "\(self.eval_selected[1])")
//                                    }
//                                    Slider(value : self.$selected[1], in: 0...100,step:1,
//                                           minimumValueLabel: Text("0"),
//                                           maximumValueLabel: Text("100"),
//                                           label: { EmptyView() }
//                                    ).frame(alignment: .top)
//
//                                }
//                                .padding(.vertical)
//
//                                VStack {
//                                    Button(action:{withAnimation{
//                                            self.evals_show[2].toggle()}}){
//                                    DicloseView(expand_key: self.$evals_show[2], text1: self.$eval_selected[1], text2 : "\(self.eval_selected[2])")
//                                    }
//
//                                    Slider(value : self.$selected[2], in: 0...100,step:1,
//                                           minimumValueLabel: Text("0"),
//                                           maximumValueLabel: Text("100"),
//                                           label: { EmptyView() }
//                                    ).frame(alignment: .top)
//
//                                }
//                                .padding(.vertical)
//                            }
//                            .padding(.all)
//                            .background(Color(hex: "E8D6AE").opacity(0.6))
//                            //                    .background(Color.black.opacity(0.06))
//                            .cornerRadius(12)
//                                .buttonStyle(PlainButtonStyle())
//                            .onTapGesture(count: 2, perform: {
//                                withAnimation{
//                                self.eval_show = false
//                                }
//                            })
//                            .onTapGesture(count: 1, perform: {
//                                withAnimation{
//                                self.eval_show = true
//                                }
//                            })
                            }
                            
                            VStack(alignment : .leading) {
                                Text("関連するアイディア")
                                    .fontWeight(.bold)
                                    .padding(.horizontal,5)
//                                    .frame(width : 370, alignment : .leading)
                                
                                ScrollView(.horizontal,showsIndicators: false){
                                    
                                    LazyHGrid(rows: [GridItem(.adaptive(minimum:200))], alignment: .top, spacing: 10, pinnedViews: [], content: /*@START_MENU_TOKEN@*/{
                                        
                                        ForEach(self.rand_ideas, id :\.self){ idea in
                                        
                                            
                                            let ideatext = idea.title ?? ""
                                            
//                                            if  idea.tagArray.compactMap({$0.text}).contains(self.init_tagtext.text){
                                            
                                            ZStack(){
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(Color.white.opacity(0.3))
                                                Text(ideatext)
                                                    .padding()
                                            }.frame(width:200,height:100)
//                                            }
                                        }
                                        
                                    }).frame(height:150)
                                }
//                                .frame(width : 350)
//                                .padding(.horizontal)
                                
                                
                            }
                            .onAppear(perform: {
                                self.rand_ideas = self.ideas.shuffled()
                            })
                            
                            .padding(.vertical)
                            
                            
                            Spacer()
                                .frame(height:100)
                            
                        }
                        
                        .padding(.horizontal)
                        .padding(.top,1)
                        //Saveボタンでアイディアを保存する処理
                        Button(action:{
                            withAnimation(){
                                
                                if IdeaData.idea.compactMap({$0.title}).contains(ideaTitle) != true && shared != true {
                                    
                                    let index = IdeaData.idea.compactMap({$0.title}).firstIndex(of: ideaTitle)
                                    
                                    if IdeaData.idea[index ?? 0].user != self.user || index == nil {
                                        
                                        IdeaData.title = ideaTitle
                                        IdeaData.txt = ideatext
                                        
                                        if tag_selected.count > 0 {
                                            IdeaData.tag.append(tag_selected[0].text ?? "")
                                            IdeaData.tagcolor.append(tag_selected[0].color ?? "")
                                        }
                                        
                                        if tag_selected.count > 1 {
                                            IdeaData.tag.append(tag_selected[1].text ?? "")
                                            IdeaData.tagcolor.append(tag_selected[1].color ?? "")
                                        }
                                        
                                        IdeaData.writeMsg()
                                        
                                    }
                                }
                                
                                self.add()
                                self.ideatext = ""
                                self.ideaTitle = ""
                                self.tag_selected.removeAll()
                                self.shared = false
                                if init_tagtext.text != "" {
                                    
                                    let index = tags.compactMap({$0.text}).firstIndex(of: init_tagtext.text)
                                    tag_selected.append(tags[index!])
                                    
                                }
                                if init_tagtext.text2 != "" {
                                    
                                    let index = tags.compactMap({$0.text}).firstIndex(of: init_tagtext.text2)
                                    tag_selected.append(tags[index!])
                                    
                                }
                                
                               
                                
                                
                            }
                        }){
                            
                            ZStack() {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width : 80,height : 40)
                                Text("Save")
                                    .foregroundColor(Color.white)
                            }
                            .shadow(radius:1,x:0,y:4)
                            .frame(width : 120,height : 30)
                            .padding(.bottom, 60)
                        }.disabled(self.ideaTitle == "" ? true : false)
                        .foregroundColor(Color("top"))
                        .buttonStyle(GradientButtonStyle())
                        .opacity(self.ideaTitle == "" ? 0.5 : 1)
                        
                    }
                }.padding(.bottom)
                .disabled(self.tagEdited)
//                .frame(height : modal ? UIScreen.main.bounds.height + 50 : nil)
//                .offset(y : modal ? -50 : 0)
                
                
                if self.tagEdited {
                    //                    ZStack {
                    ZStack(alignment:.center){
                    RoundedRectangle(cornerRadius:10 ,style: .continuous)
                        .foregroundColor(Color.white.opacity(0.9))
                        
                    
                        VStack(spacing : 10){
                            
                        HStack {
                            Spacer()
                            Button(action: {
                                self.tagEdited.toggle()
                                self.popup.toggle()
                            }){
                                Image(systemName: "xmark")
                                    .foregroundColor(Color.red)
                            }.padding(.horizontal, 20)
                            .offset(y:10)
                        }
                        
                        
                        Text("タグを追加")
                            .bold()
                            .foregroundColor(.blue)
                        TextField("タグ名", text: self.$tagName)
                            .foregroundColor(Color(hex:self.tagcolor))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width:UIScreen.main.bounds.width - 100,alignment:.center)
                        
                            ScrollView(.horizontal){
                                HStack{
                                    ForEach(0..<self.hex.count, id:\.self){
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
                                .padding(.horizontal)
                                .frame(width : 500,height : 30, alignment : .top)
                            }.padding(.horizontal)
                        
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

                    }
                    .frame(width:UIScreen.main.bounds.width - 80, height: 190)
                    
                    //                    }.animation(.default)
                }
                
                
            }
            .background(Color("primary"))
            .edgesIgnoringSafeArea(.all)
            .onAppear(perform: {
                if init_tagtext.text != "" {
                    
                    let index = tags.compactMap({$0.text}).firstIndex(of: init_tagtext.text)
                    tag_selected.append(tags[index!])
                    
                }
                if init_tagtext.text2 != "" {
                    
                    let index = tags.compactMap({$0.text}).firstIndex(of: init_tagtext.text2)
                    tag_selected.append(tags[index!])
                    
                }
            })
//        }
            
    }
}
//
//struct MemoView_Previews: PreviewProvider {
//    static var previews: some View {
//        return MemoView()
//    }
//}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct Evaluation : Identifiable {
    
    var id = UUID()
    var title : String
}

var data_eval = [
    Evaluation(title: "拡張性"),
    Evaluation(title: "新規性"),
    Evaluation(title: "面白さ"),
    Evaluation(title: "熱意"),
    Evaluation(title: "楽しさ"),
    Evaluation(title: "地味さ"),
    Evaluation(title: "美しさ"),
    Evaluation(title: "ありきたりさ"),
    Evaluation(title: "ロマン度"),
    Evaluation(title: "エロさ"),
    Evaluation(title: "派手さ"),
]

struct DicloseView : View {
    
    @Binding var expand_key : Bool
    @Binding var text1 : String
    @State var text2 : String
    
    var body : some View {
        
        DisclosureGroup(text2, isExpanded: $expand_key){
            
            ScrollView(showsIndicators: false){
                
                LazyVStack(alignment: .leading, spacing: 15, pinnedViews: [], content: {
                    ForEach(0..<data_eval.count, id : \.self) { i in
                        
                        Button(action:{
                            withAnimation{
                                text1 = data_eval[i].title
                                text2 = data_eval[i].title
                                expand_key.toggle()
                            }
                        }){
                            Text(data_eval[i].title)
                            //                                .foregroundColor(.white)
                        }
                        .contextMenu{
                            Button(action: {}, label: {
                                Text("Edit")
                            })
                        }
                        
                    }
                    
                })
            }
            .animation(.default)
            .padding(.top)
            .frame(height:150,alignment: .top)
        }
        .padding(.all)
        //        .background(Color.black.opacity(0.06))
        .background(Color.white.opacity(0.5))
        //        .background(Color(hex: "96743B").opacity(0.7))
        .cornerRadius(12)
        
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

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
//            .cornerRadius(15.0)
            .padding(.bottom)
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
    }
}

class ini_tag : ObservableObject {
 
    @Published var text : String = ""
    @Published var text2 : String = ""
    
    init(){
        
        text = ""
        text2 = ""
        
    }
}
//
//struct MemoView_Previews: PreviewProvider {
//    static var previews: some View {
//            MemoView()
//    }
//}
