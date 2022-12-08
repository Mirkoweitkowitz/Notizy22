//
//  NotizyView.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 08.12.22.
//
import UIKit
import SwiftUI
import CoreData
import Combine
import Contacts



// MARK: Swift mit SwiftUI kombiniert
class CollViewTaskVC: UIHostingController <FlipCardView> {
    
    required init?(coder:NSCoder) {
        super.init(coder: coder, rootView: FlipCardView())
    }
    
}


struct FlopEffect: GeometryEffect {
    var animatableData: Double {
        get{ angle }
        set { angle = newValue }
    }
    @Binding var flipped:Bool
    var angle:Double
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        DispatchQueue.main.async {
            flipped = angle >= 90 && angle < 270
        }
        let newAngle = flipped ? -180 + angle : angle
        
        let angleInRadians = CGFloat(Angle(degrees: newAngle).radians)
        
        var transform3d = CATransform3DIdentity
        transform3d.m34 = -1/max(size.width, size.height)
        transform3d = CATransform3DRotate(transform3d, angleInRadians, 0, 1, 0)
        transform3d = CATransform3DTranslate(transform3d, -size.width / 2, -size.height / 2, 0)
        
        let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width / 2, y: size.height / 2))
        
        return ProjectionTransform(transform3d).concatenating(affineTransform)
    }
    
    
}
struct NotizyView: View {
    var name:String = ""
    var adresse:String = ""
    var email: String = ""
    var notes: String = ""
    var image: Data?
    
    var body: some View {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width:350, height: 200)
            
            
                .shadow(color: Color("shadow"),radius: 10, x: 5, y: 5)
                .overlay(VStack (alignment:image != nil ? .center : .leading, spacing: 10) {
                    if image != nil {
                        Image(uiImage: UIImage(data: image!)!)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .shadow(color: .black, radius:  20)
                        
                    }
                    Text(name)
                        .font(.title2)
                        .foregroundColor(.white)
                    if adresse != "" {
                        Text(adresse)
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    if email != "" {
                        Text(email)
                            .font(.body)
                        .foregroundColor(.white)          }
                    if notes != ""{
                        Text(notes)
                            .font(.body)
                        .foregroundColor(.white)}
                }
                )
//                .background(Image("notizy.img")
//                    .resizable()
//                    .aspectRatio(UIImage(named: "notizy.img")!.size, contentMode: .fill)
//                    .clipped())
//                .edgesIgnoringSafeArea(.all)
        }
    }
    

        


struct NotizyView_Previews: PreviewProvider {
    static var previews: some View {
        NotizyView()
    }
}
