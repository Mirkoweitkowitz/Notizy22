//
//  CollectionViewTaskVC.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 09.09.22.
//

import UIKit
import SwiftUI
import CoreData

// MARK: Swift mit SwiftUI kombiniert
class CollectionViewTaskVC: UIHostingController <FlipCardView> {
    
    required init?(coder:NSCoder) {
        super.init(coder: coder, rootView: FlipCardView())
    }
    
}



struct FlipEffect: GeometryEffect {
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
// Layout der Karte
struct Card:View {
    var name:String = ""
    var adresse:String = ""
    var email: String = ""
    var notes: String = ""
    var image: Data?
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.pink]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width:330, height: 200)
        
        
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
    }
    
}
// Visitenkarten inhalt
struct BusinessCard: View {
    @State var flipped: Bool = false
    @State var flip: Bool = false
    @State var adresse: String?
    @State var name: String?
    @State var email: String?
    @State var notes: String?
    @State var image: Data?
    
    var body: some View {
        
        ZStack {
            Card(adresse: adresse ?? "", email: email ?? "",
                 notes: notes ?? "")
            .opacity(flipped ? 0 : 1)
            Card(name: name ?? "", image: image)
                .opacity(flipped ? 1 : 0)
            
        }
        .modifier(FlipEffect(flipped: $flipped, angle: flip ? 0 : 180))
        .onTapGesture(count: 1, perform: {
            withAnimation {
                flip.toggle()
            }
        })
        
    }
    
}


struct ContentView: View {
    @State var flipped: Bool = false
    @State var flip: Bool = false
    let names = ["Thor", "Ted", "Josh", "Mirko"]
    @State private var searchText = ""
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors:
                    [NSSortDescriptor(keyPath: \Contact.name, ascending: true)])
    var contacts: FetchedResults<Contact>
    

    var body: some View {
                    VStack {
                Text("")
                    .searchable(text: $searchText)
                //                .navigationTitle("Searchable Example")
                
                
                ZStack {
                    // MARK: - Scrollbare VisitenKarte
                    
                    List {
                        // neuen Kontakte aus CoreData
                        ForEach(contacts) {contact in
                            Section {
                                BusinessCard(flipped: false, flip: false, adresse: contact.adress,
                                             name: contact.name,
                                             email: contact.email,
                                             notes:  contact.notes,
                                             image: contact.image)
                                
                                
                                
                            }.listRowBackground(Color.clear)
                                .shadow(color: .gray.opacity(0.8), radius:  20)
                        }
                    }.scrollContentBackground(.hidden)
                    
                    
                }.background(Image("notizy.img")
                    .resizable()
                    .aspectRatio(UIImage(named: "notizy.img")!.size, contentMode: .fill)
                    .clipped())
                .edgesIgnoringSafeArea(.all)
                
            }
        }
    }



// Referenz zum Core Data Persistent Store / managedObjectContext
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

// MARK: die Preview Daten erstellen
struct PreviewDataController {
    
    let previewContainer: NSPersistentContainer
    static var shared: PreviewDataController = {
        var controller = PreviewDataController()
        var context = controller.previewContainer.viewContext
        
        let contact = Contact (context: context)
        contact.name = "Syntax Institut"
        contact.adress = "Stresemannstr.123 - 10963 Berlin  "
        contact.email = "info@syntax-institut.de"
        contact.notes = "syntax institut"
        contact.image = UIImage(named: "syntax1")?.jpegData(compressionQuality: 1.0)
        do{
            try context.save()
        }catch {
            print(error)
        }
        return controller
    }()
    
    init() {
        previewContainer = NSPersistentContainer(name: "Notizy")
        previewContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        previewContainer.loadPersistentStores { description, error in
            if let error = error {
                print(error)
            }
        }
        previewContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
       
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()  .environment(\.managedObjectContext, PreviewDataController.shared.previewContainer.viewContext)
    }
}

struct FlipCardView: View {
    
    var body: some View {
        
        
        ContentView()
            .environment(\.managedObjectContext, context)
        
    }
    
}
