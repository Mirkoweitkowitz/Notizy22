//
//  CustomTVC.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 18.10.22.
//

import UIKit

class CustomTVC: UITableViewCell {

 static let identifier = "CustomTVC"
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        
        var configuration = defaultContentConfiguration().updated(for: state)

        configuration.text = "Hallo Tutoren von Syntax"
        configuration.image = UIImage(systemName: "bell")
        configuration.textProperties.color = .orange
        configuration.imageProperties.tintColor = .green

        var configbackground = backgroundConfiguration?.updated(for: state)
        
        configbackground?.backgroundColor = .darkGray
        
//         min.1 muss wahr sein
        
        if state.isHighlighted || state.isSelected {
            
            configuration.textProperties.color = .darkText
            configuration.imageProperties.tintColor = .red
            configbackground?.backgroundColor = .green
            
            
        }
        
        contentConfiguration = configuration
        backgroundConfiguration = configbackground
    }
    

}
