//
//  ModelController.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 17/12/19.
//  Copyright © 2019 Rinver. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ModelController {
    static let shared = ModelController()
    let entityName = "Tutorials"
    
    var savedObjects = [NSManagedObject]()
    var images = [UIImage]()
    var managedContext: NSManagedObjectContext!
    
    
     init(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.persistentContainer.viewContext
        
        fetchImageObjects()
        
    }

    
    func fetchImageObjects() {
        let imageObjectRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            savedObjects = try managedContext.fetch(imageObjectRequest)
            
            images.removeAll()
            
            for imageObject in savedObjects {
                let savedImageObject = imageObject as! Tutorials
                
                guard savedImageObject.imageName != nil else { return }
                
                let storedImage = ImageController.shared.fetchImage(imageName: savedImageObject.imageName!)
                
                if let storedImage = storedImage {
                    images.append(storedImage)
                }
            }
        } catch let error as NSError {
            print("Could not return image objects: \(error)")
        }
    }
    
    
//    func saveImageObject(image: UIImage) {
//        let imageName = ImageController.shared.saveImage(image: image, imageName: <#String#>)
//        
//        if let imageName = imageName {
//            let coreDataEntity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)
//            let newImageEntity = NSManagedObject(entity: coreDataEntity!, insertInto: managedContext) as! Tutorials
//            
//            newImageEntity.imageName = imageName
//            
//            do {
//                try managedContext.save()
//                
//                images.append(image)
//                
//                print("\(imageName) was saved in new object.")
//            } catch let error as NSError {
//                print("Could not save new image object: \(error)")
//            }
//        }
//    }
    

    
    func deleteImageObject(imageIndex: Int) {
        guard images.indices.contains(imageIndex) && savedObjects.indices.contains(imageIndex) else { return }
        
        let imageObjectToDelete = savedObjects[imageIndex] as! Tutorials
        let imageName = imageObjectToDelete.imageName
        
        do {
            managedContext.delete(imageObjectToDelete)
            
            try managedContext.save()
            
            if let imageName = imageName {
                ImageController.shared.deleteImage(imageName: imageName)
            }
            
            savedObjects.remove(at: imageIndex)
            images.remove(at: imageIndex)
            
            print("Image object was deleted.")
        } catch let error as NSError {
            print("Could not delete image object: \(error)")
        }
    }
}
