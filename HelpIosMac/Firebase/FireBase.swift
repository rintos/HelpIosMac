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
            let tutorial = Tutorial(name: dadosTitle, details: dadosDetail, imagesUrl: dadosImagesUrl, linkVideo: dadosLinkVideo)
            lista.append(tutorial)
            completion(lista)

            }
        })
        
    }
    

}
