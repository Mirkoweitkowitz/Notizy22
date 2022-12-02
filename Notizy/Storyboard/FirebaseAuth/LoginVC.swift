//
//  LoginVC.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 18.10.22.
//

import UIKit
import FirebaseAuth
import LocalAuthentication


class LoginVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
        passwordTF.delegate = self
      
//        MARK: - Check for User logged in
        guard let uid = Auth.auth().currentUser?.uid else {
              return print("no current user!")
            }
            if !uid.isEmpty{
              print("USER: \(uid)")
              faceId()
            }
        
    
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    


    
    
    @IBAction func logging(_ sender: UIButton) {
        
        let email = emailTF.text!
        let password = passwordTF.text!
       
        
        
        if !email.isEmpty && !password.isEmpty {
            
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                
                if error != nil {
                    print("Etwas ist schiefgelaufen beim Login")
                } else {
                    self.performSegue(withIdentifier: "loginSuccessful", sender: nil)
                }
                
            }
            
        }
        
     
    }
    
    func showMessage(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        
       
    }
    func faceId (){
        let context = LAContext()
        
        context.localizedCancelTitle = "Cancel"
        var error: NSError?
        
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Log in to your account"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
                if success {
                    DispatchQueue.main.async { [unowned self] in
                        self.showMessage(title: "Login Successful", message: nil)
                        
                        tabBarItem.title = "Account"
                        tabBarController?.tabBar.items![4].title = "Account"
                        tabBarController?.tabBar.items![4].image =
                        UIImage(systemName: "brain.head.profile")

                      performSegue(withIdentifier: "loginSuccessful", sender: self )
                    }
                } else {
                    DispatchQueue.main.async { [unowned self] in
                        self.showMessage(title: "Login Failed", message: error?.localizedDescription)
                      
                    }
                }
            }
        } else {
            showMessage(title: "Failed", message: error?.localizedDescription)
        }
    }
    
}
