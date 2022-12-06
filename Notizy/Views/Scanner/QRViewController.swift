//
//  QRViewController.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 06.12.22.
//


import UIKit

class QRViewController: UIViewController {

    
    @IBOutlet weak var imagenQRVisualizar: UIImageView!
    @IBOutlet weak var textoGenerar: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textoGenerar.delegate = self
        
        imagenQRVisualizar.image = generateQRCode(from: "https://github.com/marcoalonso")
    }
    
    //MARK: Functions
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 4, y: 4)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Actions
    
    @IBAction func generarButton(_ sender: UIBarButtonItem) {
        
        imagenQRVisualizar.image = generateQRCode(from: textoGenerar.text ?? "Hallo")
        textoGenerar.text = ""
        textoGenerar.endEditing(true)
    }
    
}

extension QRViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textoGenerar.text = ""
        imagenQRVisualizar.image = nil
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
