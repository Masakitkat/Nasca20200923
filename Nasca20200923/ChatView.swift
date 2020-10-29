//
//  ChatView.swift
//  Nasca20200923
//
//  Created by masaki on 2020/10/18.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift


struct Home2: View {
    @StateObject var homeData = HomeModel()
    @AppStorage("current_user") var user = ""
    @State var scrolled = false
    var body: some View {
        
        VStack(spacing: 0){
            
            HStack{
                
                Text("Global Chat")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Spacer(minLength: 0)
            }
            .padding()
            .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
            .background(Color(.blue))
            
            ScrollViewReader{reader in
                
                ScrollView{
                    
                    VStack(spacing: 15){
                        
                        ForEach(homeData.msgs){msg in
                            
                           ChatRow(chatData: msg)
                            .onAppear{
                                // First Time Scroll
                                if msg.id == self.homeData.msgs.last!.id && !scrolled{
                                    
                                    reader.scrollTo(homeData.msgs.last!.id,anchor: .bottom)
                                    scrolled = true
                                }
                            }
                        }
                        .onChange(of: homeData.msgs, perform: { value in
                            
                            // You can restrict only for current user scroll....
                            reader.scrollTo(homeData.msgs.last!.id,anchor: .bottom)
                        })
                    }
                    .padding(.vertical)
                }
            }
            
            HStack(spacing: 15){
                
                TextField("Enter Message", text: $homeData.txt)
                    .padding(.horizontal)
                    // Fixed Height For Animation...
                    .frame(height: 45)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(Capsule())
                
                if homeData.txt != ""{
                    
                    Button(action: homeData.writeMsg, label: {
                        
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(Color.blue)
                            .clipShape(Circle())
                    })
                }
            }
            .animation(.default)
            .padding()
        }
        .onAppear(perform: {
            
//            homeData.onAppear()
        })
        .ignoresSafeArea(.all, edges: .top)
    }
}

struct ChatRow: View {
    var chatData : MsgModel
    @AppStorage("current_user") var user = ""
    var body: some View {
        
        HStack(spacing: 15){
            
            // NickName View...
            
            if chatData.user != user{
                
                NickName(name: chatData.user)
            }
            
            if chatData.user == user{Spacer(minLength: 0)}
            
            VStack(alignment: chatData.user == user ? .trailing : .leading, spacing: 5, content: {
                
                Text(chatData.msg)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                // Custom Shape...
                    .clipShape(ChatBubble(myMsg: chatData.user == user))
                
                Text(chatData.timeStamp,style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(chatData.user != user ? .leading : .trailing , 10)
            })
            
            if chatData.user == user{
                
                NickName(name: chatData.user)
            }
            
            if chatData.user != user{Spacer(minLength: 0)}
        }
        .padding(.horizontal)
        // For SCroll Reader....
        .id(chatData.id)
    }
}

struct NickName : View {
    
    var name : String
    @AppStorage("current_user") var user = ""
    
    var body: some View{
        
        Text(String(name.first!))
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background((name == user ? Color.blue : Color.green).opacity(0.5))
            .clipShape(Circle())
            // COntext menu For Name Display...
            .contentShape(Circle())
            .contextMenu{
                
                Text(name)
                    .fontWeight(.bold)
            }
    }
}

struct ChatBubble: Shape {

    var myMsg : Bool
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,myMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        
        return Path(path.cgPath)
    }
}

struct MsgModel: Codable,Identifiable,Hashable {
    
    @DocumentID var id : String?
    var msg : String
    var user : String
    var timeStamp: Date
    
    enum CodingKeys: String,CodingKey {
        case id
        case msg
        case user
        case timeStamp
    }
}

class HomeModel: ObservableObject{
    
    @Published var txt = ""
    @Published var msgs : [MsgModel] = []
    @AppStorage("current_user") var user = ""
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
        
        ref.collection("Msgs").order(by: "timeStamp", descending: false).addSnapshotListener { (snap, err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            guard let data = snap else{return}
            
            data.documentChanges.forEach { (doc) in
                
                // adding when data is added...
                
                if doc.type == .added{
                    
                    let msg = try! doc.document.data(as: MsgModel.self)!
                    
                    DispatchQueue.main.async {
                        self.msgs.append(msg)
                    }
                }
            }
        }
    }
    
    func writeMsg(){
        
        let msg = MsgModel(msg: txt, user: user, timeStamp: Date())
        
        let _ = try! ref.collection("Msgs").addDocument(from: msg) { (err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
 
        }
        
        self.txt = ""
    }
}
