//
//  FontSizeView.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 21.11.22.
//

import SwiftUI


struct FontSizeView: View {
@ObservedObject var settings = UserSettings()
var body: some View {
    List {
        if $settings.useSystemFontSize.wrappedValue {
            Section {
                HStack {
                    Spacer()
                    Text("An app that can digitize everything.")
                        .frame(height:88.0)
                    Spacer()
                }
            }
        } else {
            Section {
                HStack {
                    Spacer()
                    Text("An app that can digitize everything")
                        .font(.system(size: CGFloat($settings.fontSize.wrappedValue)))
                        .frame(height:88.0)
                    Spacer()
                }
            }
            Section {
                Stepper("\(Int($settings.fontSize.wrappedValue)) pt", value: $settings.fontSize, in: 9...64)
            }
        }
        Section {
            Toggle(isOn: $settings.useSystemFontSize) {
                Text("Use System Size")
            }
        }
    }
    .listStyle(GroupedListStyle())
}
}

struct FontSizeView_Previews: PreviewProvider {
    static var previews: some View {
        FontSizeView()
    }
}
