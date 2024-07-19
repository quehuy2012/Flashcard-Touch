//
//  LoginGoogleViewController.swift
//  Flashcard Touch
//
//  Created by TuanAnhVu on 5/13/17.
//  Copyright © 2017 CPU11713. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseDatabase

class LoginGoogleViewController: UIViewController {

    var ref: DatabaseReference!
    var uidLogin = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //test mới vào signOut
        GIDSignIn.sharedInstance().signOut()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

//        // [START screen_view_hit_swift]
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        tracker.set(kGAIScreenName, value: "Login Google View Controller")
//        
//        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
//        tracker.send(builder.build() as [NSObject : AnyObject])
//        // [END screen_view_hit_swift]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginGoogle(_ sender: Any) {
//        // [START custom_event_swift]
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        guard let event = GAIDictionaryBuilder.createEvent(withCategory: "Login", action: "Login google", label: nil, value: nil) else { return }
//        tracker.send(event.build() as [NSObject : AnyObject])
//        // [END custom_event_swift]
        
        GIDSignIn.sharedInstance().signIn()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}


extension LoginGoogleViewController : GIDSignInUIDelegate {
    
}

func convertDateToString(_ date:Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return dateFormatter.string(from: date)
}

extension LoginGoogleViewController: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        }
        if let user = user {
            print(user.profile.email)
            
            let authentication = user.authentication
            let idToken = authentication?.idToken
            let accessToken = authentication?.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken!, accessToken: accessToken!)
            
            Auth.auth().signIn(with: credential, completion: { (fUser, fError) in
                if let fError = fError {
                    print(fError.localizedDescription)
                }
                if let fUser = fUser {
                    //                    print(fUser.displayName ?? "a")
                    //                    print(fUser.uid)
                    self.uidLogin = fUser.uid
                    
                }
                
                let sb = UIStoryboard(name: "Decks", bundle: nil)
                let viewController = sb.instantiateViewController(withIdentifier: "DeckViewController") as!   DeckViewController
                
                //            print(uidLogin)
                viewController.UID = self.uidLogin
                
                //                viewController.mangDictCount = self.mangDictCount
                //                viewController.decks = self.decks
                //                print("-------------\(viewController.decks)")
                //                viewController.decksversion2 = self.decksversion2
                
                self.navigationController?.pushViewController(viewController, animated: true)
                
                
            })
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
