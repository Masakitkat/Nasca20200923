//
//  TopView.swift
//  Nasca20200923
//
//  Created by masaki on 2020/09/24.
//

import SwiftUI


struct TopView: View {
    
    @State private var scaleYleft = false
    @State private var scaleXleft = false
    @State private var scaleYmiddle = false
    @State private var scaleXmiddle = false
    @State private var scaleYright = false
    @State private var scaleXright = false
    
    @Binding var selected : String
    @State var check : CGFloat = 0.0
    @State var move1 = false

    @State var offset : CGFloat = 0
    
    var swipe_backgroundcolor = Color.white
    var swipe_smallcircle = Color("top")
    
    func onChanged(value : DragGesture.Value){
        
        if value.translation.width > 0 && offset <= UIScreen.main.bounds.width - 60 - 80 {
            
            offset = value.translation.width
            
        }
        
    }
    
    
    func onEnd(value : DragGesture.Value){
        
        withAnimation(Animation.easeOut(duration: 0.3)){
            
            if offset > 180 {
                
                offset = UIScreen.main.bounds.width - 60 - 80
                 
                DispatchQueue.main.asyncAfter(deadline : .now() + 0.1){
                    
                    selected = "memo"
                    
                }
            }
            else {
                
                offset = 0
            }
            
        }
        
        
    }

    func calculateWidth()->CGFloat{
        
        let percent = offset / UIScreen.main.bounds.width
        
        return percent * UIScreen.main.bounds.width
        
    }
    
    var body: some View {
        
        
        GeometryReader{
            geometry in

            ZStack {
                
                TopShape_1().fill(Color(#colorLiteral(red: 0.9531899095, green: 0.7879680991, blue: 0, alpha: 1)))
                TopShape_2().fill(Color(#colorLiteral(red: 0.1428147554, green: 0.191432029, blue: 0.9183178544, alpha: 1)))
                TopShape_3().fill(Color(#colorLiteral(red: 0.8964173198, green: 0.3757638931, blue: 0.4421405494, alpha: 1)))
            }
            
            ZStack{
                VStack(alignment: .leading)
                {
                    Text("Nasca")
                        .font(.largeTitle)
                        .bold()
                    Text("Expand your map with us ")
                    
                }
                .frame(width: geometry.size.width / 1.05, height :geometry.size.height/8.5, alignment : .topLeading)
                
                
                
                
                VStack{
                    Spacer()
                        .frame(height: 150)
                
                ZStack{
                    
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(swipe_backgroundcolor.opacity(0.4))
                        .shadow(color: Color.white.opacity(0.6), radius: 1, x: 1, y: 2)
                    
                    Text("Swipe To Start")
                        .foregroundColor(swipe_smallcircle)
                        .fontWeight(.semibold)
                        .padding(.leading,20)
                    
                    HStack{
                        
                        
                        RoundedRectangle(cornerRadius:20)
                            .fill(swipe_smallcircle)
                            .frame(width : calculateWidth() + 60)
                        
                        
                        Spacer(minLength: 0)
                        
                    }
                    
                    HStack{
                        
                        ZStack{
                        Image(systemName: "chevron.right")
                        
                        Image(systemName: "chevron.right")
                            .offset(x : -5)
                    }
                    .foregroundColor(.white)
                    .offset(x:3)
                    .frame(width :60, height : 55)
                    .background(swipe_smallcircle)
                    .clipShape(RoundedRectangle(cornerRadius:20))
                        .offset(x:offset)
                        .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
                        
                        Spacer()
                    }
                    
                }.frame(width : UIScreen.main.bounds.width - 80, height : 60)
                .padding(.trailing)
                
//                .padding(.bottom)
                
//                    Spacer().frame(height : 80)
                HStack(alignment: .center) {
                    
                    ZStack {
//                                Circle()
//                                    .frame(width:15,height:15)
//                                    .opacity(0.3)
                        
                        Circle()
                            .frame(width:15,height:15)
                            .opacity(0.8)
                            .foregroundColor(Color(#colorLiteral(red: 0.8964173198, green: 0.3757638931, blue: 0.4421405494, alpha: 1)))
                            .scaleEffect(x: scaleXleft ? 1 : 0.7, y : scaleYleft ? 1 : 0.3, anchor : .center)
                            .animation(Animation.easeInOut(duration:0.8).repeatCount(150, autoreverses: true))
                            .onAppear(){
                                self.scaleYleft.toggle()
                                self.scaleXleft.toggle()
                            }
                    }
                    ZStack{
//                                Circle()
//                                    .frame(width:10,height:10)
//                                    .opacity(0.3)
                        
                        Circle()
                            .frame(width:13,height:13)
                            .opacity(0.8)
                            .foregroundColor(Color(#colorLiteral(red: 0.1428147554, green: 0.191432029, blue: 0.9183178544, alpha: 1)))
                            .scaleEffect(x: scaleXmiddle ? 1 : 0.7, y : scaleYmiddle ? 1 : 0.5, anchor : .bottom)
                            .animation(Animation.easeInOut(duration:0.7).repeatCount(150, autoreverses: true).delay(0.2))
                            .onAppear(){
                                self.scaleYmiddle.toggle()
                                self.scaleXmiddle.toggle()
                            }
                }
                    
                    
                    ZStack{
//                                Circle()
//                                    .frame(width:10,height:10)
//                                    .opacity(0.3)
//
                        Circle()
                            .frame(width:11,height:11)
                            .opacity(0.7)
                            .foregroundColor(Color(#colorLiteral(red: 0.9531899095, green: 0.7879680991, blue: 0, alpha: 1)))
                            .scaleEffect(x: scaleXright ? 1 : 0.7, y : scaleYright ? 1 : 0.3, anchor : .bottom)
                            .animation(Animation.easeInOut(duration:0.9).repeatCount(150, autoreverses: true).delay(0.1))
                            .onAppear(){
                                self.scaleYright.toggle()
                                self.scaleXright.toggle()
                            }
                }
                
                }
                .frame(height : 50,alignment :.bottom)
    
                }.frame(height :geometry.size.height - 150, alignment : .bottomLeading)
                
//                Button(action:{
//                    withAnimation(.interactiveSpring()){
//                    selected = "Inst"
////                        check -= 800
//                    }
//                }){
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 8)
//                            .frame(width: 180,height : 45)
//                            .padding()
//
//                        Text("Begin your journey")
//                            .foregroundColor(.white)
//
//                    }
//                }
//                .foregroundColor(Color("top"))
//                .buttonStyle(GradientButtonStyle())
//                .frame(width: geometry.size.width, height :geometry.size.height/9, alignment : .topTrailing)
                
                
            
//            }
                
                
            } .frame(width: geometry.size.width, height :geometry.size.height)
            
            
        }
//        .offset(y : check)
        .background(Color(#colorLiteral(red: 0.9454948306, green: 0.9048054814, blue: 0.8575084209, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
    }
}

//struct TopView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        TopView()
//    }
//}

//struct Topshape_Previews: PreviewProvider {
//    static var previews: some View {
//        TopShape_1().fill(Color.yellow)
//        TopShape_2()
//    }
//}

struct TopShape_1: Shape {
    func path( in rect : CGRect) -> Path {
        Path { path in
            let scale = min(rect.width,rect.height)
            
            path.addLines([
            
                CGPoint(x : scale * 0, y: scale * 0),
                CGPoint(x : scale * -1, y: scale * 0.8),
                CGPoint(x : scale * 1, y: scale * 0),
            ])
            path.closeSubpath()
        }
    }
}

struct TopShape_2: Shape {
    func path( in rect : CGRect) -> Path {
        Path { path in
            let scale = min(rect.width,rect.height)
            
            path.addLines([
            
                CGPoint(x : scale * 1.5, y: scale * -0.2),
                CGPoint(x : scale * 1, y: scale * 0.5),
                CGPoint(x : scale * -1.1, y: scale * 0.81),
            ])
            path.closeSubpath()
        }
    }
}

struct TopShape_3: Shape {
    func path( in rect : CGRect) -> Path {
        Path { path in
            let scale = min(rect.width,rect.height)
            
            path.addLines([
            
                CGPoint(x : scale * 1.2, y: scale * 0.475),
                CGPoint(x : scale * 0, y: scale * 0.65),
                CGPoint(x : scale * -0.3, y: scale * 1.08),
            ])
            path.closeSubpath()
        }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView(selected: .constant("abc"))
    }
}


