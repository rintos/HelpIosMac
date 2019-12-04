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
            
            let tutorial = Tutorial(name: dadosTitle, details: dadosDetail, pathImage: dadosPathImage, imagesUrl: dadosImagesUrl, linkVideo: dadosLinkVideo)
            lista.append(tutorial)
            completion(lista)

            }
        })
        
    }

    
    func getImage(_ completion:@escaping(_ image: UIImage) -> Void){
        var storage = Storage.storage()
        storage = Storage.storage(url: "gs://helpiosmac.appspot.com")
        let storageReference = storage.reference()
       // let imagesReference = storageReference.child("images")
        let spaceReference = storageReference.child("images/img2.jpg")
     //   let storagePath = "\(storage)/images/img10.jpg"
        
        spaceReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
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
