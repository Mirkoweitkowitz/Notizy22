//
//  SettingsView.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 21.11.22.
//

import SwiftUI

struct SettingsView: View {
    var dismiss: (() -> Void)?
    
    @ObservedObject var settings = UserSettings()
    
    var body: some View {
        
        NavigationView {
            List {
                Section {
                    Toggle(isOn: $settings.switchValue) {
                        Text("Switch")
                    }
                    NavigationLink(destination: FontSizeView().navigationBarTitle("Font Size")) {
                        HStack {
                            Text("Font Size")
                        }
                    }
                }
                Section(header: Text("Background Color")) {
                    ForEach(settings.colors) {color in
                        ZStack {
                            HStack {
                                Text(color.name)
                                Spacer()
                                if self.$settings.colorId.wrappedValue == color.id {
                                    SwiftUI.Image(systemName:"checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            Button(action: {self.$settings.colorId.wrappedValue = color.id}) {
                                EmptyView()
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(trailing:Button(action: dismiss!
                                               ) {
                Text("Done").bold()
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

final class SettingsViewController: UIHostingController<SettingsView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: SettingsView())
        rootView.dismiss = dismiss
    }

    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}
