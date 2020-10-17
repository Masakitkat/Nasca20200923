//
//  ContentView.swift
//  Nasca20200923
//
//  Created by masaki on 2020/09/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity : Idea.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Idea.date, ascending: true)],
        animation: .default)
    private var ideas: FetchedResults<Idea>
    
    @FetchRequest(entity : Tag.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Tag.date, ascending: true)],
        animation: .default)
    private var tags: FetchedResults<Tag>
    
    @ObservedObject var init_tagtext = ini_tag()
    
    
    init() {
            UITextView.appearance().backgroundColor = .clear
        }

    var body: some View {
        Main(init_tagtext: init_tagtext)
    }

    private func addItem() {
        withAnimation {
            let newItem = Idea(context: viewContext)
            newItem.date = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { ideas[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct Main: View {
    
    @State var pagetitle = ""
    @State var edges = UIApplication.shared.windows.first?.safeAreaInsets
    @State var selectedTab = "一覧"
    @State var selectedView = "Top"
    @State var width = UIScreen.main.bounds.width
    @State var show = false
    @State var tophide = false
    @State var bottomhide = false
    @State var selectedIndex = ""
    @State var pageIndex = 0
    @State var modal = false
    @Namespace var animation
    
    @ObservedObject var init_tagtext : ini_tag
    
    var body: some View{
        
        let drag = DragGesture()
                   .onEnded {
                       if $0.translation.width < -100 {
                           withAnimation {
                               self.show = false
                           }
                       }
                       else if $0.translation.width > +100  {
                           withAnimation {
                               self.show = true
                           }
                       }
                   }
        ZStack {
            
            switch selectedView {
            
            case "Top":
                TopView(selected: $selectedView)
                    .animation(.interactiveSpring())
            case "Inst":
                InstructionView(selected: $selectedView)
                    .animation(.interactiveSpring())
                
            case "Memo":
                MemoView()
                    .animation(.interactiveSpring())
                    .onAppear(){
                        pagetitle = "Idea Memo"
                    }
            case "Graph":
                GraphView(animation : animation)
                    .animation(.interactiveSpring())
                    .onAppear(){
                        pagetitle = "DashBoard"
                    }
                
                
            case "List":
                ListView(init_tagtext: self.init_tagtext, tophide : $tophide, animation: animation)
                    .animation(.interactiveSpring())
                    .onAppear(){
                        pagetitle = "Idea List"
                    }
            case "Son":
                
                SonSummaryView(animation : animation ,tophide :$tophide,bottomhide : $bottomhide)
                    .animation(.interactiveSpring())
                    .onAppear(){
                        pagetitle = "BrainStorming"
                    }
                    .frame(height: selectedView != "Son" ? .zero : nil)
            //            case "test":
            //                Hoime()
            //                animation(.easeInOut)
            //                .onAppear(){
            //                    pagetitle = "test "
            //                }
        
        default:
            MemoView()
        }
        
            
        VStack(spacing: 0){
            
            VStack{
                
                ZStack{
                    
                    HStack{
                        
                        Button(action: {
                           withAnimation(.spring()){
                               show.toggle()
                            
                           }
                        }, label: {
                            
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 22))
                        })
                        
                        Spacer(minLength: 0)
                        
                        Button(action: {}, label: {
                            
                            Image(systemName: "paperplane")
                                .font(.system(size: 22))
                        })
                    }
                    
                    Text("\(pagetitle)")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding()
                .padding(.top,edges?.top)
                .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            }
            .padding(.bottom)
            .background(Color("top").ignoresSafeArea(.all, edges: .all))
            .clipShape(CustomCorner(corner: .bottomLeft, size: selectedView == "List" ? 83 : 0))
            .opacity(selectedView == "Top" || selectedView == "Inst" || self.tophide ? 0 : 1)

            Spacer(minLength: 0)
            
            ZStack{
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color("top"))
                    .padding(.top)
                
                TabBar(selectedView: $selectedView, modal : $modal)
                    .padding(.leading,20)

            }.frame(width : UIScreen.main.bounds.width, height : UIScreen.main.bounds.height/9, alignment : .center)
            .opacity(selectedView == "Top" || selectedView == "Inst" || self.tophide || self.bottomhide ? 0 : 1)
            .disabled(selectedView == "Top" || selectedView == "Inst" || self.bottomhide ? true : false)
//            
            
        }
        

           //Side Menu
           HStack (spacing : 0 ){
               
               VStack{
                   
                   HStack{
                   
                       Button(action:{
                           withAnimation(.spring()){
                               show.toggle()
                           }
                       },label : {
                           
                           Image(systemName: "xmark")
                               .font(.system(size:15,weight:.bold))
                               .foregroundColor(.white)
                       })
                       Spacer(minLength: 0)
                   }
                   .padding()
                   .padding(.horizontal)
                   .padding(.top,edges?.top)
                   
                Button(action:{}){
                    
                
                   HStack(spacing:15){
                       
                       Image("i4")
                           .resizable()
                           .frame(width:50,height:50)
                           .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                       
                       VStack(alignment: .leading,spacing: 10, content: {

                           Text("木次　大樹")
                               .font(.title2)
                               .fontWeight(.medium)

                           Text("guitarmasaki25@gmail.com")
                               .font(.caption)
                       })
                       .foregroundColor(.white)
                       
                       Spacer(minLength: 0)
                       
                   }
                   
                   
                   .padding(.horizontal)
                }
                   //Menu buttons
                   
                   
                   VStack(alignment: .leading, content : {
                       
                    MenuButtons(image: "text.badge.plus", title : "メモを書く", view: "Memo",selected: $selectedView, show : $show)
                    MenuButtons(image: "list.bullet", title : "リストを見る", view: "List",selected: $selectedView, show : $show)
                    MenuButtons(image: "chart.bar.xaxis", title : "グラフで分析する", view: "Graph",selected: $selectedView, show : $show)
                    MenuButtons(image: "swift", title : "考えてみる", view: "Son",selected: $selectedView, show : $show)
                    MenuButtons(image: "gear", title : "設定", view: "test",selected: $selectedView, show : $show)
                    MenuButtons(image: "info.circle", title : "よくあるご質問", view: "Top",selected: $selectedView, show : $show)
                    MenuButtons(image: "envelope.fill", title : "私たちについて", view: "",selected: $selectedView, show : $show)
                       
                   })
//                   .padding(.top)
                   .padding(.trailing, 20)
                   
                   Spacer(minLength: 0)
                   
                   
                   
               }
               .frame(width : width - 130)
               .background(Color("top"))
               .offset(x : show ? -5 : -width)
               
               Spacer(minLength: 0)
               
               
           }
           .background(Color.black.opacity(show ? 0.3 : 0))
           
           
       }
        .gesture(selectedView == "Top" || selectedView == "Inst" ? nil : drag)
        .sheet(isPresented: self.$modal, content: {
            MemoModalView(ini_tagtext: self.init_tagtext)
        })
        
        .ignoresSafeArea(.all)
    }
}

struct MenuButtons : View {
    
    var image : String
    var title : String
    var view : String
    @Binding var selected : String
    @Binding var show : Bool
    
    var body : some View {
     
        Button(action:{
            
            withAnimation(.spring()){
                selected = view
                show.toggle()
            }
            
        }, label : {
            
            HStack(spacing: 20){
                
                Image(systemName : image)
                    .font(.system(size:22))
                    .frame(width:25,height:25)
                
                Text(title)
                    .font(.system(size:15))
                    .fontWeight(.semibold)
                
            }
            .frame(width : UIScreen.main.bounds.width / 2.3 , alignment: .leading)
            .padding(.vertical,15)
            .padding(.trailing)
            
        })
        .padding(.top,5)
        .foregroundColor(.white)
        
    }
}

struct CustomCorner : Shape {
    
    var corner : UIRectCorner
    var size : CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: size, height: size))
        
        return Path(path.cgPath)
    }
}

struct TabBar : View {
    
    @Binding var selectedView : String
    @Binding var modal : Bool
    
    var body : some View {
        
        HStack(spacing : 35){
            Button(action:{
                withAnimation{
                selectedView = "Memo"
                }
            }){
                VStack(spacing : 10){
                    Image(systemName:"house.fill")
                        .font(.title3)
                    Text("Home")
                        .font(.caption)}
            }.buttonStyle(GradientButtonStyle())
            .padding(.top)
            .foregroundColor(Color.white.opacity(self.selectedView == "Memo" ? 1 : 0.2))
            //        Spacer(minLength: 0)
            
            
            Button(action:{
                withAnimation{
                selectedView = "List"
                }
            }){
                VStack(spacing : 10){
                    Image(systemName:"list.bullet")
                        .font(.title3)
                    Text("List")
                        .font(.caption)}
            }.buttonStyle(GradientButtonStyle())
            .padding(.top)
            .foregroundColor(Color.white.opacity(self.selectedView == "List" ? 1 : 0.2))
            
            //        Spacer(minLength: 0)
            
            Button(action:{
                withAnimation{
                self.modal.toggle()
                }
            }){
                ZStack{
                    Circle()
                        .fill(Color.white)
                        .frame(width : 50, height : 50)
                    Image(systemName:"plus")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                
            }
            .padding(.top,30)
            .buttonStyle(GradientButtonStyle())
            .offset(y : -25)
            
            
            //            Spacer(minLength: 0)
            
            
            Button(action:{
                withAnimation{
                selectedView = "Graph"
                }
            }){
                VStack(spacing: 10){
                    Image(systemName:"chart.bar.xaxis")
                        .font(.title3)
                    Text("Graph")
                        .font(.caption)
                }
            }.buttonStyle(GradientButtonStyle())
            .padding(.top)
            .foregroundColor(Color.white.opacity(self.selectedView == "Graph" ? 1 : 0.2))
            
            //        Spacer(minLength: 0)
            
            
            Button(action:{
                withAnimation{
                selectedView = "Son"
                }
            }){
                VStack(spacing:10){
                    Image(systemName:"swift")
                        .font(.title3)
                    Text("Account")
                        .font(.caption)}
            }.buttonStyle(GradientButtonStyle())
            .padding(.top)
            .foregroundColor(Color.white.opacity(self.selectedView == "Son" ? 1 : 0.2))
        }
        //        .padding(.horizontal,35)
        .frame(alignment : .center)
        .foregroundColor(Color.white)
    }
    
}
