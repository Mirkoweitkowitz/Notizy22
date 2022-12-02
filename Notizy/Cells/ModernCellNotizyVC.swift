//
//  ModernCellNotizyVC.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 18.10.22.
//

import UIKit

class ModernCellNotizyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CustomTVC.self,forCellReuseIdentifier: CustomTVC.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTVC.identifier, for: indexPath) as? CustomTVC ?? UITableViewCell()
        
    
        return cell
        
    }
    
}
