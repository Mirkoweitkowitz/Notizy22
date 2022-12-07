//
//  NotizyVC.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 04.10.22.
//

import UIKit

import AVFoundation

class NotizyVC: UIViewController {
    
    private let table: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        
        return table
    }()
    
    private var models = [CellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ApiService().getImages { results in
            
            self.setUpModels(result: results)
        }
        
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
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) {_ in
            player.seek(to: CMTime.zero)
            player.play()
        }
        
        return headerView
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    
    
    
    
    private func setUpModels(result:ApiStart) {
        models.append(.collectionView(models: [CollectionTableCellModel(title: result[14].name, imageName: "notizen in stein"),
                                               
                                               CollectionTableCellModel(title: result[13].name, imageName: "notizen in stein 2"),
                                               CollectionTableCellModel(title: result[12].name, imageName: "notizen in stein 4"),
                                               CollectionTableCellModel(title: result[11].name, imageName: "klassiker"),
                                               CollectionTableCellModel(title: result[10].name, imageName: "klassische notizen"),
                                               CollectionTableCellModel(title: result[9].name, imageName: "klassische notizen 1"),
                                               CollectionTableCellModel(title: result[8].name, imageName: "klassische notizen 2"),
                                               CollectionTableCellModel(title: result[7].name, imageName: "zukunft der notizen"),
                                               CollectionTableCellModel(title: result[6].name, imageName: "zukunft der notizen 1"),
                                               CollectionTableCellModel(title: result[5].name, imageName: "zukunft der notizen 2"),
                                               CollectionTableCellModel(title: result[4].name, imageName: "zukunft der notizen 3"),
                                               CollectionTableCellModel(title: result[3].name, imageName: "gegenwart"),
                                               CollectionTableCellModel(title: result[2].name, imageName: "gegenwart"),
                                               CollectionTableCellModel(title: result[1].name, imageName: "gegenwart"),
                                               CollectionTableCellModel(title: result[0].name, imageName: "gegenwart"),
                                              
                                              ], rows: 2))
        
        models.append(.list(models: [
            ListCellModel(title: "Notizen in Stein"),
            ListCellModel(title: "Klassiker"),
            ListCellModel(title: "Klassische Notizen"),
            ListCellModel(title: "Zukunft der Notizen"),
            ListCellModel(title: "Gegenwart"),
            
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
