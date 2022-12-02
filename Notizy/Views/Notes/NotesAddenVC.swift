//
//  NotesAddVC.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 21.11.22.
//

import UIKit

class NotesAddenVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    
//    MARK: - ColorWell farbe einstellen für Notiz
    
    @IBOutlet weak var colorWell: UIColorWell! = {
        
        let colorWell = UIColorWell()
        colorWell.supportsAlpha = true
        colorWell.selectedColor = .systemRed
        colorWell.title = "Settings"

        return colorWell
    }()
  
    
    // Referenz zum Core Data Persistent Store / managedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var noteTXT: UITextView!
    
    
    @IBOutlet weak var titleTXT: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTXT.delegate = self
        noteTXT.delegate = self
        
        noteTXT.inputAccessoryView = createToolbar()
        
        noteTXT.backgroundColor = .systemBrown
        colorWell.backgroundColor = .systemBlue
        noteTXT.addSubview(colorWell)
        
        
        colorWell.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        colorWell.frame = CGRect(x: 20,
                                 y: 0,
                                 width: view.frame.size.width-40,
                                 height: 50)
        
    }

    @objc private func colorChanged(){
        noteTXT.backgroundColor = colorWell.selectedColor
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
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
        
        if noteTXT.isFocused {
            noteTXT.endEditing(true)
        } else {
            
            self.view.endEditing(true)
        }
    }

    @IBAction func saveBTN(_ sender: UIButton) {
        
        print("speichern")
        
        // Neuen Kontakt erzeugen
        let newNotiz = Notiz(context: self.context)
        newNotiz.text = noteTXT.text
        newNotiz.title = titleTXT.text
       

        newNotiz.date = Date()
//        newNotiz.color = colorChanged()
        newNotiz.color = colorWell.selectedColor
   
        
        // Save context
        do {
            try self.context.save()
        } catch {
            print("Error; context saving")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
