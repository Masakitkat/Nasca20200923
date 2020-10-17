//
//  TagModalView.swift
//  Nasca20200923
//
//  Created by masaki on 2020/10/12.
//

import SwiftUI

struct TagModalView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity : Tag.entity(), sortDescriptors:[NSSortDescriptor(keyPath: \Tag.date,ascending:true)]) var tags : FetchedResults<Tag>
    
    @State var tagname = ""
    @State var tagcolor = ""
    @State var tag_temp = ""
    @State var initial_tags : [Tag] = []
    
    @Binding var activeSheet: ActiveSheet?
    
    @State var issub = false
    
    var hex = ["#EBCA3F","#D26873","#D26873","#2A34E1","#2A34E1","#EBCA3F","486d8b","d22b55","81b27f","#EBCA3F","#D26873","#D26873","#2A34E1","#2A34E1","#EBCA3F","486d8b","d22b55","81b27f"]
    
    func tagAdd() {
        let addedTag = Tag(context : viewContext)
            addedTag.id = UUID()
            addedTag.color = tagcolor
            addedTag.text = tagname
            addedTag.date = Date()
            addedTag.issub = issub
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
        ZStack{
            VStack(spacing : 40){
            
            Text("タグを追加する")
                .font(.title2)
                .bold()
                .foregroundColor(.blue)
            
            TextField("タグを追加する", text: $tagname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width : UIScreen.main.bounds.width - 50)
//                .foregroundColor(.blue)
            
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
                                    .frame(width:30,height:30)}
                        }
                    }
                }
//                .frame(alignment : .top)
            }
                VStack(spacing : 10){
                Text("関連するタグ")
                    .font(.title2)
                    .bold()
                ScrollView(.vertical, showsIndicators: false){
                    LazyVGrid(columns: [GridItem(.adaptive(minimum:80))], spacing: 10, pinnedViews: [], content: /*@START_MENU_TOKEN@*/{
                        ForEach(self.tags, id :\.self){ tag in
                            
                            let tagtext = tag.text ?? ""
                            let tagcolor = tag.color ?? ""
                            Button(action:{}
                            ){
                            ZStack(alignment : .leading){
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(hex :tagcolor).opacity(0.5))
                                Text(tagtext)
                                    .padding()
                            }
                            
                                
                            }
                        }
                        
                    })
                }
                .animation(.default)
//                .padding(.top)
                .frame(height:200,alignment: .top)
                }
                
                //            .padding(.horizontal)
                HStack{
                    Spacer()
                    Button(action : {
                        
                        issub.toggle()
                        
                    }){
                        
                        HStack{
                            
                            Image(systemName: issub ? "checkmark" : "square")
                                .foregroundColor(issub ? .blue : .black)
                            
                            Text("場面タグか？")
                        }.padding(.horizontal)
                    }
                    
                    Button(action:{
                        if self.tag_temp == "" {
                            self.tagAdd()
                        }
                        else {
                            
                            let index = tags.compactMap({$0.text}).firstIndex(of: self.tag_temp)
                            tags[index!].text = self.tagname
                            tags[index!].color = self.tagcolor
                            
                            do {
                                try viewContext.save()
                            } catch {
                                print(error)
                            }
                            
                        }
                        self.activeSheet = nil
                        
                    }){
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width : 100, height : 50)
                                .foregroundColor(Color("top"))
                            
                            Text("保存する")
                                .foregroundColor(.white)
                        }
                    }
                    
                }
                
            }.padding()
            
        }
        .frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height)
        .background(Color("primary").ignoresSafeArea(.all, edges: .all))
        .onDisappear(perform: {
            self.tag_temp = ""
        })
    }
}
//
//struct TagModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        TagModalView()
//    }
//}
