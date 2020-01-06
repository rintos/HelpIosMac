//
//  ImageController.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 17/12/19.
//  Copyright © 2019 Rinver. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func getCurrentTime() -> Int {
        let date = Int64(self.timeIntervalSince1970 * 1000)
        
        return Int(date)
    }
    
}

class ImageController {
    static let shared = ImageController()
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    func saveImage(image: UIImage, imageName:String ) {
    
        if let imageData = image.jpegData(compressionQuality: 0.8){
            do {
                let filePath = documentsPath.appendingPathComponent(imageName)
                
                try imageData.write(to: filePath)
                print("\(imageName) Foi salva com sucesso!!!!!!")
                
            } catch let error as NSError {
                print("\(imageName) nao pode ser salva devido ao erro\(error.localizedDescription)")
            }
        } else {
            print("Nao foi possivel converter a imagem")
        }

    }
    
    func fetchImage(imageName: String) -> UIImage? {
        let imagePath = documentsPath.appendingPathComponent(imageName).path
        
        guard fileManager.fileExists(atPath: imagePath) else {
            print("Imagem nao existe no caminho: \(imagePath)")
            
            return nil
        }
        
        if let imageData = UIImage(contentsOfFile: imagePath) {
            print("Retornado a imagem com sucesso!!!")
            return imageData
        } else {
            print("UIImage nao pode ser criada!!!")
            
            return nil
        }
    }
    
    func fetchImageArray(imageName: String) -> UIImage? {
        let imagePath = documentsPath.appendingPathComponent(imageName).path
        
        guard fileManager.fileExists(atPath: imagePath) else {
            print("Imagem nao existe no caminho: \(imagePath)")
            
            return nil
        }
        
        if let imageData = UIImage(contentsOfFile: imagePath) {
            print("Retornado a imagem com sucesso!!!")
            return imageData
        } else {
            print("UIImage nao pode ser criada!!!")
            
            return nil
        }
    }
    
    func deleteImage(imageName: String) {
        let imagePath = documentsPath.appendingPathComponent(imageName)
        
        guard fileManager.fileExists(atPath: imagePath.path) else {
            print("Imagem nao existe no caminho:\(imagePath)")
            
            return
        }
        
        do {
            try fileManager.removeItem(at: imagePath)
        } catch let error as NSError {
            print("Nao pode ser deletado a imagem: \(imageName): gerou erro: \(error)")
        }
    }
    
    func deleteImagesShare(_ namesOfImages: Array<String>){
        
        for names in namesOfImages {
            ImageController().deleteImage(imageName: names)
            print("imagem deletada\(names)")
        }
    }
        
    func saveImageReturnName(image: UIImage, imageName:String, completion:@escaping(_ names: String) -> ()) {
        
      //  let date = String(Date.timeIntervalSinceReferenceDate)
      //  let name = date.replacingOccurrences(of: ".", with: "-") + imageName
        let date = Date().getCurrentTime()
        let dateConverted: String = String(date)
        
        let name = dateConverted
        
        if let imageData = image.jpegData(compressionQuality: 0.8){
            do {
                let filePath = documentsPath.appendingPathComponent(name)
                
                try imageData.write(to: filePath)
                print("\(name) Foi salva com sucesso!!!!!!")
                
                 completion(name)
            } catch let error as NSError {
                print("\(name) nao pode ser salva devido ao erro\(error.localizedDescription)")
            }
        } else {
            print("Nao foi possivel converter a imagem")
        }

    }


}
