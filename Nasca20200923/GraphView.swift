//
//  GraphView.swift
//  Nasca20200923
//
//  Created by masaki on 2020/09/26.
//

import SwiftUI

struct GraphView: View {
    
    let animation: Namespace.ID
    
    var body: some View {
            
        
        Graph(animation : animation)
        }
}

//
//struct GraphView_Previews: PreviewProvider {
//    static var previews: some View {
//        GraphView()
//    }
//}

struct Graph : View {
      
      @State var tab = "今月"
//      @Namespace var animation : Namespace.ID
      let animation: Namespace.ID
      @State var subTab = "Today"
      @State var dailySaled = [
          
          // Last 7 Days....
              DailySales(day: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, value: 200, show: true),
              DailySales(day: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, value: 710, show: false),
              DailySales(day: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, value: 330, show: false),
              DailySales(day: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, value: 519, show: false),
              DailySales(day: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, value: 150, show: false),
              DailySales(day: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, value: 229, show: false),
              DailySales(day: Date(), value: 669, show: false)
      ]
      
      @State var edges = UIApplication.shared.windows.first?.safeAreaInsets
      
      var body: some View{
          
          VStack{
              

              HStack{

                  Text("Dashboard")
                      .font(.title2)
                      .fontWeight(.bold)
                      .foregroundColor(.black)

                  Spacer(minLength: 0)
              }
//              .padding()
            
              Spacer()
                .frame(height : 100)
            
              HStack(spacing: 0){

                  TabButton2(selected: $tab, title: "今月", animation: animation)
                  
                  TabButton2(selected: $tab, title: "全期間", animation: animation)
              }
              .background(Color("top").opacity(0.08))
              .clipShape(Capsule())
              .padding(.horizontal)
              
              HStack(spacing: 20){
                  
                  ForEach(subTabs,id: \.self){tab in
                      
                      Button(action: {subTab = tab}) {
                          
                          Text(tab)
                              .fontWeight(.bold)
                              .foregroundColor(Color.black.opacity(subTab == tab ? 1 : 0.4))
                      }
                  }
              }
              .padding()
              
            ScrollView{
              // Or YOu can use Foreach Also...
              VStack(spacing: 20){
                  
                  HStack(spacing: 15){
                      
                      SalesView(sale: salesData[0])
                      
                      SalesView(sale: salesData[1])
                  }
                  
                  HStack(spacing: 10){
                      
                      SalesView(sale: salesData[2])
                      
                      SalesView(sale: salesData[3])
                      
                      SalesView(sale: salesData[4])
                  }
              }
              .padding(.horizontal)
                VStack(spacing : 10) {
                    ZStack{
                        
                        Color.white
                            .clipShape(CustomCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], size: 20))
                            //                      .ignoresSafeArea(.all, edges: .bottom)
                            .ignoresSafeArea(.all)
                            .padding(.horizontal,5)
                        
                        VStack{
                            
                            HStack{
                                
                                Text("1週間のアイディア数")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                
                                Spacer(minLength: 0)
                            }
                            .padding()
                            .padding(.top,10)
                            
                            HStack(spacing: 10){
                                
                                ForEach(dailySaled.indices,id: \.self){i in
                                    
                                    // For Toggling Show Button....
                                    
                                    GraphView_(data: dailySaled[i], allData: dailySaled)
                                        .onTapGesture {
                                            
                                            withAnimation{
                                                
                                                // toggling all other...
                                                
                                                for index in 0..<dailySaled.count{
                                                    
                                                    dailySaled[index].show = false
                                                }
                                                
                                                dailySaled[i].show.toggle()
                                            }
                                        }
                                    
                                    // sample Sapcing For Spacing Effect..
                                    
                                    if dailySaled[i].value != dailySaled.last!.value{
                                        
                                        Spacer(minLength: 0)
                                    }
                                }
                            }
                            .padding(.bottom,10)
                            .padding(.horizontal,30)
                            //                      .padding(.bottom,edges!.bottom == 0 ? 15 : 0)
                        }
                    }
                    .padding(.top,20)
                    ZStack{
                        
                        Color.white
                            .opacity(0.5)
                            .clipShape(CustomCorners(corners: [.topLeft,.topRight,.bottomLeft,.bottomRight], size: 20))
                            //                      .ignoresSafeArea(.all, edges: .bottom)
                            .ignoresSafeArea(.all)
                            .padding(.horizontal,5)
                        
                        Text("順調にアイディアが出ています。あなたが立てた目標も順調に達成に向かっています。この調子であなたの想像力を広げていきましょう。アイディアの傾向としては、「ビジネス」関連のアイディアをよく思いついています。おすすめのタグとして、「アート」の視点で物事を考えてみるのもいいかもしれません。近年、「アート」と「ビジネス」の関係性は注目されています。あなたが見ていなかった観点が眠っているかもしれません。")
                            .font(.footnote)
                            .padding()
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                
                Spacer()
                    .frame(height : 300)
            }}
          .offset(y : 30)
          .background(Color("primary").ignoresSafeArea(.all, edges: .all))
          
      }
  }
  
  var subTabs = ["Today","Yesterday","Last Week"]
  
  struct TabButton2 : View {
      
      @Binding var selected : String
      var title : String
      var animation : Namespace.ID
      
      var body: some View{
          
          Button(action: {
              
              withAnimation(.spring()){
                  
                  selected = title
              }
              
          }) {
              
              ZStack{
                  
                  // Capsule And Sliding Effect...
                  
                  Capsule()
                      .fill(Color.clear)
                      .frame(height: 45)
                  
                if selected == title{
                    
                    Capsule()
                        .fill(Color("top").opacity(0.9))
                        .frame(height: 45)
                        // Mathced Geometry Effect...
                        .matchedGeometryEffect(id: "Tab", in: animation)
                }
                
                Text(title)
                    .foregroundColor(selected == title ? .white : .black)
                    .fontWeight(.bold)
              }
          }
      }
  }
  
  // Sample Model Data....
  
  struct Sales : Identifiable {
      
      var id = UUID().uuidString
      var title : String
      var value : String
      var color : Color
  }
  
  var salesData = [
  
      Sales(title: "使用率の高いタグ", value: "ビジネス", color: Color.orange),
      Sales(title: "評価が平均以上のアイディア数", value: "13 / 30", color: Color.red),
      Sales(title: "おすすめのタグ", value: "アート", color: Color.blue),
      Sales(title: "目標達成率", value: "60%", color: Color.pink),
      Sales(title: "持続率", value: "順調！", color: Color.purple),
  ]
  
  // Daily Sold Model And Data....
  
  struct DailySales : Identifiable {
      var id = UUID().uuidString
      var day : Date
      var value : CGFloat
      var show : Bool
  }
  
  struct SalesView : View {
      
      var sale : Sales
      
      var body: some View{
          
          ZStack{
              
              HStack{
                  
                  VStack(alignment: .leading, spacing: 22) {
                      
                      Text(sale.title)
                          .foregroundColor(.white)
                      
                      Text(sale.value)
                          .font(.title2)
                          .fontWeight(.bold)
                          .foregroundColor(.white)
                  }
                  
                  Spacer(minLength: 0)
              }
              .padding()
          }
          .background(sale.color)
          .cornerRadius(10)
      }
  }
  
  // Custom Corners...
  
  struct CustomCorners : Shape {
      
      var corners : UIRectCorner
      var size : CGFloat
      
      func path(in rect: CGRect) -> Path {
          
          let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: size, height: size))
          
          return Path(path.cgPath)
      }
  }
  
  struct GraphView_ : View {
      
      var data : DailySales
      var allData : [DailySales]
      
      var body: some View{
          
          VStack(spacing: 5){
              
              GeometryReader{reader in
                  
                  VStack(spacing: 0){
                      
                      Spacer(minLength: 0)
                      
                    Text("\(Int(data.value))")
                          .font(.caption)
                          .fontWeight(.bold)
                          .foregroundColor(.black)
                          // default Height For Graph...
                          .frame(height: 20)
                          .opacity(data.show ? 1 : 0)
                      
                      RoundedRectangle(cornerRadius: 5)
                          .fill(Color.red.opacity(data.show ? 1 : 0.4))
                        
                          .frame(height: calulateHeight(value: data.value, height: reader.frame(in: .global).height - 20))
                  }
              }
              
              Text(customDateStyle(date: data.day))
                  .font(.caption2)
                  .foregroundColor(.gray)
          }.frame(height: 200)
      }
      
      func customDateStyle(date: Date)->String{
          
          let format = DateFormatter()
          format.dateFormat = "MMM dd"
          return format.string(from: date)
      }
      
      func calulateHeight(value: CGFloat,height: CGFloat)->CGFloat{
          
          let max = allData.max { (max, sale) -> Bool in
              
              if max.value > sale.value{return false}
              else{return true}
          }
          
          let percent = value / max!.value
          
          return percent * height
      }
  }
