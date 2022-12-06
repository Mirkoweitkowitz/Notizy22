//
//  NotizenGeschichteVC.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 29.11.22.
//

import UIKit

class NotizenGeschichteVC: UIViewController {

    
    @IBOutlet weak var inhaltview: UITextView!
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inhaltview.isEditable = false
        
    }

}
