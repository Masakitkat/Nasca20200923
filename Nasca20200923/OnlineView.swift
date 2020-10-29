//
//  OnlineView.swift
//  Nasca20200923
//
//  Created by masaki on 2020/10/17.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct OnlineView: View {
    
    var maxheight = UIScreen.main.bounds.height
    var maxwidth = UIScreen.main.bounds.width
    
    @StateObject var IdeaData = IdeaFB()
//    @AppStorage("current_user") var user = ""

    @State private var selectedTab = 0
    
    
    
        
    var body: some View {
        ZStack{
        
//            VStack{
//
//
//                Spacer()
//            }.frame(height : maxheight)
            ZStack{
            Color("top")
                .frame(width : maxwidth/2)
            }.frame(width : maxwidth,alignment: .trailing)
            
            VStack{
//                Color("top")
//                    .frame(height : maxheight/6,alignment : .top)
//                    .edgesIgnoringSafeArea(.all)
                Spacer()
                    .frame(height :117)
                
                
                ZStack{
                    
                    Color("top")
                    
                    Color("primary")
                        .clipShape(CustomCorner(corner: .topRight, size: 83))
                    VStack{
                        Text("あなたのアイディア")
                            .font(.title3)
                            .bold()
                            .frame(width : maxwidth - 20, alignment : .leading)
                        
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack{
                                ForEach(IdeaData.idea){ idea in
                                    
                                    highlightview(userdata: idea)
                                    
                                }
                            }
                        }
                        .frame(height : 100, alignment : .leading)
                        .padding(.horizontal,5)
                    }
                    .padding(.top)
                    .frame(alignment : .top)
                }.frame(height : 170,alignment : .top)
                
                HStack{
                    Text("クリエイターのアイディア")
                        .font(.title3)
                    .bold()
                    
                    Spacer()
                Image(systemName: "rectangle.grid.1x2.fill")
                    .padding(.trailing)
                Image(systemName: "rectangle.grid.2x2")
                    .padding(.trailing)
                    
                }
                .frame(width : maxwidth - 20, alignment : .topLeading)
//                .padding(.top)
                
                ScrollView(.vertical,showsIndicators: false){
                    
                    VStack{
                        ForEach(IdeaData.idea){ idea in
                        
                        
                            VideaView(userdata: idea)
                        
                    }
                        Spacer(minLength: 0)
                            .frame(height : 120)
                    }
                    
                }.frame(width : maxwidth - 5,alignment : .top)
                
                
            }
            .frame(width : maxwidth, height : maxheight,alignment : .top)
            .background(Color("primary"))
//            .clipShape(CustomCorner(corner: .topRight, size: 83))
            .edgesIgnoringSafeArea(.bottom)
//            .padding(.top,175)
            
            
        }
        .frame(width : maxwidth, height : maxheight)
        .background(Color("primary"))
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: {
//            IdeaData.onAppear()
        })
    }
}

struct OnlineView_Previews: PreviewProvider {
    static var previews: some View {
        OnlineView()
    }
}

struct Userdata : Identifiable {
    
    var id = UUID()
    var userimage : String
    var color : Color
    var title : String
    var text : String
    var tag1 : String
    var tag2 : String = ""
}

var sampleuser = [

    Userdata(userimage: "r2", color: .blue, title: "自転車", text: "自転車のサドルを鍵にしてサドル盗みを防ぐ", tag1: "自転車", tag2 : "起業"),
    
    Userdata(userimage: "r3", color: .yellow, title: "Youtube", text: "クイズノックのメンバーにクイズ版SASUKEをやらせる", tag1: "企画"),
    
    Userdata(userimage: "r4", color: .red, title: "会社", text: "研修でやるブレストのアイディアを貯めるサービス", tag1: "会社", tag2 : "人事"),
    
    Userdata(userimage: "r5", color: .black, title: "自転車", text: "自転車のサドルを鍵にしてサドル盗みを防ぐ", tag1: "自転車", tag2 : "起業"),
    
    Userdata(userimage: "r6", color: .purple, title: "Youtube", text: "クイズノックのメンバーにクイズ版SASUKEをやらせる", tag1: "企画"),
    
    Userdata(userimage: "r7", color: .green, title: "会社", text: "研修でやるブレストのアイディアを貯めるサービス", tag1: "会社", tag2 : "人事"),
    
    Userdata(userimage: "r8", color: .blue, title: "自転車", text: "自転車のサドルを鍵にしてサドル盗みを防ぐ", tag1: "自転車", tag2 : "起業"),
    
    Userdata(userimage: "r9", color: .yellow, title: "Youtube", text: "クイズノックのメンバーにクイズ版SASUKEをやらせる", tag1: "企画"),
    
    Userdata(userimage: "r10", color: .red, title: "会社", text: "研修でやるブレストのアイディアを貯めるサービス", tag1: "会社", tag2 : "人事"),
    
    Userdata(userimage: "r11", color: .black, title: "自転車", text: "自転車のサドルを鍵にしてサドル盗みを防ぐ", tag1: "自転車", tag2 : "起業"),
    
    Userdata(userimage: "r12", color: .purple, title: "Youtube", text: "クイズノックのメンバーにクイズ版SASUKEをやらせる", tag1: "企画"),
    
    Userdata(userimage: "r13", color: .green, title: "会社", text: "研修でやるブレストのアイディアを貯めるサービス", tag1: "会社", tag2 : "人事"),
    
    Userdata(userimage: "r14", color: .purple, title: "Youtube", text: "クイズノックのメンバーにクイズ版SASUKEをやらせる", tag1: "企画")

]

struct VideaView : View {
 
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity : Idea.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Idea.date, ascending: false)],
        animation: .default)
    private var ideas: FetchedResults<Idea>
    @FetchRequest(entity : Tag.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.date, ascending: false)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    var userdata : IdeaModel
    
    var maxwidth = UIScreen.main.bounds.width - 20
    
    @State var saved = false
    
    @AppStorage("stored_Username") var user = ""
    
    func add() {
            let newidea = Idea(context: viewContext)
            let newtag = Tag(context: viewContext)
            newidea.id = UUID()
            newidea.title = userdata.title
            newidea.text = userdata.text
            newidea.date = Date()
            newidea.user = userdata.user
        
            if tags.compactMap({$0.text}).contains(userdata.tag[0]) != true{
                newtag.text = userdata.tag[0]
                newtag.color = userdata.tagcolor[0]
                newidea.addToTag(newtag)
            }
            else {
                let index = tags.compactMap({$0.text}).firstIndex(of: userdata.tag[0])
                newidea.addToTag(tags[index ?? 0])
            }
            if tags.compactMap({$0.text}).contains(userdata.tag[1]) != true{
                newtag.text = userdata.tag[1]
                newtag.color = userdata.tagcolor[1]
                newidea.addToTag(newtag)
            }
            else {
                let index = tags.compactMap({$0.text}).firstIndex(of: userdata.tag[1])
                newidea.addToTag(tags[index ?? 0])
            }
                
//            newidea.addToTag(userdata.tag[1])
        
            do {
                try viewContext.save()
            } catch {
                print(error)
                viewContext.delete(newidea)
            }
        }
    
    
    var body : some View{
        
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                //                            Circle()
                .fill(Color.white.opacity(0.4))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 3).fill(Color.white).opacity(0.3)
//                )
            VStack{
                
                HStack(){
                    
                    
                    Button(action:{}){
                        VStack(alignment : .center){
                        Image("r"+"\(Int.random(in : 2..<17))")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(lineWidth: 1).fill(userdata.tagcolor.count > 0 ? Color(hex: userdata.tagcolor[0] ?? "") : Color.red)
                            )
                            Text(userdata.user.prefix(5))
                            .font(.caption2)
//                            .fixedSize()
                        }.frame(width: 35,alignment:.trailing)
                    }.buttonStyle(GradientButtonStyle())
                    .padding(.top)
                    
                    Spacer(minLength: 0)
                    
                    Text("\(userdata.title)")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .frame(width : maxwidth/2)
                    
                    Spacer(minLength: 0)
                    
                    VStack{
                        
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(userdata.tagcolor.count > 0 ? Color(hex: userdata.tagcolor[0] ?? "").opacity(0.3) : Color.red.opacity(0.3))
                            
                            if userdata.tag.count >= 1 {
                            Text(userdata.tag[0] ?? "")
                                .bold()
                                .font(.caption)
                            }
                        }
                        
                        if userdata.tag.count > 1 {

                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.purple.opacity(0.3))
                                
                                Text(userdata.tag[1] ?? "")
                                    .bold()
                                    .font(.caption)
                            }
                            
                        }
                        
                        
                        
                    }.frame(width : 60, height : 50)
                    
                    Button(action:{}){
                    Image(systemName: "chevron.compact.right")
                        .foregroundColor(Color.gray)
                        .frame(height : 40, alignment : .bottom)
                        .padding(.leading)
                    }
                    
                }
                .padding(.top)
                
                Spacer(minLength: 0)
                
                HStack(alignment : .bottom){
                    
                    Spacer()
                    
                    let saved = ideas.compactMap({$0.title}).contains(userdata.title) && ideas.compactMap({$0.user}).contains(userdata.user)
//                    let index = ideas.compactMap({$0.title}).firstIndex(of: userdata.title)
                    
                    Button(action:{
                        
                        if saved {
                        }
                        else{
                            
                            add()
                            
                            
                        }
                    }){
                        if saved {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color.red.opacity(0.6))
                            .font(.subheadline)
                            Text("保存済")
                                .font(.caption)
                        }
                        else {
                        Image(systemName: "heart")
                            .foregroundColor(Color.red.opacity(0.6))
                            .font(.subheadline)
                            Text("保存する")
                                .font(.caption)
                        }
                        
                       
                    }
                    .buttonStyle(GradientButtonStyle())
                    //                    .padding(.top)
                    
                    Spacer()
                    
                    Button(action:{}){
                        Image(systemName:"bubble.right")
                            .foregroundColor(Color.yellow.opacity(0.6))
                            .font(.subheadline)
                        Text("もうあるよ？")
                            .font(.caption)
                    }
                    .buttonStyle(GradientButtonStyle())
                    
                    
                    Spacer()
                    
                    
                    Button(action:{}){
                        Image(systemName:"arrowshape.turn.up.right")
                            .foregroundColor(Color.blue.opacity(0.6))
                            .font(.subheadline)
                        Text("シェアする")
                            .font(.caption)
                    }
                    .buttonStyle(GradientButtonStyle())
                    
                    Spacer()
                    
                }
                
                
            }
            .frame(height : 120)
            .padding(.horizontal)
        }
        .frame(width : maxwidth, height : 120)
        .padding(.horizontal)
//        .padding(.top)
        
    }
}

struct highlightview : View {
    
    var userdata : IdeaModel
    
    @State var saved = false
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.4))
            
            
            VStack(spacing : 5){
                HStack(alignment : .top){
                    Image("r"+"\(Int.random(in : 2..<17))")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 15, height: 15)
                        .clipShape(Circle())
//                        .overlay(
//                            Circle().stroke(lineWidth: 1).fill(Color(hex: userdata.tagcolor[0]))
//                        )
                    Spacer(minLength: 0)
                    
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(userdata.tagcolor.count > 0 ? Color(hex: userdata.tagcolor[0] ?? "").opacity(0.5) : Color.red)
//                            .frame(width : 40)
                        if userdata.tag.count >= 1 {
                        Text(userdata.tag[0] ?? "")
                            .font(.system(size: 10))
                        }
                            
                    }
                    .frame(height : 10)
                    .padding(.leading)
                    
                }
                .padding([.horizontal],5)
                
                HStack(){
                Text(userdata.title)
                    .font(.caption)
                    .foregroundColor(.black)
                }
                .frame(height : 30)
                .padding(.horizontal,5)
                .padding(.top,5)
                
                HStack(alignment : .bottom){
                    
//                    Spacer()
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color.red.opacity(0.6))
                            .font(.system(size: 8))
                        Text("\(Int.random(in : 1..<100))")
                            .font(.system(size: 10))
                            
                    
                    
                    Spacer()
                    
                    
                        Image(systemName:"bubble.right.fill")
                            .foregroundColor(Color.yellow.opacity(0.6))
                            .font(.system(size: 8))
                        Text("\(Int.random(in : 1..<100))")
                            .font(.system(size: 10))
                            
                    
                    Spacer()
                    
                    
                    
                        Image(systemName:"arrowshape.turn.up.right.fill")
                            .foregroundColor(Color.blue.opacity(0.6))
                            .font(.system(size: 8))
                        Text("\(Int.random(in : 1..<100))")
                            .font(.system(size: 10))
//                    Spacer()
                    
                }
                
                .padding(.horizontal,10)
                .padding(.top,10)

            }
            .frame(width : 130, height : 80, alignment : .topLeading)
            
            
            
        }
        //        .padding()
//                .frame(width : 150, height : 80)
        
    }
    
}

struct IdeaModel: Codable,Identifiable,Hashable {
    
    @DocumentID var id : String?
    var title : String
    var text : String
    var user : String
    var timeStamp: Date
    var tag : [String?]
    var tagcolor : [String?]
    
    
    enum CodingKeys: String,CodingKey {
        case id
        case title
        case text
        case user
        case timeStamp
        case tag
        case tagcolor
    }
}

class IdeaFB: ObservableObject{
    
    @Published var txt = ""
    @Published var title = ""
    @Published var tag : [String] = []
    @Published var tagcolor : [String] = []
    @Published var idea : [IdeaModel] = []
//    @AppStorage("current_user") var user = ""
    @AppStorage("stored_Username") var user = ""
    let ref = Firestore.firestore()
    
    init() {
        readAllMsgs()
    }
    
//    func onAppear(){
//
//        // Checking whether user is joined already....
//
//        if user == ""{
//            // Join Alert...
//
//            UIApplication.shared.windows.first?.rootViewController?.present(alertView(), animated: true)
//        }
//    }
//
//    func alertView()->UIAlertController{
//
//        let alert = UIAlertController(title: "Join Chat !!!", message: "Enter Nick Name", preferredStyle: .alert)
//
//        alert.addTextField { (txt) in
//            txt.placeholder = "eg Kavsoft"
//        }
//
//        let join = UIAlertAction(title: "Join", style: .default) { (_) in
//
//            // checking for empty click...
//
//            let user = alert.textFields![0].text ?? ""
//
//            if user != ""{
//
//                self.user = user
//                return
//            }
//
//            // repromiting alert view...
//
//            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
//        }
//
//        alert.addAction(join)
//
//        return alert
//    }
    
    func readAllMsgs(){
        
        ref.collection("Idea").order(by: "timeStamp", descending: true).addSnapshotListener { (snap, err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            guard let data = snap else{return}
            
            data.documentChanges.forEach { (doc) in
                
                // adding when data is added...
                
                if doc.type == .added{
                    
                    let msg = try! doc.document.data(as: IdeaModel.self)!
                    
                    DispatchQueue.main.async {
                        self.idea.append(msg)
                    }
                }
            }
        }
    }
    
    func writeMsg(){
        
        let msg = IdeaModel(title : title, text: txt, user: user, timeStamp: Date(), tag : tag, tagcolor : tagcolor)
        
        let _ = try! ref.collection("Idea").addDocument(from: msg) { (err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
 
        }
        
//        self.txt = ""
    }
    
    func deleteMsg(id : String?){
//
//        let msg = IdeaModel(title : title, text: txt, user: user, timeStamp: Date(), tag : tag, tagcolor : tagcolor)
//
        let _ = ref.collection("Idea").document(id!).delete() { err in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
 
        }
        
//        self.txt = ""
    }
    
}
