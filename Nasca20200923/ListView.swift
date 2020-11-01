//
//  ListView.swift
//  Nasca20200923
//
//  Created by masaki on 2020/09/24.
//

import SwiftUI
import CoreData

enum ActiveSheet : Identifiable {
   case tag, memo
    
   var id: Int {
        hashValue
    }
}

struct ListView : View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity : Idea.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Idea.date, ascending: false)],
        animation: .default)
    private var ideas: FetchedResults<Idea>
    
    @FetchRequest(entity : Tag.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.date, ascending: false)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    
    @ObservedObject var init_tagtext = ini_tag()
    
    var hex = ["#EBCA3F","#D26873","#D26873","#2A34E1","#2A34E1","#EBCA3F","486d8b","d22b55","81b27f","#EBCA3F","#D26873","#D26873","#2A34E1","#2A34E1","#EBCA3F","486d8b","d22b55","81b27f"]
    @State private var tagName : String = ""
    @State private var tagcolor : String = "#031b4e"
    

    @State var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @State var selectedTab = "レベル１"
    @State var width = UIScreen.main.bounds.width
    @State var show = false
    @State var selectedIndex = ""
    @State var colorstate = false
    @State var isActive = false
    @State var test = false
    @Binding var tophide : Bool
    
    @State var tag_selected : Tag?
    @State var tag_selected_2 : Tag?
    @State var tag_selectedbutton = false
    @State var tag_selectedbutton_2 = false
    @State var tag_choiced = true
    @State var tag_choiced_2 = true
    
    @State var tagview1 = true
    @State var tagview2 = false
    
    @State var show_tagsetting = false
    
    @State var tag_temp = ""
    
    @State var modal = false
    @State var activeSheet: ActiveSheet?
    
    @State var liststyle = false
    
    var maxheight = UIScreen.main.bounds.height
    var maxwidth = UIScreen.main.bounds.width
    
//    @Namespace var animation
    let animation : Namespace.ID
    
    @State var tagadding = false
    
    @State var initial_tags : [Tag?] = []
    
    var body: some View{
        
        NavigationView{
        
        ZStack {
            VStack(spacing: 0){
                
                VStack{
//                 ZStack{
//
//                     HStack{
//
//                         Button(action: {
//                            withAnimation(.spring()){
//                                show.toggle()
//                            }
//                         }, label: {
//
//                             Image(systemName: "line.horizontal.3")
//                                 .font(.system(size: 22))
//                         })
//
//                         Spacer(minLength: 0)
//
//                         Button(action: {}, label: {
//
//                             Image(systemName: "magnifyingglass")
//                                 .font(.system(size: 22))
//                         })
//                     }
//
//                     Text("Idea List")
//                         .font(.title2)
//                         .fontWeight(.semibold)
//                 }
////                 .padding()
//                 .padding(.top,edges!.top)
//                 .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                 
                    
//                 HStack(spacing: 20){
//
//                     ForEach(tabs,id: \.self){title in
//
//                         TabButton(selectedTab: $selectedTab, title: title, animation: animation)
//                     }
//
//                 }
//                 .padding()
//                 .background(Color.white.opacity(0.08))
//                 .cornerRadius(15)
//                 .padding(.vertical)
//                 .padding(.horizontal)
             }
                .frame(height : 101.5)
             .padding(.top)
             .background(Color("top"))
             .clipShape(CustomCorner(corner: .bottomLeft, size: 65))
             
             ZStack{
                 
                 Color("top")
                 
                 Color("primary")
                     .clipShape(CustomCorner(corner: .topRight, size: 83))
                
                VStack(spacing: 10){
                    
                    
                    if tag_selectedbutton_2 == false && tag_selectedbutton == false {
                    
                    HStack{
//                       else {
                        Text("あなたのリスト")
                            .font(.title2)
                            .fontWeight(.bold)
                        
//                       }
                       
                        Spacer(minLength: 0)
                        
                        Button(action: {
                            withAnimation{
                            
                            }
                        }, label: {
                            
                            Image(systemName :"magnifyingglass")
                                .font(.system(size: 22))
                                .foregroundColor(Color("top"))
                        })
                        .buttonStyle(ExpandButtonStyle())
                        .padding(.trailing)
                        
                        
                        
                        
                    }
                    .frame(height : 30)
                    .padding(.horizontal,15)
//                    .padding(.horizontal,20)
                    .padding(.top,30)
                    }
                    else if tag_selectedbutton {
                        
                        
//                        if tag_selectedbutton {
                        HStack{
                         Text("メインタグ：")
                             .font(.title2)
                             .fontWeight(.bold)
                         
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 10)
                             .foregroundColor(Color(hex :tag_selected?.color ?? "").opacity(0.5))
                         Text(tag_selected?.text ?? "")
                             .bold()
                             
                        
                        }.frame(width : 140,alignment : .leading)
                        .onTapGesture(perform: {
                         withAnimation{
                            self.tag_choiced = true
                            self.tag_selectedbutton = false
                            self.tag_selected = nil
                            self.init_tagtext.text = ""
                         }
                        })
                        .matchedGeometryEffect(id: tag_selected?.text, in: animation)
                            
                            Spacer()
                        }.frame(height : 30)
                        .padding([.horizontal,.top],20)
//                        }
                        
                        
                        
                    }
                    
                    
                    if tag_selectedbutton_2 {
                        HStack{
                            Text("サブタグ　：")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(hex :tag_selected_2?.color ?? "").opacity(0.5))
                                Text(tag_selected_2?.text ?? "")
                                    .bold()
                                
                                
                            }.frame(width : 140,alignment : .leading)
                            .onTapGesture(perform: {
                                withAnimation{
                                    self.tag_choiced_2 = true
                                    self.tag_selectedbutton_2 = false
                                    self.tag_selected_2 = nil
                                    self.init_tagtext.text2 = ""
                                }
                            })
                            .matchedGeometryEffect(id: tag_selected_2?.text, in: animation)
                            
                            Spacer()
                            
                        }.frame(height : 30)
                        .padding(.horizontal,20)
                        .padding(.top, self.tag_selectedbutton ? 0 : 20)
                        
                    }
                    
                    if tag_choiced {
                    
                    HStack{
                        
                        Text("タグ")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        Button(action:{
                            withAnimation{
                            self.tagview1.toggle()
                            }
                        }){
                            Image(systemName : self.tagview1 ? "minus" : "plus")
                            .font(.system(size: 15))
                            .font(.caption)
                            .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                    }
                    .padding(.horizontal)
                        if self.tagview1 {
                        ScrollView(.horizontal,showsIndicators: false){
                            LazyHGrid(rows: [GridItem(.adaptive(minimum:100))], alignment: .center, spacing: 10, pinnedViews: [], content: /*@START_MENU_TOKEN@*/{
                                ForEach(self.tags, id :\.self){ tag in
                                    
                                    let tagtext = tag.text ?? ""
                                    let tagcolor = tag.color ?? ""
                                    
                                    if tag.issub != true {
                                    
                                    Button(action:{
                                        
                                        self.tag_selected = tag
                                        self.init_tagtext.text = tag.text ?? ""
                                        self.tag_selectedbutton = true
                                        self.tag_choiced = false
                                        tag.choice = false
                                        
                                    }){
                                        
                                        ZStack(alignment : .leading){
                                            
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(hex :tagcolor).opacity(0.5))
                                            Text(tagtext)
                                                .padding()
                                        }
                                    }.matchedGeometryEffect(id: tag.text, in: animation)
                                    .contextMenu{
                                        Button(action: {
                                            self.tagName = tag.text ?? ""
                                            self.tagcolor = tag.color ?? ""
                                            self.tag_temp = tag.text ?? ""
                                            
                                            self.activeSheet = .tag
                                            
                                        }, label: {
                                            Text("Edit")
                                        })
                                        Button(action: {
                                            viewContext.delete(tag)
                                            try! viewContext.save()
                                        }, label: {
                                            Text("Delete")
                                        })
                                    }
                                    }
                                }
                                
                                Button(action:{
//                                    self.tagadding.toggle()
                                    self.activeSheet = .tag
                                }){
                                    
                                    ZStack(alignment : .leading){
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color.white.opacity(0.3))
                                        Text("タグを追加する")
                                            .foregroundColor(.blue)
                                            .padding()
                                    }
                                }
                            }
                            
                            
                            )
                            
                            
                            
                        }
                        .frame(height : 55)
                        .padding(.horizontal,5)
                        }
                        
                    }
                    
                   
                    
                    if tag_choiced_2 {
                    
                    HStack{
                        
                        Text("サブタグ")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Button(action:{
                            withAnimation{
                            self.tagview2.toggle()
                            }
                        }){
                            Image(systemName : self.tagview2 ? "minus" : "plus")
                            .font(.system(size: 15))
                            .font(.caption)
                            .foregroundColor(.gray)
                                .padding(.trailing)
                        }
                    }
                    .padding(.horizontal)
                        if self.tagview2 {
                        ScrollView(.horizontal,showsIndicators: false){
                            LazyHGrid(rows: [GridItem(.adaptive(minimum:100))], alignment: .center, spacing: 10, pinnedViews: [], content: /*@START_MENU_TOKEN@*/{
                                ForEach(self.tags, id :\.self){ tag in
                                    
                                    let tagtext = tag.text ?? ""
                                    let tagcolor = tag.color ?? ""
                                    
                                    if tag.issub {
                                    
                                    Button(action:{
                                        
                                        self.tag_selected_2 = tag
                                        self.init_tagtext.text2 = tag.text ?? ""
                                        self.tag_selectedbutton_2 = true
                                        self.tag_choiced_2 = false
                                        tag.choice = false
                                        
                                    }){
                                        
                                        ZStack(alignment : .leading){
                                            
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color(hex :tagcolor).opacity(0.5))
                                            Text(tagtext)
                                                .padding()
                                        }
                                    }
                                    .matchedGeometryEffect(id: tag.text, in: animation)
                                    .contextMenu{
                                        Button(action: {
                                            self.tagName = tag.text ?? ""
                                            self.tagcolor = tag.color ?? ""
                                            self.tag_temp = tag.text ?? ""
                                            
                                            
                                            
                                        }, label: {
                                            Text("Edit")
                                        })
                                        Button(action: {
                                            viewContext.delete(tag)
                                            try! viewContext.save()
                                        }, label: {
                                            Text("Delete")
                                        })
                                    }
                                    
                                }
                                    
                                }
                                
                                Button(action:{
                                    self.activeSheet = .tag
                                }){
                                    
                                    ZStack(alignment : .leading){
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color.white.opacity(0.3))
                                        Text("タグを追加する")
                                            .foregroundColor(.blue)
                                            .padding()
                                    }
                                }
                            }
                            
                            
                            )
                            
                            
                            
                        }
                        .frame(height : 55)
                        .padding(.horizontal,5)
                        }
                    }
                    
                    HStack{
                        
                        Text("アイディア")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {
                            withAnimation{
                            self.liststyle = false
                            }
                        }, label: {
                            
                            Image(systemName: self.liststyle ? "rectangle.grid.1x2" : "rectangle.grid.1x2.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color("top"))
                        })
                        .buttonStyle(ExpandButtonStyle())
                        
                        Button(action: {
                            withAnimation{
                            self.liststyle=true
                            }
                        }, label: {
                            
                            Image(systemName: self.liststyle ? "rectangle.grid.2x2.fill" : "rectangle.grid.2x2")
                                .font(.system(size: 20))
                                .foregroundColor(Color("top"))
                        })
                        .buttonStyle(ExpandButtonStyle())
                        .padding(.trailing,5)
                        
                    }
                    .padding(.horizontal)
                    
                 ScrollView(.vertical, showsIndicators: false, content: {
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum : liststyle ? maxwidth/3 :  maxwidth/2))], pinnedViews: [], content: /*@START_MENU_TOKEN@*/{
                    
                        ForEach(self.ideas, id: \.self){idea in
                            
                            
                            if  idea.tagArray.compactMap({$0.text}).contains(tag_selected?.text) || tag_selected == nil {
                                if  idea.tagArray.compactMap({$0.text}).contains(tag_selected_2?.text) || tag_selected_2 == nil {
                                    
                                    IdeaView(idea:idea, liststyle : $liststyle)
//                                        .contextMenu{
//                                            Button(action: {}, label: {
//                                                Text("Edit")
//                                            })
//                                            Button(action: {
//                                                viewContext.delete(idea)
//                                                try! viewContext.save()
//                                            }, label: {
//                                                Text("Delete")
//                                            })
//                                        }
                                }
                            }
                            
                        }
                    })
                    .frame(width : maxwidth-10)
                    
                            ZStack {
                               
                               RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.white.opacity(0.3))
                                   .padding(.horizontal,10)
                                   .frame(height: 100)
                            HStack(spacing: 10){
                               
                               
                                Button(action:{
                                    self.activeSheet = .memo
                                    self.modal.toggle()
                                }){
                                VStack(alignment: .leading, spacing: 20, content: {
                                    
                                    Label(title :
                                            {Text("アイディアを追加")},
                                          icon :
                                            {Image(systemName: "plus")}
                                    )
                                    .foregroundColor(Color.blue)
                                    .padding()
                                   
                                }).padding(.vertical,10)
                                }
                                Spacer(minLength: 0)
                                
                                
                            }.padding(.horizontal,25)
                            }
                            
                        
                        
                    
                        Spacer()
                            .frame(height : 200)
                     
                 })
                 
                 .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                
                 }
//                 .padding(.vertical)
                .padding(.bottom)
                 // its cutting off inside view may be its a bug....
                
//                ZStack {
//                    Button(action: {
//                        self.test.toggle()
//
//                    }, label: {
//                    Image(systemName:"plus")
//                        .font(.subheadline)
//                        .foregroundColor(Color.gray)
//                        .padding(20)
//                        .background(
//                        
//                            Color(#colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1))
//                        )
//                        .clipShape(Circle())
//                }).padding()
//                    .buttonStyle(GradientButtonStyle())
//                }
//                .frame(width: UIScreen.main.bounds.width,height :UIScreen.main.bounds.height / 1.5, alignment: .bottomTrailing)
//                .frame(width: UIScreen.main.bounds.width, height :UIScreen.main.bounds.height, alignment: .bottomLeading)

             }
         }
            .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height)
         .background(Color("primary").ignoresSafeArea(.all, edges: .all))

            if self.show_tagsetting {
                //                    ZStack {
                ZStack(alignment:.center){
                RoundedRectangle(cornerRadius:10 ,style: .continuous)
                    .foregroundColor(Color.white.opacity(0.9))
                    
                
                    VStack(spacing : 10){
                        
                    HStack {
                        Spacer()
                        Button(action: {
                            self.show_tagsetting.toggle()
                        }){
                            Image(systemName: "xmark")
                                .foregroundColor(Color.red)
                        }.padding(.horizontal, 20)
                        .offset(y:10)
                    }
                    
                    
                    Text("タグを編集")
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
                        
                        
                        let index = tags.compactMap({$0.text}).firstIndex(of: self.tag_temp)
                        tags[index!].text = self.tagName
                        tags[index!].color = self.tagcolor
                        
                        do {
                            try viewContext.save()
                        } catch {
                            print(error)
                        }
                        
                        self.show_tagsetting.toggle()
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
            
            
            if self.tagadding {
                //                    ZStack {
                ZStack(alignment:.center){
                RoundedRectangle(cornerRadius:10 ,style: .continuous)
                    .foregroundColor(Color.white.opacity(0.9))
                    
                
                    VStack(spacing : 10){
                        
                    HStack {
                        Spacer()
                        Button(action: {
                            self.tagadding.toggle()
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
                        self.tagadding.toggle()
                        
                        let addTag = Tag(context: viewContext)
                        addTag.text = self.tagName
                        addTag.color = self.tagcolor
                        
                        do {
                            try viewContext.save()
                        } catch {
                            print(error)
                        }
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
        .sheet(item : $activeSheet) { item in
            switch item {
            case .tag:
                TagModalView(tagname : self.tagName, tagcolor : self.tagcolor, activeSheet : $activeSheet)
            case .memo:
                MemoModalView(ini_tagtext: self.init_tagtext)
            }
        }
        
        
        .ignoresSafeArea(.all)
        }
    }
}

var tabs = ["分類","場面"]

struct TabButton : View {
    
    @Binding var selectedTab : String
    
    var title : String
    var animation : Namespace.ID
    
    var body: some View{
        
        Button(action: {
            
            withAnimation{
                
                selectedTab = title
            }
            
        }, label: {
            
            Text(title)
                .foregroundColor(.white)
                .padding(.vertical,8)
                .padding(.horizontal)
                // Sliding Effect...
                .background(
                
                    ZStack{
                        
                        if selectedTab == title{
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("top"))
                                .matchedGeometryEffect(id: "Tabs", in: animation)
                        }
                    }
                )
        })
    }
}

struct IdeaView : View {
    
//     var chatData : Chat
    var idea : Idea
    
    var maxheight = UIScreen.main.bounds.height
    var maxwidth = UIScreen.main.bounds.width
    
    @Binding var liststyle : Bool
    
   var dateformatter: DateFormatter {
           let dformat = DateFormatter()
           dformat.dateStyle = .short
           dformat.timeStyle = .short
           dformat.dateFormat = "yyyy/MM/dd HH:mm"
        return dformat
       }
   
    
    var body: some View{
        NavigationLink(destination:ListDetail(idea:idea)){
//        ZStack {
//
//           RoundedRectangle(cornerRadius: 20)
//            .foregroundColor(Color.white.opacity(0.6))
//               .padding(.horizontal,10)
//               .frame(height: 100)
//        HStack(spacing: 10){
//
//           VStack {
//           Circle()
//            .frame(width :10, height: 10)
//            .foregroundColor(idea.tagArray.count == 0 ? .yellow : Color(hex : idea.tagArray[0].color ?? "") )
//           Spacer(minLength: 0)
//           }
//           .padding(.vertical,16)
////             Image(chatData.image)
////                 .resizable()
////                 .aspectRatio(contentMode: .fill)
////                 .frame(width: 55, height: 55)
////                 .cornerRadius(10)
//
//            VStack(alignment: .leading, spacing: 5, content: {
//
//                VStack(alignment: .leading, spacing: 5){
//
//                Text(idea.title ?? "")
//                    .fontWeight(.bold)
////                    .frame(height : liststyle ? 65 : nil,alignment : .topLeading)
////                    .frame(alignment : .top)
//                    .lineLimit(liststyle ? 3 : 2)
//                    if liststyle != true  {
//                Text(idea.text ?? "")
//                   .font(.caption)
////                    .frame(height :40)
//                   .lineLimit(2)
//                    }
//
//                }
//                .frame(width : liststyle ? (maxwidth/1.9)-80 : maxwidth-80,height : liststyle ? 65 : 60, alignment : .topLeading)
//
                

//            }).padding(.vertical,10)
//
//            if liststyle != true {
//            Spacer(minLength: 0)
//            }
//
//
//        }
//        .padding(.horizontal,25)
//
//
//        }.frame(width : liststyle ? maxwidth/1.9 : maxwidth)
            ZStack {
               
               RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color.white.opacity(0.6))
                   .padding(.horizontal,10)
    //            .frame(minHeight : 100, maxHeight: 150)
                VStack(spacing : 10){
                HStack{
                    
                    Circle()
                        .frame(width:10,height : 10)
                        .foregroundColor(idea.tagArray.count == 0 ? .yellow : Color(hex : idea.tagArray[0].color ?? "") )
                    Text(idea.title ?? "")
                        .fontWeight(.bold)
                        .lineLimit(5)
                    
                    Spacer()
                    
                }
                    
                    if self.liststyle != true {
                    HStack{
                        Spacer()
                            .frame(width:20)
                        Text(idea.text ?? "")
                    .font(.caption)
                    .lineLimit(3)
                    }.frame(width : liststyle ? (maxwidth-50)/2 : maxwidth-50,alignment : .leading)
                }
                    HStack{
                        
                        Spacer()
                            .frame(width:20)
                        
                        if liststyle != true {
                    Text(idea.date ?? Date(), formatter: dateformatter)
                       .font(.system(size: 10))
                       .foregroundColor(.gray)
                       .font(.caption)


                        Spacer()
                        }
                            Image(systemName: "heart.fill")
                                .foregroundColor(Color.red.opacity(0.6))
                                .font(.caption)
                            Text("\(Int.random(in : 1..<5))")
                                .font(.caption)


                            Image(systemName:"bubble.right.fill")
                                .foregroundColor(Color.yellow.opacity(0.6))
                                .font(.caption)
                            Text("\(Int.random(in : 1..<5))")
                                .font(.caption)

                            Image(systemName:"arrowshape.turn.up.right.fill")
                                .foregroundColor(Color.blue.opacity(0.6))
                                .font(.caption)
                            Text("\(Int.random(in : 1..<5))")
                                .font(.caption)
                        
                        if liststyle {
                            
                            Spacer(minLength: 0)
                        }
                        
                    }.frame(alignment : .center)
                    
                }
                .frame(width : liststyle ? (maxwidth-50)/2 : maxwidth-50)
                .padding(.vertical)
            }
            .frame(maxHeight: liststyle ? 150 : idea.text != "" ? 120 : 100)
            .frame(width : liststyle ? maxwidth/1.9 : maxwidth)
            .padding(.horizontal)
            
        }
        
    }
}


struct HomeData {
    
    var groupName : String
    var groupData : [Chat]
}

var data2 = [

    // Group 1
    HomeData(groupName: "Friends", groupData: FriendsChat),
    // Group 2
    HomeData(groupName: "Group Message", groupData: GroupChat)
]

struct Chat : Identifiable {
    
    var id = UUID().uuidString
    var name : String
    var image : String
    var msg : String
    var time : String
}

var FriendsChat : [Chat] = [

    Chat(name: "iJustine",image: "i6", msg: "Hey EveryOne !!!", time: "2020/08/15"),
    Chat(name: "Kavsoft",image: "i1", msg: "Learn - Develop - Deploy", time: "2020/08/15"),
    Chat(name: "SwiftUI",image: "i2", msg: "New Framework For iOS", time: "2020/08/15"),
    Chat(name: "Bill Gates",image: "i3", msg: "Founder Of Microsoft", time: "2020/08/15"),
    Chat(name: "Tim Cook",image: "i4", msg: "Apple lnc CEO", time: "2020/08/15"),
    Chat(name: "Jeff",image: "i5", msg: "I dont Know How To Spend Money :)))", time: "08:22"),
]

var GroupChat : [Chat] = [

    Chat(name: "iTeam",image: "i6", msg: "Hey EveryOne !!!", time: "02:45"),
    Chat(name: "Kavsoft - Developers",image: "i1", msg: "Next Video :))))", time: "03:45"),
    Chat(name: "SwiftUI - Community",image: "i2", msg: "New File Importer/Exporter", time: "04:55"),
]
