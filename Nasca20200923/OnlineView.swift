//
//  OnlineView.swift
//  Nasca20200923
//
//  Created by masaki on 2020/10/17.
//

import SwiftUI

struct OnlineView: View {
    
    var maxheight = UIScreen.main.bounds.height
    var maxwidth = UIScreen.main.bounds.width

        @State private var selectedTab = 0
        
    var body: some View {
        ZStack{
            
            Color("primary")
                .frame(width : maxwidth, height : maxheight)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                Spacer()
                Text("最新のコメント")
                    .font(.callout)
                    .frame(width : maxwidth - 20, alignment : .leading)
                
                ScrollView(.horizontal,showsIndicators: false){
                    HStack{
                    ForEach(1..<30){ i in
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 15)
//                            Circle()
                                .fill(Color.yellow.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 3).fill(Color.white).opacity(0.3)
                                )
                                .frame(width : 150, height : 80)
                            Text("\(i)")
                                .foregroundColor(.black)
                        }.padding(.vertical)

                    }
                        
                    }
                }
                
                Text("フォロワーのアイディア")
                    .font(.callout)
                    .frame(width : maxwidth - 20, alignment : .leading)
                
                ScrollView(.vertical,showsIndicators: false){
                    VStack{
                    ForEach(1..<30){ _ in
                        
                       UserideaView(userdata: sampleuser[0])
                        
                    }
                        
                    }
                }.frame(width : maxwidth - 20, height : 470)
                
                
            }.frame(width : maxwidth-20, height : maxheight - 50)
            
        }.frame(width : maxwidth-20, height : maxheight - 50)
        
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

    Userdata(userimage: "r2", color: .blue, title: "自転車", text: "自転車のサドルを鍵にしてサドル盗みを防ぐ", tag1: "自転車", tag2 : "起業")

]

struct UserideaView : View {
 
    var userdata : Userdata
    
    var maxwidth = UIScreen.main.bounds.width - 20
    
    var body : some View{
        
        ZStack{
            RoundedRectangle(cornerRadius: 15)
//                            Circle()
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 3).fill(Color.white).opacity(0.3)
                )
            VStack{
                
            HStack(){
            
                Button(action:{}){
            Image(userdata.userimage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                }.buttonStyle(GradientButtonStyle())
                .padding(.top)
                Spacer(minLength: 0)
                
            Text("\(userdata.text)")
                .foregroundColor(.black)
                .frame(width : maxwidth/2)
                
                Spacer(minLength: 0)
                
                VStack{
                
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.red.opacity(0.3))
                    
                    Text(userdata.tag1)
                        .bold()
                        .font(.caption)
                }
                
                    if userdata.tag2 != ""{
                        
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green.opacity(0.3))
                            
                            Text(userdata.tag2)
                                .bold()
                                .font(.caption)
                        }
                        
                    }
                    
                }.frame(width : 60, height : 50)
                
            }
            .padding(.top)
            
                Spacer(minLength: 0)
                
                HStack(alignment : .bottom){
                    
                    Spacer()
                    
                    Button(action:{}){
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.red.opacity(0.6))
                    Text("いいね！")
                        .font(.caption2)
                    }
                    .buttonStyle(GradientButtonStyle())
//                    .padding(.top)
                    
                    Spacer()
                    
                    Button(action:{}){
                    Image(systemName:"questionmark")
                        .foregroundColor(Color.yellow.opacity(0.6))
                    Text("もうあるよ？")
                        .font(.caption2)
                    }
                    .buttonStyle(GradientButtonStyle())
                    
                    
                    Spacer()
                    
                    
                    Button(action:{}){
                    Image(systemName:"arrowshape.turn.up.right")
                        .foregroundColor(Color.blue.opacity(0.6))
                    Text("シェアする")
                        .font(.caption2)
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
        .padding(.top)
        
    }
}
