//
//  DetailCollectionView.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 21.11.22.
//

import UIKit
import CoreData

class DetailCollectionView: UIViewController {
    
    var currentNotiz: Notiz!
    
    @IBOutlet weak var notesDetail: UILabel!
    
    
    @IBOutlet weak var notesTXTView: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesDetail.text = currentNotiz.title
        notesDetail.sizeToFit()
        notesTXTView.text = currentNotiz.text
        notesTXTView.sizeToFit()
        
    }
    
    
    @IBAction func deletenote(_ sender: UIBarButtonItem) {
        self.context.delete(currentNotiz)
        do {
            try context.save()
        }catch{
            print("Verdammt nochmal")
        }
    }
    
}
