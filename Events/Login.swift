
//
//  Login.swift
//  Events
//
//  Created by Gagandeep Sawhney on 9/18/15.
//  Copyright (c) 2015 FV iMAGINATION. All rights reserved.
//
import UIKit
import Parse
import ParseUI
class Login: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate  {
    var logInViewController: PFLogInViewController! = PFLogInViewController()
    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
    var alertBuyShit = UIAlertView()
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(NSDate())
        if (PFUser.currentUser() == nil) {
            
            self.logInViewController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton]
            
            let logInLogoTitle = UILabel()
            logInLogoTitle.text = "Sign In To Save The World!"
            logInLogoTitle.font = UIFont(name: "Helvetica-Light", size: 30)
            
            self.logInViewController.logInView!.logo = logInLogoTitle
            
            self.logInViewController.delegate = self
            
            let SignUpLogoTitle = UILabel()
            SignUpLogoTitle.text = "Sign In To Save The World!"
            
            self.signUpViewController.signUpView!.logo = SignUpLogoTitle
            
            self.signUpViewController.delegate = self
            
            self.logInViewController.signUpController = self.signUpViewController
            self.presentViewController(self.logInViewController, animated: true, completion: nil)
            
        }else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("nextView") as! UITabBarController
            self.presentViewController(nextViewController, animated:true, completion:nil)
        }
        
    }
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
        
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        }else {
            return false
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        print("Failed to login...")
        alertBuyShit.tag = 5
        alertBuyShit.delegate = self
        alertBuyShit.title = "User not found!"
        alertBuyShit.message = "Try agian, or sign up bellow"
        alertBuyShit.addButtonWithTitle("Ok")
        alertBuyShit.show()

    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController!) {
        
    }
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
        
        print("FAiled to sign up...")
        
    }
    
    
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
        
        print("User dismissed sign up.")
        
    }
    @IBAction func simpleAction(sender: AnyObject) {
        
        self.presentViewController(self.logInViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func customAction(sender: AnyObject) {
        
        self.performSegueWithIdentifier("custom", sender: self)
        
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        
        PFUser.logOut()
        
    }

}
