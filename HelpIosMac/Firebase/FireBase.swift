//
//  FireBase.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 25/11/19.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class FireBase: NSObject {
    
//    var referenceFirebase: DatabaseReference?
//    var textDatabaseHandler: DatabaseHandle?
//    var fireBaseReferente: DatabaseReference!
//    var database: Database!
    var storage: Storage!
   // var imageURL: Array<String> = []
    //var images
    var allTasks: [StorageDownloadTask] = []
    var nameOfImages: Array<String> = []
    var listImage: [UIImage] = []
    var ImagensDeUmObjeto: [UIImage] = []

    static func getDataFireStore(_ completion:@escaping(_ listTutorial: Array<Tutorial>) -> ()){
        let db = Firestore.firestore()
        var imageURL: Array<String> = []
        var listTutorial: Array<Tutorial> = []
        
        db.collection("tutorials").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                 //   print("\(document.documentID) => Dados \(document.data())")
                    
                    let id = document.data()["id"] as? String ?? ""
                    let title = document.data()["name"] as? String  ?? ""
                    let detail = document.data()["details"] as? String ?? ""
                    let linkVideo = document.data()["linkVideo"] as? String ?? ""
                    let pathImage = document.data()["pathImage"] as? String ?? ""
                    let images = document.data()["imagesUrl"]
                    let image = images as? Array<String>  ?? []
                    imageURL = image
                    let timestamp: Timestamp = document.get("date") as! Timestamp
                    let date: Date = timestamp.dateValue()
                    
                    let tutorial = Tutorial(id: id, name: title, details: detail, pathImage: pathImage, imagesUrl: imageURL, linkVideo: linkVideo, images: [], imgData: [], created_at: date)
                    listTutorial.append(tutorial)
                }
              //  print("lista de tutorial em array: \(listTutorial)")
                completion(listTutorial)
            }
        }
    }
    
//    func getDadosFirebase(_ completion:@escaping(_ listaTutorial: Array<Tutorial>) -> ()) {
//        referenceFirebase = Database.database().reference()
//
//        textDatabaseHandler = referenceFirebase?.child("tutorials").observe(DataEventType.value, with: { dataSnapshot in
//        for dados in dataSnapshot.children.allObjects as! [DataSnapshot]{
//
//            var lista: Array<Tutorial> = []
//
//            let dadosTutorial = dados.value as? [String: AnyObject]
//            guard let id = dadosTutorial?["id"] as? String else { return }
//            guard let dadosTitle = dadosTutorial?["name"] as? String else { return }
//            guard let dadosDetail = dadosTutorial?["details"] as? String else { return }
//            guard let dadosImagesUrl = dadosTutorial?["imagesUrl"] as? [String] else { return }
//            guard let dadosLinkVideo = dadosTutorial?["linkVideo"] as? String else { return }
//            guard let dadosPathImage = dadosTutorial?["pathImage"] as? String else { return }
//
//            self.imageURL = dadosImagesUrl
//
//            let tutorial = Tutorial(id: id, name: dadosTitle, details: dadosDetail, pathImage: dadosPathImage, imagesUrl: dadosImagesUrl, linkVideo: dadosLinkVideo, images: [], imgData: [])
//            lista.append(tutorial)
//            completion(lista)
//            print("Conteudo gerado pelo firebase\(lista)")
//           // print("caminho gerado:\(self.imageURL)")
//
//
//
//            let folderPath:String = "images"
//
//            for nameOfImage in dadosImagesUrl {
//
//                let reference = Storage.storage().reference(withPath: "\(folderPath)/\(nameOfImage)")
//
//
//                reference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
//
//                         if let error = error {
//                             print(error)
//                         } else {
//                             if let imageData =  data {
//                                 guard let image = UIImage(data: imageData ) else { return }
//                                 self.listImage.append(image)
//
//                             }
//                         }
//                   //     callback(self.listImage)
//                     }
//                }
//
//            }
//        })
//
//    }
    
    static func getImage(_ imageName: String, callback:@escaping(_ image: UIImage) -> Void ){

     //   var images: Array<UIImage> = []
        
        let folderPath = "images"
        
        let reference = Storage.storage().reference(withPath: "\(folderPath)/\(imageName)")

        reference.getData(maxSize: 1 * 1024 * 1024) { (data, erro) in
            if erro != nil {
                if let error = erro {
                    print(error.localizedDescription)
                }
            } else {
                if let data = data {
                 //   images.append(UIImage(data: data)!)
                    if let imageData = UIImage(data: data) {
                        callback(imageData)
                    }
                }
            }
        }

    }
    
    static func getImageArray(_ namesList: Array<String>, callback:@escaping(_ image: UIImage, _ name: String) -> Void ){
        
        let folderPath = "images"
       // var imagesArray: Array<UIImage> = []
        var namesArray: Array<String> = []

        
        for imageName in namesList {
            
            let reference = Storage.storage().reference(withPath: "\(folderPath)/\(imageName)")
            
            reference.getData(maxSize: 1 * 1024 * 1024) { (data, erro) in
                if erro != nil {
                    if let error = erro {
                        print(error.localizedDescription)
                    }
                } else {
                    let name = imageName
                    if let data = data {
                    if let imageData = UIImage(data: data) {
                        callback(imageData,name)
                      //  imagesArray.append(imageData)
                        }
                    }
                }
              //  callback(imagesArray)
            }
        }
        

        
    }
    
    
//    func getImageToSave(_ folderPath: String = "images", listNameImage: Array<String> , completion:@escaping(_ listImage: [UIImage]) ->() , failure:@escaping(_ error: Error) -> (), tasks:@escaping(_ allTasks: [StorageDownloadTask] ) -> () ){
//
//        nameOfImages = listNameImage
//
//        for nameImage in nameOfImages {
//
//            let reference = Storage.storage().reference(withPath: "\(folderPath)/\(nameImage)")
//
//            let task = reference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
//
//                if let error = error {
//                    print(error)
//                } else {
//                    if let imageData =  data {
//                        guard let image = UIImage(data: imageData ) else { return }
//                        self.listImage.append(image)
//
//                    }
//                }
//                completion(self.listImage)
//            }
//
//
//            allTasks.append(task)
//
//        }
//
//
//        tasks(allTasks)
//
//       //       task.pause()
//    //        task.cancel()
//    //        task.resume()
//
//        }
//
//
//
//    func getImages(_ folderPath: String = "images", tutorial: Tutorial , completion:@escaping(_ listImage: [UIImage]) ->() ,_ callback:@escaping(_ tutorialPopulado: Array<Tutorial>) -> (), failure:@escaping(_ error: Error) -> (), tasks:@escaping(_ allTasks: [StorageDownloadTask] ) -> () ){
//
//        var images: [UIImage] = []
//        var lista: Array<Tutorial> = []
//
//
//        let dadoTutorial = tutorial
//
//
//        nameOfImages = dadoTutorial.imagesUrl
//
//        for nameImage in nameOfImages {
//
//            let reference = Storage.storage().reference(withPath: "\(folderPath)/\(nameImage)")
//
//            let task = reference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
//
//                if let error = error {
//                    print(error)
//                } else {
//                    if let imageData =  data {
//                        guard let image = UIImage(data: imageData ) else { return }
//                        images.append(image)
//                    let tutorial = Tutorial(name: dadoTutorial.name, details: dadoTutorial.details, pathImage: dadoTutorial.pathImage, imagesUrl: dadoTutorial.imagesUrl, linkVideo: dadoTutorial.linkVideo, images: [], imgData: images)
//                        lista.append(tutorial)
//
//
//                    }
//                }
//
//                completion(images)
//                callback(lista)
//            }
//
//
//            allTasks.append(task)
//
//        }
//
//
//
//
//        tasks(allTasks)
//
//       //       task.pause()
//    //        task.cancel()
//    //        task.resume()
//
//        }
    

}
