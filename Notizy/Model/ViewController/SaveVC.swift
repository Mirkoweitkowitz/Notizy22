//
//  SaveViewController.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 09.09.22.
//

import UIKit

class SaveVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate {
    
    // Referenz zum Core Data Persistent Store / managedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //    MARK: - Kontaktliste erstellen
    
    public var contact:Contact?
    //    var adress = ""
    //    var mail = ""
    //    var notes = ""
    
    
    //MARK: - Outlets & Variablen
    @IBOutlet weak var nameTXT: UITextField!
    @IBOutlet weak var adressTXT: UITextField!
    @IBOutlet weak var emailTXT: UITextField!
    @IBOutlet weak var notizenTXTview: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        nameTXT.text = contact?.name
        adressTXT.text = contact?.adress
        emailTXT.text = contact?.email
        notizenTXTview.text = contact?.notes
        
        
        
        
    }
    
    @IBAction func backBTN(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func saveBTN(_ sender: UIBarButtonItem) {
        
        // Neuen Kontakt erzeugen
        let newContact = Contact(context: self.context)
        newContact.name = nameTXT.text
        newContact.adress = adressTXT.text
       
        newContact.email = emailTXT.text
        newContact.notes = notizenTXTview.text
        
   
        
        // Save context
        do {
            try self.context.save()
        } catch {
            print("Error; context saving")
        }
        
        // Daten per Notification Center senden:
        NotificationCenter.default.post(name: NSNotification.Name.init("de.ViewsWechseln.addContact"), object: newContact)
        
        self.dismiss(animated: true)
        
    }
    
}
