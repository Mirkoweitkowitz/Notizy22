//
//  AccountVC.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 20.10.22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var pwValidationTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpBtnTapped(_sender: UIButton) {
        signUp()
        
    }
    
    
    func signUp() {
        
        var validated = false
        
        //    Textfields in Konstanten ablegen
        let name = nameTF.text!
        let email = emailTF.text!
        let password = passwordTF.text!
        let pwValidation = pwValidationTF.text!
        
        //    1.Validierung: Sind die Felder alle gefüllt?
        
        if !name.isEmpty && !email.isEmpty && !password.isEmpty && !pwValidation.isEmpty {
            
//            2. Validierung: Sind spezifische Bedingungen erfüllt?
            
            if !email.contains("@") {
                createAlert(withTitle:"Email", andMessage: "Bitte gib eine korrekte Emai an.")
            } else if password.count < 8 {
                createAlert(withTitle: "Password", andMessage:"Das Password muss mind.8 Zeichen beinhalten.")
            } else if password != pwValidation {
                createAlert(withTitle: "Password", andMessage: "Passwörter stimmen nicht überein.")
                
            } else {
                validated = true
            }
            
        } else {
            createAlert(withTitle: "Fehler", andMessage: "Bitte fülle alle Felder aus.")
        }
        
        //MARK: - User erstellen, wenn Validation erfolgreich
        if validated {
            
            // User erstellen
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    self.createAlert(withTitle: "Fehler", andMessage: "Es ist ein unbekannter Fehler aufgetreten.")
                } else {
                    
                    // Create Firestore
                    let db = Firestore.firestore()
                    db.collection("Users").addDocument(data: [
                        "userName": name,
                        "email": email,
                        "uid": authResult?.user.uid as Any
                    ]) { error in
                        
                        if error != nil {
                            self.createAlert(withTitle: "Fehler", andMessage: "Es ist ein Fehler aufgetreten")
                        } else {
                            self.performSegue(withIdentifier: "signupSuccessful", sender: nil)
                        }
                        
                        
                    }
                }
                
            }
        }
    }
    
    
    //MARK: - Create Alert Func
    func createAlert(withTitle: String, andMessage: String) {
        
        let alertController = UIAlertController(title: withTitle, message: andMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
       
        
        self.present(alertController, animated: true)
        
    }

    
}
