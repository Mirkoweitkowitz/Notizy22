//
//  Settings.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 21.11.22.
//

import Foundation
import Combine
import UIKit

final class UserSettings: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    
    @UserDefault("switch", defaultValue: false)
    var switchValue: Bool
    
    @UserDefault("useSystemFontSize", defaultValue: true)
    var useSystemFontSize: Bool
    
    @UserDefault("fontSize", defaultValue: 17.0)
    var fontSize: Double
    
    @UserDefault("backgroundColor", defaultValue: 0)
    var colorId: Int
    
    let colors = [ColorSetting(id: 0, name: "System Background", color: UIColor.systemBackground),ColorSetting(id: 1, name: "System Red", color: UIColor.systemRed),ColorSetting(id: 2, name: "System Green", color: UIColor.systemGreen),ColorSetting(id: 3, name: "System Yellow", color: UIColor.systemYellow),ColorSetting(id: 4, name: "System Indigo", color: UIColor.systemIndigo),ColorSetting(id: 5, name: "System Gray", color: UIColor.systemGray),ColorSetting(id: 6, name: "System Pink", color: UIColor.systemPink),ColorSetting(id: 7, name: "System Mint", color: UIColor.systemMint)]
    
    private var notificationSubscription: AnyCancellable?

    init() {
        notificationSubscription = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification).sink { _ in
            self.objectWillChange.send()
        }
    }
    
    
}

struct ColorSetting:Identifiable {
    var id: Int
    var name:String
    var color:UIColor
}
