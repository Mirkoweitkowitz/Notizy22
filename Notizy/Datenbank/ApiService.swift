//
//  ApiService.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 07.12.22.
//

import Foundation
import UIKit

struct ApiService{
    
    
    
    //https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/APINotizen.json
    
    func getImages(completion: @escaping(ApiStart) -> Void) {
        
        //MARK: 1. URL formen
        let urlString = "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/APINotizen.json"
        let url = URL(string: urlString)
        
        guard url != nil else { return }
        
        //MARK: 2. URL Session
        let session = URLSession.shared
        
        //MARK: 3. DataTask erstellen
        let dataTask = session.dataTask(with: url!) { data, response, error in
            
            //             Error handling
            if error == nil && data != nil {
                
                // JSON Decoder
                let decoder = JSONDecoder()
                
                do {
                    
                    let newsFeed = try decoder.decode(ApiStart.self, from: data!)
                    //                                  print(newsFeed.articles?.randomElement()?.title)
                    completion(newsFeed)
                    
                } catch {
                    print("Error parsing JSON")
                }
                
            }
        }
        //
        //MARK: 4. API Call starten / fortsetzen
        dataTask.resume()
    }
    // MARK: Download Image
    func downloadImage(imageUrl: URL, completion: @escaping(UIImage) -> Void) {
        
        // Session
        let session = URLSession.shared
        
        // Download Task
        let downloadTask = session.downloadTask(with: imageUrl) { localURL, urlResponse, error in
            
            let image = UIImage(data: try! Data(contentsOf: localURL!))!
            completion(image)
        }
        
        downloadTask.resume()
    }
}

//
//[
//       {
//           "name": "gegenwart",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/gegenwart.jpg"
//       },
//       {
//           "name": "klassiker",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/klassiker.jpg"
//       },
//       {
//           "name": "klassische notizen 1",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/klassische_notizen_1.jpg"
//       },
//       {
//           "name": "klassische notizen 2",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/klassische_notizen_2.jpg"
//       },
//       {
//           "name": "klassische notizen 3",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/klassische_notizen_3.jpg"
//       },
//       {
//           "name": "klassische notizen 4",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/klassische_notizen_4.jpg"
//       },
//       {
//           "name": "klassische notizen 5",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/klassische_notizen_5.jpg"
//       },
//       {
//           "name": "notizen in stein 1",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/notizen_in_stein_1.jpg"
//       },
//       {
//           "name": "notizen in stein 2",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/notizen_in_stein_2.jpg"
//       },
//       {
//           "name": "notizen in stein 3",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/notizen_in_stein_3.jpg"
//       },
//       {
//           "name": "notizen in stein 4",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/notizen_in_stein_4.jpg"
//       },
//       {
//           "name": "zukunft der notizen 1",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/zukunft_der_notizen_1.jpg"
//       },
//       {
//           "name": "zukunft der notizen 2",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/zukunft_der_notizen_2.jpg"
//       },
//       {
//           "name": "zukunft der notizen 3",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/zukunft_der_notizen_3.jpg"
//       },
//       {
//           "name": "zukunft der notizen 4",
//               "imageUrl": "https://public.syntax-institut.de/apps/batch1/MirkoWeitkowitz/images/zukunft_der_notizen_4.jpg"
//       }
//]
