//
//  EditViewController.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 09.09.22.
//

import UIKit



class EditVC: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Variablen zur Annahme der Daten
    var contact: Contact!
    var contactIndex: Int!
    
//    MARK: Image über Button auswählen
    let imagePicker = UIImagePickerController()
    
    
    // Referenz zum Core Data Persistent Store / managedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegate: ContactDelegate?
    
    
    @IBOutlet weak var imgContact: UIImageView!
    
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var nameTXT: UITextField!
    
    @IBOutlet weak var nameLBL: UILabel!
    
    @IBOutlet weak var adressTXT: UITextField!
    
    @IBOutlet weak var adressLBL: UILabel!
    
    @IBOutlet weak var emailTXT: UITextField!
    
    @IBOutlet weak var emailLBL: UILabel!
    
    @IBOutlet weak var notizTXTView: UITextView!
    
 
    @IBOutlet weak var notizenLBL: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func dismissDetailView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    //MARK: Edit-Button Tapped
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        
        if nameTXT.isHidden {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(editButtonTapped(_:)))
            nameLBL.isHidden = true
            adressLBL.isHidden = true
            emailLBL.isHidden = true
            notizenLBL.isHidden = true
           
            
            nameTXT.isHidden = false
            adressTXT.isHidden = false
            emailTXT.isHidden = false
            notizTXTView.isEditable = true
            
            
            nameTXT.text = nameLBL.text
            adressTXT.text = adressLBL.text
            emailTXT.text = emailLBL.text
            
            saveButton.isHidden = false
            btnCamera.isHidden = false
        
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
            nameLBL.isHidden = false
            adressLBL.isHidden = false
            emailLBL.isHidden = false
            notizenLBL.isHidden = false

            
            nameTXT.isHidden = true
            adressTXT.isHidden = true
            emailTXT.isHidden = true
            
            notizTXTView.isEditable = false
            notizTXTView.text = contact.notes
            
            saveButton.isHidden = true
            btnCamera.isHidden = true
        }
    }
    
    
    
 
    
    //MARK: Button: ContactModel speichern
    @IBAction func speichernBTN(_ sender: UIButton) {
        
        contact.name = nameTXT.text
        contact.adress = adressTXT.text
        contact.email = emailTXT.text
        contact.notes = notizTXTView.text
        contact.image = imgContact.image?.jpegData(compressionQuality: 1.0)
        
        delegate?.update(contact: contact, index: contactIndex)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
        
        nameLBL.text = contact.name
        adressLBL.text = contact.adress
        emailLBL.text = contact.email
        notizTXTView.text = contact.notes
        
        nameLBL.isHidden = false
        adressLBL.isHidden = false
        emailLBL.isHidden = false
        
        nameTXT.isHidden = true
        adressTXT.isHidden = true
        emailTXT.isHidden = true
        notizTXTView.isEditable = false
        
        btnCamera.isHidden = true
        saveButton.isHidden = true
        
        // Save Data
        do {
            try self.context.save()
        } catch {
            print("Error")
        }
      
        
    }
    
    //MARK: Toolbar und DatePicker
    func createToolbar() -> UIToolbar {
        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Done Button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    @objc func donePressed() {
        
        if notizTXTView.isFocused {
            notizTXTView.endEditing(true)
        } else {
            
            self.view.endEditing(true)
        }
    }


    
    @IBAction func cameraBTN(_ sender: UIButton) {
        
        
        imagePicker.allowsEditing = false
           imagePicker.sourceType = .photoLibrary
               
           present(imagePicker, animated: true, completion: nil)
       
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgContact.contentMode = .scaleAspectFit
            imgContact.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }
    
    
//     MARK: schließt den ImagePicker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

//Keyboard verschwinden lassen
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return false
}


override func viewDidLoad() {
    super.viewDidLoad()
    
    // Daten des aktuellen ContactModels anzeigen lassen
    nameLBL.text = contact.name
    adressLBL.text = contact.adress
    emailLBL.text = contact.email
    notizTXTView.text = contact.notes
    
    if contact.image != nil{
        imgContact.image = UIImage(data: contact.image!)
    }
    
    imagePicker.delegate = self
    
    // Text View verschönern
    notizTXTView.layer.cornerRadius = 3
    notizTXTView.layer.borderWidth = 1
    notizTXTView.layer.borderColor = UIColor.lightGray.cgColor
    
    // Delegates
    nameTXT.delegate = self
    adressTXT.delegate = self
    emailTXT.delegate = self
    notizTXTView.delegate = self
    
    notizTXTView.inputAccessoryView = createToolbar()
  
    
    // Keyboard sichtbar: View verschieben
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }

// objc functions: View verschieben bei aktivem Keyboard
@objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0 && (notizTXTView.isFirstResponder || emailLBL.isFirstResponder) {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
}

@objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
        self.view.frame.origin.y = 0
      }
  }
    
  
}



