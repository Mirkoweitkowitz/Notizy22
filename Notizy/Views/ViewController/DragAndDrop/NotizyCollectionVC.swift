//
//  NotizyCollectionVCViewController.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 06.10.22.
//

import UIKit
import AVFoundation
import CoreData

protocol CollectionViewCellDelegate: AnyObject {
    func didSelectItem(with model: CollectionTableCellModel)
}
class NotizyCollectionVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
  
    
    @IBOutlet weak var collView: UICollectionView!
    
    
    var list: [Notiz]!
    
    // Referenz zum Core Data Persistent Store / managedObjectContext
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collView?.delegate = self
        collView?.dataSource = self
        //        backgroundColor einstellen
        
        collView?.backgroundColor = .clear
        
        //        MARK: test Code ausgeführt
//                for note in 1...25 {
//                    var newNote = Notiz(context: context)
//                    newNote.title = "note:\(note)"
//                    newNote.text = "Test"
//                    newNote.color = getRandomColor()
//               }
//
//                //Saving Data
//                do {
//                   try context.save()
//                } catch {
//                    print("Error by saving request")
//                }
        
    
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        
        collView?.addGestureRecognizer(gesture)
        
        fetchNotizen()
        
    }
    
    func getRandomColor() -> UIColor {
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 0.7)
    }
    var colors: [UIColor] = [
        .link,
        .systemGreen,
        .darkGray,
        .orange,
        .cyan,
        .black,
        .blue,
        .brown,
        .gray,
        .lightGray,
        .systemPink,
        .purple]
    

    
    // Fetch Contacts
    func fetchNotizen() {
        
        // Fetching Data
        do {
            self.list = try context.fetch(Notiz.fetchRequest())
            print("fetchNotizen")
            print(self.list!)
            
            
            DispatchQueue.main.async {
                self.collView.reloadData()
            }
        } catch {
            print("Error by trying fetch request")
        }
        
    }
    
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        guard let collectionView = collView else {
            return
        }
        
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
            
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collView.frame = view.bounds
    }
    
    
    //    MARK: collectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailCell", sender: list[indexPath.item])
        print("hallo du da")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "DetailCell") {
            
            let detailVC = segue.destination as! DetailCollectionView
            detailVC.currentNotiz = sender as? Notiz
          
        }
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NotizenCVC
        let currentnote = list[indexPath.row]
        cell.backgroundColor = currentnote.color as? UIColor
        cell.notiztitle.text = currentnote.title
        cell.cellCollView.text = currentnote.text
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/3.2,
                      height: view.frame.size.height/6.5)
    }
    
    //     Re-order
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = list.remove(at: sourceIndexPath.row)
        list.insert(item, at: destinationIndexPath.row)
        
    }
    
  
    
    
}
