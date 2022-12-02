//
//  SwiftUIViewtest.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 04.11.22.
//

import SwiftUI
//import UIKit


struct SwiftUIViewtest: View {
    
    @State private var selectedColor: Color = .blue
    
    var body: some View {
        
        VStack {
           
            MyColorPicker(selectedColor: $selectedColor);      Spacer()
            
            Circle()
                .frame(width: 100, height: 100)
                .cornerRadius(20)
                .foregroundColor(selectedColor)
            Text("\(selectedColor.description)")
                .font(.system(size: 40, design: .rounded))
            
            Spacer()
            

            
            
            
        }.background(Image("notizy.img")
            .resizable()
            .aspectRatio(UIImage(named: "notizy.img")!.size, contentMode: .fill)
            .clipped())
        .edgesIgnoringSafeArea(.all)
    }
}








struct SwiftUIViewtest_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIViewtest()
    }
}
