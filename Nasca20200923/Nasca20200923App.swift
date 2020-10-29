//
//  Nasca20200923App.swift
//  Nasca20200923
//
//  Created by masaki on 2020/09/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct Nasca20200923App: App {
    let persistenceController = PersistenceController.shared

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            FBTest1()
//            Home2()
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class AppDelegate : NSObject,UIApplicationDelegate, GIDSignInDelegate, ObservableObject {
    
    @Published var email = ""
    
    func application(_ application : UIApplication,
         didFinishLaunchingWithOptions launchoptions : [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool{
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        return true
    }
        
    func sign(_ signIn : GIDSignIn!, didSignInFor user : GIDGoogleUser!, withError error : Error!) {
        
        guard let user = user else {
            print(error.localizedDescription)
            return}
        
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken:user.authentication.accessToken)
        //Signing in to Firebase
        
        Auth.auth().signIn(with:credential){
            (result, err) in
            
            if err != nil {
                
                print((err?.localizedDescription)!)
                return
            }
            
            self.email = (result?.user.email)!
            print(result?.user.email!)
        }
        
    }
    
}
