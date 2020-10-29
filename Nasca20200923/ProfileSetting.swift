//
//  ProfileSetting.swift
//  Nasca20200923
//
//  Created by masaki on 2020/10/27.
//

import SwiftUI
import Combine

struct ProfileSetting: View {
    
    var maxheight = UIScreen.main.bounds.height
    var maxwidth = UIScreen.main.bounds.width
    
    @Binding var username : String
    @Binding var navbarhide : Bool
    @AppStorage("stored_User") var Stored_User = ""
    @AppStorage("Introduction") var intro = ""
    @State var editing = false
    
    var body: some View {

        ZStack{
            if self.editing != true {
            ZStack{
            VStack{
            Image("r16")
                .resizable()
                .scaledToFill()
                .frame(height : maxheight/3,alignment : .top)
            Spacer()
            }
                
            
            VStack{
//                Spacer()
                ZStack{
                Image("r16")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width : 120,height : 120)
                    .overlay(
                        Circle().stroke(Color.white,lineWidth: 3)
                    )
                    .shadow(radius: 10,x:5,y:5)
                }.frame(height : maxheight/1.6)
                Spacer()
            }
            
            VStack(alignment : .leading,spacing : 5){
            Spacer()
                .frame(height : maxheight/5)
                
            Text("User Name")
                .foregroundColor(.gray)
            
            TextField("User Name",text: self.$username)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
                .background(Color.white.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 3))
            
            
            Text("Introduction")
                .foregroundColor(.gray)
                ZStack{
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.white.opacity(0.5))
                Text(self.intro != "" ? self.intro : "入力する")
                    .foregroundColor(Color.black)
                    .frame(width :maxwidth-20, height : 30, alignment : .leading)
                }
                .frame(width :maxwidth-20, height : 30, alignment : .leading)
                    
//                .underline()
                
                .onTapGesture(perform: {
                    withAnimation{
                        self.navbarhide = true
                        self.editing.toggle()
                    }
                })
            
                
//            Spacer()
            
            Divider()
            
                VStack(alignment : .leading,spacing : 10){
            Text("Profile Info")
                .bold()
            
            Text("E-mail")
                .foregroundColor(.gray)
            Text(Stored_User)
            
            Text("性別")
                .foregroundColor(.gray)
            Text("男性")
    
            Text("年代")
                .foregroundColor(.gray)
            Text("20代")
            
            }
            }
        .padding(.horizontal,30)
            }
            }
            if self.editing{
                
                Edit(editing: $editing,navbarhide : $navbarhide)
            }
            
        }
        .frame(width : maxwidth, height : maxheight)
        .background(Color("primary"))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
        .navigationBarHidden(navbarhide)
        .onAppear(perform: {self.navbarhide = false})
        .keyboardAdaptive()
        
    }
}
//
//struct ProfileSetting_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSetting()
//    }
//}

struct Edit : View{
    
    @AppStorage("Introduction") var intro = ""
    @Binding var editing : Bool
    @Binding var navbarhide : Bool
    @State var initial_text = ""
    
    var maxheight = UIScreen.main.bounds.height
    var maxwidth = UIScreen.main.bounds.width
    
    var body : some View {
        
        
        VStack(alignment : .leading){
            ZStack{
            HStack{
                
                Button(action:{
                    self.editing.toggle()
                    self.navbarhide = false
                }){
                Image(systemName: "xmark")
                    .foregroundColor(Color.red)
                }
                Spacer()
                
                Text("Introduction")
                    .bold()
                    .font(.headline)
                    .foregroundColor(Color.white)
                Spacer()
                
                Button(action:{
                    self.editing.toggle()
                        intro = self.initial_text
                    self.navbarhide = false
                }){
                Image(systemName: "checkmark")
                    .foregroundColor(Color.blue)
                }
            }
            .frame(height:50)
            .padding(.horizontal,30)
            }
            .frame(height:120,alignment : .bottom)
            .edgesIgnoringSafeArea(.top)
            .background(Color("top"))
            TextEditor(text: $initial_text)
                .font(.subheadline)
                .background(Color.white)
//                .padding(.horizontal)
                .frame(height : self.intro.count >= 10 ? 200 : 100)
            Spacer()
            
        }
        .frame(width : maxwidth, height : maxheight)
        .navigationBarHidden(true)
        .onAppear(perform: {
                    initial_text = self.intro
        })
    }
    
    
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}

extension Publishers {
    // 1.
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    private static weak var _currentFirstResponder: UIResponder?

    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }

    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    @State private var bottomPadding: CGFloat = 0
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
        content
//            .padding(.bottom, keyboardHeight)
//            .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
            .padding(.bottom, self.bottomPadding)
            .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
                
            }
            }.animation(.easeOut(duration: 0.16))
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
}

