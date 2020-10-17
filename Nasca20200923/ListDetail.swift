//
//  ListDetail.swift
//  Nasca20200923
//
//  Created by masaki on 2020/10/07.
//

import SwiftUI

struct ListDetail: View {
    
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(entity : Idea.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Idea.title,ascending:true)]) var ideas : FetchedResults<Idea>
    @FetchRequest(entity : Tag.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Tag.text,ascending:true)]) var tags : FetchedResults<Tag>
    
    @State var selected : [Double] = [1,2,3]
    @State var button = false
    @State private var concept : String = ""
    @State var eval_show = false
    @State var evals_show : [Bool] =  [false,false,false]
    @State var eval_selected : [String] = ["新規性","拡張性","親和性"]
    @State var eval_highlight : [Int] = [0,0,0]
    @State var tag_show = false
    @State var tagEdited = false
    @State var text_show = false
    @State var photo_show = false
    @State var pro_show = false
    
    @State var ideatitle = ""
    @State var ideatext = ""
    
    var idea : Idea
    
    var dateformatter: DateFormatter {
     //let dt = idea.date
        let dformat = DateFormatter()
        dformat.dateStyle = .short
        dformat.timeStyle = .short
        dformat.dateFormat = "yyyy/MM/dd HH:mm"
     //let strdt = dformat.string(from: dt!)
     return dformat
    }
    
    func update() {
            let newidea = Idea(context: viewContext)
            newidea.id = UUID()
    //        newidea.title = ideaTitle
    //        newidea.text = ideaName
            newidea.eval1 = Int16(selected[0])
            newidea.eval2 = Int16(selected[1])
            newidea.eval3 = Int16(selected[2])
            newidea.date = Date()

            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    
   
    
    var body: some View {

        VStack() {
            VStack(alignment : .leading,spacing : 10){
                
//                Text((idea.title == "" ? idea.text ?? "" : idea.title) ?? "")
                Text(self.ideatitle)
                    .bold()
                    .font(.title)
                    .frame(height : self.ideatitle.count >= 10 ? 110 : 90)
                    .padding(.horizontal,1)
                    .padding(.top)
                
//                HStack{
                ZStack{
                Capsule()
                    .fill(Color.green.opacity(0.9))
                    .frame(height : 30)
                    .padding(.bottom)
                    ZStack{
                        
                        let rand_int = Double.random(in: 1 ... 3)
                        
                Capsule()
                    .fill(Color.white.opacity(0.8))
                    .frame(width : UIScreen.main.bounds.width/CGFloat(rand_int) - 30, height : 30)
                        Text("熟成中")
                            .foregroundColor(Color.black.opacity(0.8))
                    }
                    .padding(.bottom)
                    .frame(width : UIScreen.main.bounds.width-30, alignment : .leading)
                }
                        
                        HStack{
                            
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.green.opacity(0.5))
                                    .frame(width : UIScreen.main.bounds.width/3-15 , height : 50)
                                VStack{
                                Text(idea.eval1_text)
                                    .bold()
                                    .foregroundColor(.white)
                                Text(String(idea.eval1))
                                    .bold()
                                    .foregroundColor(.white)
                                }
                            }
                            
                            ZStack{
                             
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.orange.opacity(0.5))
                                    .frame(width : UIScreen.main.bounds.width/3 - 15, height : 50)
                                VStack{
                                    Text(idea.eval2_text)
                                        .bold()
                                        .foregroundColor(.white)
                                Text(String(idea.eval2))
                                    .bold()
                                    .foregroundColor(.white)
                                }
                            }
                            
                            ZStack{
                             
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.blue.opacity(0.5))
                                    .frame(width : UIScreen.main.bounds.width/3-15, height : 50)
                                VStack{
                                    Text(idea.eval3_text)
                                        .bold()
                                        .foregroundColor(.white)
                                    Text(String(idea.eval3))
                                        .bold()
                                        .foregroundColor(.white)
                                }
                                
                            }
                        }
                        .frame(height : 50)

                    
//                }
                
                Text("\(self.dateformatter.string(from: self.idea.date!))")
                    .font(.caption)
                
                if idea.tagArray.count > 0 {
                ScrollView(.horizontal,showsIndicators: false){
                    LazyHGrid(rows: [GridItem(.adaptive(minimum:200))], pinnedViews: [], content: /*@START_MENU_TOKEN@*/{
                        ForEach(idea.tagArray, id :\.self){ tag in
                            
                            let tagtext = tag.text ?? ""
                            let tagcolor = tag.color ?? ""
                            
                            ZStack(alignment : .leading){
                                
                                RoundedRectangle(cornerRadius: 30)
                                    .frame(height : 25)
                                    .foregroundColor(Color(hex :tagcolor).opacity(0.5))
                                Text(tagtext.prefix(10))
                                    .bold()
                                    .padding()
                            }
                        }
                    })
                }.frame(height : 30)
            }
            }
            .padding(.horizontal)
            .frame(width : UIScreen.main.bounds.width, alignment : .topLeading)
            
            
            
            
            Divider()
                .padding(.horizontal)
            
            ScrollView(.vertical,showsIndicators: false){
                
                //            .padding(.horizontal)
                
                
                Button(action:{
                    withAnimation{
                        self.tag_show.toggle()}}){
                DisclosureGroup("タグ",isExpanded : self.$tag_show){
                    
                    ScrollView(.vertical, showsIndicators: false){
                        LazyVGrid(columns: [GridItem(.adaptive(minimum:120))], spacing: 10, pinnedViews: [], content: /*@START_MENU_TOKEN@*/{
                            ForEach(self.tags, id :\.self){ tag in
                                
                                let tagtext = tag.text ?? ""
                                let tagcolor = tag.color ?? ""
                                Button(action:{
                                    if self.idea.tagArray.compactMap({$0.text}).contains(tag.text) == false {
                                        idea.addToTag(tag)
                                    }
                                    else {
                                        
                                        idea.removeFromTag(tag)
                                        
                                    }
                                    
                                }){
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
                            }
                            
                            Button(action:{
                                
                                self.tagEdited.toggle()
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
                    .frame(height:150,alignment: .top)
                    
                }
                .padding(.all)
                .background(Color.black.opacity(0.06))
                .cornerRadius(12)
                }.buttonStyle(PlainButtonStyle())
                
                
                DisclosureGroup("評価",isExpanded : self.$eval_show){
                    
                    VStack {
                        Button(action:{withAnimation{
                                self.evals_show[0].toggle()}}){
                        DicloseView(expand_key: self.$evals_show[0], text1: self.$eval_selected[0], text2 : "\(self.eval_selected[0])")
                            .onChange(of: self.eval_selected[0], perform: { _ in
                                idea.eval1_text = self.eval_selected[0]
                                do {
                                    try viewContext.save()
                                } catch {
                                    print(error)
                                }
                            })
                        }
                        Slider(value : self.$selected[0], in: 0...100,step:1,
                               minimumValueLabel: Text("0"),
                               maximumValueLabel: Text("100"),
                               label: { EmptyView() }
                        ).frame(alignment: .top)
                        
                    }
                    .padding(.vertical)
                    
                    VStack {
                        Button(action:{withAnimation{
                                self.evals_show[1].toggle()}}){
                        DicloseView(expand_key: self.$evals_show[1], text1: self.$eval_selected[1], text2 : "\(self.eval_selected[1])")
                        }
                        .onChange(of: self.eval_selected[1], perform: { _ in
                            idea.eval1_text = self.eval_selected[1]
                            do {
                                try viewContext.save()
                            } catch {
                                print(error)
                            }
                        })
                        Slider(value : self.$selected[1], in: 0...100,step:1,
                               minimumValueLabel: Text("0"),
                               maximumValueLabel: Text("100"),
                               label: { EmptyView() }
                        ).frame(alignment: .top)
                        
                    }
                    .padding(.vertical)
                    
                    VStack {
                        
                        Button(action:{withAnimation{
                                self.evals_show[2].toggle()}}){
                        DicloseView(expand_key: self.$evals_show[2], text1: self.$eval_selected[2], text2 : "\(self.eval_selected[2])")
                        }
                        .onChange(of: self.eval_selected[2], perform: { _ in
                            idea.eval1_text = self.eval_selected[2]
                            do {
                                try viewContext.save()
                            } catch {
                                print(error)
                            }
                        })
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
                .onTapGesture(count: 2, perform: {
                    withAnimation{
                    self.eval_show = false
                    }
                })
                .onTapGesture(count: 1, perform: {
                    withAnimation{
                    self.eval_show = true
                    }
                })
                
//                Button(action:{
//                    withAnimation{
//                        self.text_show = true}}){
                DisclosureGroup("詳細",isExpanded : self.$text_show){
                    
                    VStack(alignment : .leading){
                    Text("タイトル")

                        
                        TextField("タイトル",text: self.$ideatitle)
                        .frame(height : 30)
                            .padding()
                        .background(Color.white.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                        
                    Text("内容")
                        ZStack{
                            
                            Color.white.opacity(0.5)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            TextEditor(text: self.$ideatext)
                                .padding()
                        }.frame(height : 150)
                        
                    }.padding(.vertical)
                }
                .padding(.all)
                .background(Color.black.opacity(0.06))
                .cornerRadius(12)
                .onTapGesture(count: 2, perform: {
                    withAnimation{
                    self.text_show = false
                    }
                })
                .onTapGesture(count: 1, perform: {
                    withAnimation{
                    self.text_show = true
                    }
                })
                //                }.buttonStyle(PlainButtonStyle())
                
                Button(action:{
                    withAnimation{
                        self.photo_show.toggle()}}){
                DisclosureGroup("画像・URL",isExpanded : self.$photo_show){
                    
                    
                    
                    
                }
                .padding(.all)
                .background(Color.black.opacity(0.06))
                .cornerRadius(12)
                }.buttonStyle(PlainButtonStyle())
                
//                Button(action:{
//                    withAnimation{
//                        self.pro_show.toggle()}}){
                DisclosureGroup("プロ向け",isExpanded : self.$pro_show){
                    VStack{
                        
                        Button(action:{}){
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("top"))
                                .frame(width : 150, height : 40)
                            
                            Text("タグ化する")
                                .foregroundColor(.white)
                            
                        }
                        }
                    }.padding(.vertical)
                }
                .padding(.all)
                .background(Color.black.opacity(0.06))
                .cornerRadius(12)
                .onTapGesture(perform: {
                    withAnimation{
                    self.pro_show.toggle()
                    }
                })
//                }.buttonStyle(PlainButtonStyle())
                
                Spacer()
                    .frame(height : 200)
                
            }.padding()
            
            
            
            
            
        }
        .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height - 130, alignment : .topLeading)
        .background(Color("primary").ignoresSafeArea(.all, edges: .all))
        .onAppear(perform: {
            self.selected[0] = Double(idea.eval1)
            self.selected[1] = Double(idea.eval2)
            self.selected[2] = Double(idea.eval3)
            self.eval_selected[0] = idea.eval1_text
            self.eval_selected[1] = idea.eval2_text
            self.eval_selected[2] = idea.eval3_text
            
            self.ideatitle = (idea.title == "" ? idea.text ?? "" : idea.title) ?? ""
            self.ideatext = (idea.text ?? "")
        })
        .onDisappear(perform: {
            idea.eval1 = Int16(self.selected[0])
            idea.eval2 = Int16(self.selected[1])
            idea.eval3 = Int16(self.selected[2])
            idea.eval1_text = self.eval_selected[0]
            idea.eval2_text = self.eval_selected[1]
            idea.eval3_text = self.eval_selected[2]
            
            idea.title = self.ideatitle
            idea.text = self.ideatext
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        })
        
    }
}
