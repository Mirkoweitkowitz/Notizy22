//
//  NotizyVC.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 04.10.22.
//

import UIKit

import AVFoundation

class NotizyVC: UIViewController {
    

    
    @IBAction func donehauptseite(_ sender: Any) {
        if let tabbar = (self.storyboard!.instantiateViewController(withIdentifier: "homeTabBar") as? UITabBarController
            ) {
              self.present(tabbar, animated: true, completion: nil)
            }else{
              print("Something went wrong")
            }
        
        
    }
    
   
    
    private let table: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        
        return table
    }()
    
    private var models = [CellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        setUpModels()
        view.addSubview(table)
        
//        TODO: - tableHeaderView
        table.tableHeaderView = createTableHeader()
        
        table.delegate = self
        table.dataSource = self
        
    }
    
   
    
//    MARK: - Video im Header einbetten
    
    private func createTableHeader() -> UIView? {
        guard let path = Bundle.main.path(forResource: "skizzen",
                                          ofType: "mp4") else {
            return nil
        }

        let url = URL(fileURLWithPath: path)

        let player = AVPlayer(url: url)
        player.volume = 0

        let headerView = UIView(frame:CGRect(x: 0,
                                             y: 0,
                                             width: view.frame.size.width,
                                             height: 180))

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = headerView.bounds
        headerView.layer.addSublayer(playerLayer)

        playerLayer.videoGravity = .resizeAspectFill
        player.play()

        return headerView
    }
    
    private func setUpModels() {
        models.append(.collectionView(models: [CollectionTableCellModel(title: "car1", imageName: "car1"),
                                               
                                               CollectionTableCellModel(title: "car2", imageName: "car2"),
                                               CollectionTableCellModel(title: "car3", imageName: "car3"),
                                               CollectionTableCellModel(title: "car4", imageName: "car4"),
                                               CollectionTableCellModel(title: "car5", imageName: "car5"),
                                               CollectionTableCellModel(title: "car6", imageName: "car6"),
                                               CollectionTableCellModel(title: "car7", imageName: "car7"),
                                               
                                              ], rows: 2))
        
        models.append(.list(models: [
            ListCellModel(title: "First Thing"),
            ListCellModel(title: "Second Thing"),
            ListCellModel(title: "Another Thing"),
            ListCellModel(title: "Other Thing"),
            ListCellModel(title: "More Thing"),
        
        ]))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
}

extension NotizyVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch models[section] {
        case .list(let models): return models.count
        case .collectionView(_, _): return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch models[indexPath.section] {
        case .list(let models):
            let model = models[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath)
            cell.textLabel?.text = model.title
            
            return cell
            
        case .collectionView(let models, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as! CollectionTableViewCell
            
            cell.configure(with: models)
            cell.delegate = self
            return cell
        }
        
      
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Did selected normal list item")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch models[indexPath.section] {
        case .list(_): return 50
        case .collectionView(_, let rows): return 180 * CGFloat(rows)
        }
    }
}


extension NotizyVC: CollectionTableViewCellDelegate {
    func didSelectItem(with model: CollectionTableCellModel) {
        print("Selected \(model.title)")
    }
}
