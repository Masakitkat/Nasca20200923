//
//  FBTest1.swift
//  Nasca20200923
//
//  Created by masaki on 2020/10/18.
//

import SwiftUI
import Firebase
import LocalAuthentication
import GoogleSignIn

struct FBTest1: View {
    @AppStorage("status") var logged = false
    @Binding var selected : String
    var body: some View {

        NavigationView{
            
            if logged{
                
                OnlineView()
//                    .navigationTitle("Home")
//                    .navigationBarHidden(false)
//                    .preferredColorScheme(.light)
            }
            else{
                
//                Login(selected: $selected)
//                    .preferredColorScheme(.dark)
//                    .navigationBarHidden(true)
            }
        }
    }
}

struct Home: View {
    @AppStorage("status") var logged = false
    var body: some View {
        
        VStack(spacing: 15){
            
            Text("User Logged In As \(Auth.auth().currentUser?.email ?? "")")
            
            Text("User UID \(Auth.auth().currentUser?.uid ?? "")")
            
            Button(action: {
                try! Auth.auth().signOut()
                withAnimation{logged = false}
            }, label: {
                Text("LogOut")
                    .fontWeight(.heavy)
            })
        }
    }
}

struct Login : View {
    
    @ObservedObject var LoginModel = LoginViewModel()
    // when first time user logged in via email store this for future biometric login....
    @AppStorage("stored_User") var Stored_User = ""
    @AppStorage("stored_Password") var Stored_Password = ""
    
    @AppStorage("status") var logged = false
    
    @State var startAnimate = false
    
    @Binding var selected : String
    
    @Binding var login : Bool
    
    var body: some View{
        
        ZStack{
            
            VStack{
                
                Spacer(minLength: 0)
                
                Image("i"+"\(Int.random(in : 1..<10))")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //Dynamic Frame...
                    .padding(.horizontal,35)
                    .padding(.vertical)
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 12, content: {
                        
                        Text("Login")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("top"))
                        
                        Text("Please sign in to continue")
                            .foregroundColor(Color("top").opacity(0.5))
                    })
                    
                    Spacer(minLength: 0)
                }
                .padding()
                .padding(.leading,15)
                
                HStack{
                    
                    Image(systemName: "envelope")
                        .font(.title2)
                        .foregroundColor(Color("top"))
                        .frame(width: 35)
                    
                    TextField("EMAIL", text: $LoginModel.email)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Color("top").opacity(LoginModel.email == "" ? 0.08 : 0.22))
                .cornerRadius(15)
                .padding(.horizontal)
                
                HStack{
                    
                    Image(systemName: "lock")
                        .font(.title2)
                        .foregroundColor(Color("top"))
                        .frame(width: 35)
                    
                    SecureField("PASSWORD", text: $LoginModel.password)
                        .autocapitalization(.none)
                }
                .padding()
                .background(Color("top").opacity(LoginModel.password == "" ? 0.08 : 0.22))
                .cornerRadius(15)
                .padding(.horizontal)
                .padding(.top)
                
                HStack(spacing: 15){
                    
                    Button(action: {
                      
                        LoginModel.verifyUser()
                        
                        if LoginModel.logged {
                            
                            self.login.toggle()
                            
                        }
                        
                    }, label: {
                        Text("ログイン")
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 150)
                            .background(Color("top"))
                            .clipShape(Capsule())
                    })
                    .opacity(LoginModel.email != "" && LoginModel.password != "" ? 1 : 0.5)
                    .disabled(LoginModel.email != "" && LoginModel.password != "" ? false : true)
                    .alert(isPresented: $LoginModel.alert, content: {
                        Alert(title: Text("Error"), message: Text(LoginModel.alertMsg), dismissButton: .destructive(Text("OK")))
                    })
                    
                    if LoginModel.getBioMetricStatus(){
                        
                        Button(action: {
                            LoginModel.authenticateUser()
//                            if LoginModel.logged {
                                self.login = false
//                            }
                            
                        }, label: {
                            
                            // getting biometrictype...
                            Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                                .font(.title)
                                .foregroundColor(Color("primary"))
                                .padding()
                                .background(Color("top"))
                                .clipShape(Circle())
                        })
                    }
                }
                .padding(.top)
                
                // Forget Button...
                
                Button(action: {}, label: {
                    Text("パスワードを忘れましたか?")
                        .foregroundColor(Color("top"))
                })
                .padding(.top,8)
                .alert(isPresented: $LoginModel.store_Info, content: {
                    Alert(title: Text("Message"), message: Text("今後簡単にログインできるよう顔認証を登録しますか？"), primaryButton: .default(Text("YES").foregroundColor(Color.blue), action: {
                        
                        // storing Info For BioMetric...
                        Stored_User = LoginModel.email
                        Stored_Password = LoginModel.password
                        
                        withAnimation{
                            self.logged = true
                            self.login = false
                        }
                        
                    }), secondaryButton: .cancel(Text("Cancel").foregroundColor(Color.red), action:{
                        // redirecting to Home
                        
                        Stored_User = LoginModel.email
                        
                        withAnimation{
                            self.logged = true
                            self.login = false
                        }
                        
                    })
                    )
                })
                
                // SignUp...
                
                Spacer(minLength: 0)
                
                HStack(spacing: 5){
                    
                    Text("EMAILとPASSWORDを入力して")
                        .foregroundColor(Color("top").opacity(0.6))
                    
                    Button(action: {
                        
                        LoginModel.createUser()
                        
                        
                    }, label: {
                        Text("新規登録")
                            .fontWeight(.heavy)
                            .foregroundColor(Color("top"))
                    })
                }
                .padding(.vertical)
            }
            .background(Color("primary").ignoresSafeArea(.all, edges: .all))
            .animation(startAnimate ? .easeOut : .none)
            if LoginModel.isLoading{
//                Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
                Loading_Screen()
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.startAnimate.toggle()
            }
        })
    }
}

struct Loading_Screen: View {
    @State var animate = false
    var body: some View {
        
        ZStack{
            
            Color.black.opacity(0.3)
                .ignoresSafeArea(.all, edges: .all)
            
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(Color("top"),lineWidth: 10)
                .frame(width: 60, height: 60)
                .rotationEffect(.init(degrees: animate ? 360 : 0))
                .padding(40)
                .background(Color.white)
                .cornerRadius(15)
        }
        .onAppear(perform: {
            withAnimation(Animation.linear.speed(0.6).repeatForever(autoreverses: false)){
                animate.toggle()
            }
        })
    }
}

class LoginViewModel : ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    
    // For Alerts..
    @Published var alert = false
    @Published var alertMsg = ""
    
    // User Data....
    
    @AppStorage("stored_User") var Stored_User = ""
    
    @AppStorage("stored_Password") var Stored_Password = ""
    
    @AppStorage("status") var logged = false
    
    @Published var store_Info = false
    
    // Loading Screen...
    @Published var isLoading = false
    
    @Published var modal = false
    
    @Published var logout = false
    
    // Getting BioMetricType....
    
    func getBioMetricStatus()->Bool{
        
        let scanner = LAContext()
        if email != "" && email == Stored_User && scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none){

            return true
        }
        
        return false
    }
    
    // authenticate User...
    
    func authenticateUser(){
        
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To Unlock \(email)") { (status, err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            // Settig User Password And Logging IN...
            DispatchQueue.main.async {
                self.password = self.Stored_Password
                self.verifyUser()
            }
        }
    }
    
    // Verifying User...
    
    func verifyUser(){
        
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            
            self.isLoading = false
            
            if let error = err{
                self.alertMsg = error.localizedDescription
                self.alert.toggle()
                return
            }
            
            // Success
            
            // Promoting User For Save data or not...
            
            if self.Stored_User == "" || self.Stored_Password == "" || self.Stored_User != self.email {
                self.store_Info.toggle()
                return
            }
            
            // Else Goto Home...
            
            withAnimation{self.logged = true}
        }
    }
    
    func createUser() {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, err in
            
            self.isLoading = false
            
            if let error = err{
                
                self.alertMsg = error.localizedDescription
                self.alert.toggle()
                return
            }
            
            if self.Stored_User == "" || self.Stored_Password == ""{
                self.store_Info.toggle()
                return
            }
            
            withAnimation{self.logged = true}
        }
    }
    func Logout(){
        
       
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
//            self.Stored_User = ""
//            self.Stored_Password = ""
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        withAnimation{self.logged = false}
    }
    
}
