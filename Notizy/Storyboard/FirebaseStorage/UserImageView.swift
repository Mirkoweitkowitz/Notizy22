//
//  UserImageView.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 08.11.22.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class UserImageView: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //    MARK: Image über Button auswählen
    let imagePicker = UIImagePickerController()
    
    
    // Referenz zum Core Data Persistent Store / managedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameThisImgTF: UITextField!
    
    
    
    
    @IBAction func cameraBTN(_ sender: UIButton) {
        
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imgView.contentMode = .scaleAspectFit
            imgView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //     MARK: schließt den ImagePicker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Keyboard verschwinden lassen
    //    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //    textField.endEditing(true)
    //    return false
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        nameThisImgTF.delegate = self
        
        // Keyboard sichtbar: View verschieben
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // objc functions: View verschieben bei aktivem Keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && (nameThisImgTF.isFirstResponder) {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    @IBAction func uploadImgBtnTapped(_ sender: UIButton) {
        
        // Test, ob ein Bild vorhanden ist
        guard imgView.image != nil else { return }
        
        // Referenz zum Storage
        let storageRef = Storage.storage().reference()
        
        // Bild in Data umwandeln
        guard let imageData = imgView.image?.pngData() else { return }
        
        guard (imgView.image?.jpegData(compressionQuality: 1.0)) != nil else { return }
        
       
        
//                 File Path festlegen
//
        
//        let path = "images/\(nameThisImgTF.text!).png"
        
        if let user = Auth.auth().currentUser{
            let path = "userimages/\(user.uid).png"
            let fileRef = storageRef.child(path)
            print("user")
            
            // Daten hochladen
            _ = fileRef.putData(imageData) { metadata, error in
                if error == nil {
                    print("test image")
                    
                    let db = Firestore.firestore()
                    db.collection("userimages").document(user.uid).setData([
                        "imageurl": path
                        
                    ])
                }else {
                    print(error!)
                }
        }
      
            
        }
        NotificationCenter.default.post(name: NSNotification.Name.init("de.Notizy.UserImageView.userImage"), object: imageData)
    }

    
    
    /*
     // MARK: - Navigation
     
      In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      Get the new view controller using segue.destination.
      Pass the selected object to the new view controller.
     }
     */
    
}
