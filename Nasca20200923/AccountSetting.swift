//
//  AccountSetting.swift
//  Nasca20200923
//
//  Created by masaki on 2020/10/18.
//

import SwiftUI

struct AccountSetting: View {
    
    var maxheight = UIScreen.main.bounds.height
    var maxwidth = UIScreen.main.bounds.width
    
    @State var notify = false
    @State var darkmode = false
    
    @ObservedObject var LoginModel = LoginViewModel()
    
    @AppStorage("status") var logged = false
    @AppStorage("stored_User") var Stored_User = ""
    @AppStorage("stored_Username") var Stored_Username = ""
    @AppStorage("Introduction") var intro = ""
    
    @Binding var selected : String
    @State var navbarhide = true
    
    @State var login = false
    @State var imageindex = Int.random(in : 2..<17)
    @State var username = ""
    
    var body: some View {
        
        NavigationView{
        
        ZStack {
            
            VStack{
            Image("r"+"\(imageindex)")
                .resizable()
                .scaledToFill()
                .frame(width : maxwidth+10,height : maxheight/2.1,alignment : .top)
                .brightness(-0.15)
                .blur(radius: 0.1)
//                .aspectRatio(contentMode: .fill)
//                .clipShape(CustomCorner(corner: .bottomRight, size: 1000))
                .edgesIgnoringSafeArea(.all)
                
            Spacer()
            }.background(Color.black)

            
            VStack(alignment : .trailing){
            Color("primary")
                .frame(width : maxwidth/2,height : 330)
            Spacer()
                .frame(height : 480)
            }.frame(width :maxwidth,alignment : .trailing)
            
            ZStack{
            VStack{
            Image("r"+"\(imageindex)")
                .resizable()
                .scaledToFill()
                .frame(width : maxwidth+10,height : maxheight/3.2,alignment : .top)
                .brightness(-0.15)
                .blur(radius: 0.1)
//                .aspectRatio(contentMode: .fill)
                .clipShape(CustomCorner(corner: .bottomRight, size: 180))
                .edgesIgnoringSafeArea(.all)
            
            Spacer()
            }

//                .padding(.top,90)
                
                
                HStack{
                    
//                    Spacer()
                    
                    Button(action:{
                        withAnimation{
                            selected = "Online"
                        }
                    }){
                        ZStack{
                        Image(systemName: "xmark")
                            .foregroundColor(Color.white.opacity(0.8))
                            .font(.system(size: 30))
                        }
                        .frame(width : 10, height : 100)
                        .padding(.bottom)
                    }
                    
//                    Spacer()
                }
                .padding(.horizontal,30)
//                .padding(.top,20)
                .frame(width : maxwidth/1 ,height : maxheight-100, alignment : .topLeading)
                
                
                
            }.frame(width : maxwidth,height : maxheight,alignment : .top)
            
            VStack(spacing:0){
                ZStack{
                    
                    //                    Spacer()
                    //
                    //                    Image("r4")
                    //                        .resizable()
                    //                        .aspectRatio(contentMode: .fill)
                    //                        .frame(height : maxheight/2)
                    //                    Color(.black)
                    //                    .clipShape(CustomCorner(corner: .bottomRight, size: 1000))
                    //                    .frame(width : maxwidth/1)
                    //                        .edgesIgnoringSafeArea(.all)
                    
                    
                }
                .frame(width : maxwidth,height : maxheight/2, alignment : .trailing)
                //                .background(Color.red)
                
                ZStack{
                    Color("primary")
                        .clipShape(CustomCorner(corner: .topLeft, size: 1000))
                        .frame(width : maxwidth/1)
                    //                    .padding(.leading,3)
                }.frame(width : maxwidth,height : maxheight - 100 , alignment : .leading)
                
                
            }.frame(width : maxwidth, height : maxheight)
//            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            
            
            VStack{
                
                HStack(spacing: 30){
                
                    Button(action:{}){
                ZStack{
                Image("r"+"\(imageindex)")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width : 120,height : 120)
                    .overlay(
                        Circle().stroke(Color.white,lineWidth: 3)
                    )
                    .shadow(radius: 10,x:5,y:5)
                }.frame(alignment : .topLeading)
                    }
                    .buttonStyle(GradientButtonStyle())
                    .padding(.top,15)
                    VStack(alignment : .leading,spacing : 5){
                        Text(username)
                            .bold()
                            .font(.title)
                            
                            .foregroundColor(Color("top"))
                        
//                        Text("guitarmasaki25@gmail.com")
                        Text(self.logged ? self.Stored_User : "")
                            .font(.footnote)
                            .bold()
                            .fixedSize()
                            
                    }.frame(width : 150,alignment : .leading)
                    .padding(.top)
                    Spacer()
                }
            }.frame(width : maxwidth/1.1, height : maxheight/2.2, alignment : .topLeading)
            
            
            
            VStack(spacing : 30){
                
                Spacer()
                    .frame(height : maxheight/2.3)
                
                HStack(spacing : 10){
                    
                    Image(systemName: "person.circle.fill")
                        
                        .foregroundColor(Color("top"))
                    Text("アカウント設定")
                        .bold()
                    Spacer()
                }
                
                VStack(spacing : 30){
                    if self.logged{
//                    Button(action:{}){
                        NavigationLink(destination : ProfileSetting(username: $username,navbarhide : $navbarhide)){
                    HStack{
                        
                        Text("プロフィールを編集する")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    }
                    }
                    Button(action:{}){
                    HStack{
                        
                        Text("環境設定を変更する")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    }
                    if self.logged{
                    Button(action:{}){
                    HStack{
                        
                        Text("プライバシー管理をする")
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                    }
                    }
                }
                HStack{
                Button(action:{
                    
                    if self.logged{
                        LoginModel.logout = true
//                        selected = "Online"
                    }
                    else {
                    self.login.toggle()
                    }
                }){
                HStack{
                    if self.logged{
                    Text("ログアウトする")
                        .font(.subheadline)
                    }
                    else
                    {
                    Text("ログインする")
                        .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                }
                }
                }.padding(.horizontal,25)
                
                VStack(spacing : 20){
                    
                    HStack(spacing : 10){
                        
                        Image(systemName: "bell.fill")
                            
                            .foregroundColor(Color("top"))
                        
    //                    Spacer()
                        
                        Toggle(isOn: $notify){
                            Text("通知")
                                .bold()
                        }.toggleStyle(SwitchToggleStyle(tint: Color("top")))
                    }.padding(.trailing)
                    
                    HStack(spacing : 10){
                        
                        Image(systemName: "moon.circle.fill")
                            
                            .foregroundColor(Color("top"))
                        
    //                    Spacer()
                        
                        Toggle(isOn: $darkmode){
                            Text("ダークモード")
                                .bold()
                        }.toggleStyle(SwitchToggleStyle(tint: Color("top")))
                    }.padding(.trailing)
                    
                }
//                .padding(.horizontal,15)
                
                
                Spacer()
                
            }.padding(.horizontal)
            
//            VStack(spacing : 30){
//                if LoginModel.logged {
//                Button(action:{}){
//                HStack{
//
//                    Text("プロフィールを編集する")
//                        .font(.subheadline)
//
//                    Spacer()
//
//                    Image(systemName: "chevron.right")
//                }
//                }
//
//                Button(action:{}){
//                HStack{
//
//                    Text("環境設定を変更する")
//                        .font(.subheadline)
//
//                    Spacer()
//
//                    Image(systemName: "chevron.right")
//                }
//                }
//
//                Button(action:{}){
//                HStack{
//
//                    Text("プライバシー管理をする")
//                        .font(.subheadline)
//
//                    Spacer()
//
//                    Image(systemName: "chevron.right")
//                }
//                }
//                }
//
//                Button(action:{
//
//                    if LoginModel.logged{
//                        LoginModel.Logout()
//                    }
//                    else {
//                    self.login.toggle()
//                    }
//                }){
//                HStack{
//
//                    Text(LoginModel.logged ? "ログアウトする" : "ログインする")
//                        .font(.subheadline)
//
//                    Spacer()
//
//                    Image(systemName: "chevron.right")
//                }
//                }
//
//
//            }.frame(width : maxwidth - 75, height : 400,alignment : .bottom)
            
//            Spacer()
            
//            VStack(spacing : 20){
//
//                HStack(spacing : 10){
//
//                    Image(systemName: "bell.fill")
//
//                        .foregroundColor(Color("top"))
//
////                    Spacer()
//
//                    Toggle(isOn: $notify){
//                        Text("通知")
//                            .bold()
//                    }.toggleStyle(SwitchToggleStyle(tint: Color("top")))
//                }.padding(.trailing)
//
//                HStack(spacing : 10){
//
//                    Image(systemName: "moon.circle.fill")
//
//                        .foregroundColor(Color("top"))
//
////                    Spacer()
//
//                    Toggle(isOn: $darkmode){
//                        Text("ダークモード")
//                            .bold()
//                    }.toggleStyle(SwitchToggleStyle(tint: Color("top")))
//                }.padding(.trailing)
//
//            }
//            .padding(.horizontal,15)
//            .frame(width : maxwidth,height : 620, alignment : .bottom)
            
            Spacer()
            
            VStack{
                Button(action:{
//                    withAnimation{
                    selected = "Online"
//                        self.login.toggle()
//                    }
                    Stored_Username = username
                }){
                ZStack{
                    RoundedRectangle(cornerRadius: 0)
                        .fill(Color("top"))
                Text("変更を保存する")
                    .bold()
                    .foregroundColor(Color("primary"))
                    .padding(.bottom)
                }.frame(height : 80)
                }
            }.frame(height : maxheight, alignment: .bottom)

//            Spacer()
        }
        .frame(width : maxwidth, height : maxheight,alignment : .top)
        .padding(.bottom,100)
        .sheet(isPresented: $login, content: {
            Login(selected: $selected, login : $login)
        })
        .alert(isPresented: $LoginModel.logout, content: {
            Alert(title: Text("Message"), message: Text("本当にログアウトしますか？"), primaryButton: .default(Text("Yes"), action: {
                
                // storing Info For BioMetric...
                LoginModel.Logout()
                
                withAnimation{
                    self.logged = false
                    username = "Please Login"
                }
                
            }), secondaryButton: .cancel())
        })
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(navbarhide)
        .onAppear(perform: { username = self.Stored_Username})
        
    }

}

struct AccountSetting_Previews: PreviewProvider {
    
    @State static var selected = ""
    @State static var username = "masaki"
    static var previews: some View {
        AccountSetting(selected: $selected, username : username)
    }
}
