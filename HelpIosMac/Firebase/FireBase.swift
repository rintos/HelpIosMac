//
//  FireBase.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 25/11/19.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import Firebase

class FireBase: NSObject {
    
    var referenceFirebase: DatabaseReference?
    var textDatabaseHandler: DatabaseHandle?
    var fireBaseReferente: DatabaseReference!
    var database: Database!
    var storage: Storage!
    var imageURL: Array<String> = []
    
    
    func getDadosFirebase(_ completion:@escaping(_ listaTutorial: Array<Tutorial>) -> Void ) {
        referenceFirebase = Database.database().reference()

        textDatabaseHandler = referenceFirebase?.child("tutorials").observe(DataEventType.value, with: { dataSnapshot in
        for dados in dataSnapshot.children.allObjects as! [DataSnapshot]{
            var lista: Array<Tutorial> = []
            let dadosTutorial = dados.value as? [String: AnyObject]
            guard let dadosTitle = dadosTutorial?["name"] as? String else { return }
            guard let dadosDetail = dadosTutorial?["details"] as? String else { return }
            guard let dadosImagesUrl = dadosTutorial?["imagesUrl"] as? [String] else { return }
            guard let dadosLinkVideo = dadosTutorial?["linkVideo"] as? String else { return }
            guard let dadosPathImage = dadosTutorial?["pathImage"] as? String else { return }
            
            self.imageURL = dadosImagesUrl
            
            let tutorial = Tutorial(name: dadosTitle, details: dadosDetail, pathImage: dadosPathImage, imagesUrl: dadosImagesUrl, linkVideo: dadosLinkVideo)
            lista.append(tutorial)
            completion(lista)
           // print("caminho gerado:\(self.imageURL)")
            }
        })
        
    }

    
    func getImage(_ folderPath: String = "images", fileName: String, completion:@escaping(_ image: UIImage) ->(), failure:@escaping(_ error: Error) -> () ){
        
        let reference = Storage.storage().reference(withPath: "\(folderPath)/\(fileName)")

        reference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error)
            }else {
                if let imageData =  data {
                    let image = UIImage(data: imageData )
                    completion(image!)
                }
            }
        }
    }
    

}
