//
//  ViewController.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 21.11.22.
//

import UIKit

class ViewController: UIViewController {

    
    let settings = UserSettings()
    @IBOutlet weak var label: UILabel!
    
    let colorWell: UIColorWell = {
        let colorWell = UIColorWell()
        colorWell.supportsAlpha = true
        colorWell.selectedColor = .systemRed
        colorWell.title = "Settings"

        return colorWell
    }()

    override func viewDidLoad() {
        super.viewDidLoad()


        view.backgroundColor = .systemBrown
        colorWell.backgroundColor = .systemBlue
        view.addSubview(colorWell)


        colorWell.addTarget(self, action: #selector(colorChanged), for: .valueChanged)

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        colorWell.frame = CGRect(x: 20,
                                 y: view.safeAreaInsets.top,
                                 width: view.frame.size.width-40,
                                 height: 50)

    }

    @objc private func colorChanged(){
        view.backgroundColor = colorWell.selectedColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = settings.colors[settings.colorId].color
        label.text = "Switch: " + settings.switchValue.description
        if settings.useSystemFontSize {
            label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        } else {
            label.font = UIFont.systemFont(ofSize: CGFloat(settings.fontSize))
        }
    }
    

}
