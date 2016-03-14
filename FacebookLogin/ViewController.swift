//
//  ViewController.swift
//  FacebookLogin
//
//  Created by Alexander Baquiax on 3/11/16.
//  Copyright © 2016 Alexander Baquiax. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController : UIViewController, FBSDKLoginButtonDelegate {
    var userName : UITextView?
    var pictureView : FBSDKProfilePictureView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(FBSDKAccessToken.currentAccessToken() == nil) {
            print("Not logged in.")
        } else {
            self.userName = UITextView(frame:  CGRect(x: 50, y: 50, width: 100, height: 100))
            self.pictureView = FBSDKProfilePictureView(frame: CGRect(x: 50, y: 100, width: 200, height: 200))
            self.view.addSubview(self.userName!)
            self.view.addSubview(self.pictureView!)
            let req = FBSDKGraphRequest(graphPath: "me", parameters: nil)
            req.startWithCompletionHandler({ (connection, result , error: NSError!) -> Void in
                if (error == nil) {
                    let resultDict = result as! Dictionary<String, String>
                    self.userName!.text = resultDict["name"]
                    self.pictureView?.profileID = resultDict["id"]
                }

            })
            print("Logged in.")
        }
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if(error == nil) {
            print("Logged in!")
            let pictureRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
            pictureRequest.startWithCompletionHandler({
                (connection, result, error: NSError!) -> Void in
                if error == nil {
                    let req = FBSDKGraphRequest(graphPath: "me", parameters: nil)
                    req.startWithCompletionHandler({ (connection, result , error: NSError!) -> Void in
                        if (error == nil) {
                            let resultDict = result as! Dictionary<String, String>
                            self.userName!.text = resultDict["name"]
                            self.pictureView?.profileID = resultDict["id"]
                        }
                        
                    })
                } else {
                    print("\(error)")
                }
            })
        } else {
            print(error.localizedDescription)
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.userName?.text = "";
        self.pictureView?.profileID = "";
        print("Logged out!")
    }
    
}

