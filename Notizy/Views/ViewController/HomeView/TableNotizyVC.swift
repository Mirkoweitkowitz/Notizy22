//
//  TableNotizyViewController.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 09.09.22.
//

import UIKit
import VisionKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class TableNotizyVC: UIViewController {
    
    @IBOutlet weak var homeView: UIView!
    
    
    @IBOutlet weak var imageHome: UIImageView!
    
    
    @IBOutlet weak var notes: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeView.layer.cornerRadius = 15
        homeView.layer.shadowColor = UIColor.green.cgColor
        homeView.layer.shadowOffset = .zero
        homeView.layer.shadowOpacity = 0.5
        homeView.layer.shadowRadius = 20
       
        
//        HomeImage einstellung
        
        imageHome.layer.cornerRadius = 15
        imageHome.layer.borderWidth = 3
        imageHome.layer.borderColor = UIColor.green.cgColor

       
        notes.layer.shadowColor = UIColor.green.cgColor
        notes.layer.shadowOffset = .zero
        notes.layer.shadowOpacity = 0.5
        notes.layer.shadowRadius = 20
        notes.imageView?.layer.cornerRadius = 30
       
        NotificationCenter.default.addObserver(self, selector: #selector(newImageUser(_ :)), name: NSNotification.Name.init("de.Notizy.UserImageView.userImage"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            let ref = Storage.storage().reference(forURL: "gs://notizy-7ec84.appspot.com/userimages/\(user.uid).png")
            
            
            ref.getData(maxSize: 1 * 5000 * 5000) { result in
              switch result {
              case let .success(data):
                  print("#" + data.description)
                  DispatchQueue.main.async {
                      self.imageHome.image = UIImage(data: data)
                  }
                 
              case let .failure(error):
                print("Error: Image could not download! \(error)")
              }
            }
        }
        
    }
    
//    MARK: Um den Speicher zu entlasten
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("de.Notizy.UserImageView.userImage"), object: nil)
    }
    
    
    @IBAction func touchUpInsideCameraButton(_ sender: Any) {
        
        configureDocumentView()
    }
    
    private func configureDocumentView(){
        let scanningDocumentVC = VNDocumentCameraViewController()
        scanningDocumentVC.delegate = self
        self.present(scanningDocumentVC, animated: true, completion: nil)
    }
    
    @objc func newImageUser(_ notification: NSNotification){
        
        if let user = notification.object as? Data {
            imageHome.image = UIImage(data: user)
        }else {
            return
        }
        
    }
    
}

extension TableNotizyVC:VNDocumentCameraViewControllerDelegate{
    
    func documentCameraViewController(_ controller:VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan){
        
        for pageNumber in 0..<scan.pageCount{
            let image = scan.imageOfPage(at:pageNumber)
            print(image)
            
            
            
            // Referenz zum Storage
            let storageRef = Storage.storage().reference()
            
            // Bild in Data umwandeln
            guard let imageData = image.pngData() else { return }
            
            //guard let imageDataJpeg = imgView.image?.jpegData(compressionQuality: 1.0) else { return }
            
            // File Path festlegen
            //let path = "images/\(nameThisImgTF.text!).png"
            
            let path = "images/\(UUID().uuidString).png"
            let fileRef = storageRef.child(path)
            
            // Daten hochladen
            _ = fileRef.putData(imageData) { metadata, error in
                            if error == nil {
                                print("test dragon")

                    let db = Firestore.firestore()
                    db.collection("images").document().setData([
                        "url": path
                    
                    ])
                            }else {
                                print(error!)
                            }
                
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
        
    }
    
}

