//
//  Tutorial.swift
//  HelpIosMac
//
//  Created by Victor on 29/08/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit

class Tutorial: NSObject {

    let id: String
    let name: String
    let details: String
    let pathImage: String
    let makeTutorial: String
    let imagesUrl: Array<String>
    let linkVideo: String
    var images: [NSObject]
    var imgData: [UIImage] = []
    var created_at: Date

    
    init(id: String, name: String, details: String, pathImage: String = "", makeTutorial: String = "", imagesUrl: Array<String> = [], linkVideo: String = "", images: [NSObject] = [], imgData: [UIImage] = [], created_at: Date){
        self.id = id
        self.name = name
        self.details = details
        self.pathImage = pathImage
        self.makeTutorial = makeTutorial
        self.imagesUrl = imagesUrl
        self.linkVideo = linkVideo
        self.images = images
        self.imgData = imgData
        self.created_at = created_at
    }
    
    
    
       static func organizaTexto (_ details: String) -> String{
            var retornaQuebra = details
            var cont: Int = 0
            for item in retornaQuebra {
                
                switch item {
                case "2":
                    //cont += 1
                    retornaQuebra.insert("\n", at: retornaQuebra.index(retornaQuebra.startIndex, offsetBy: cont))
                    retornaQuebra.insert("\n", at: retornaQuebra.index(retornaQuebra.startIndex, offsetBy: cont))
                case "3":
                    cont += 1
                    retornaQuebra.insert("\n", at: retornaQuebra.index(retornaQuebra.startIndex, offsetBy: cont))
                    retornaQuebra.insert("\n", at: retornaQuebra.index(retornaQuebra.startIndex, offsetBy: cont))
                case "4":
                    cont += 2
                    retornaQuebra.insert("\n", at: retornaQuebra.index(retornaQuebra.startIndex, offsetBy: cont))
                    retornaQuebra.insert("\n", at: retornaQuebra.index(retornaQuebra.startIndex, offsetBy: cont))
                case "5":
                    cont += 3
                    retornaQuebra.insert("\n", at: retornaQuebra.index(retornaQuebra.startIndex, offsetBy: cont))
                    retornaQuebra.insert("\n", at: retornaQuebra.index(retornaQuebra.startIndex, offsetBy: cont))
                case "6":
                    cont += 4
                    retornaQuebra.insert("\n", at: retornaQuebra.index(retornaQuebra.startIndex, offsetBy: cont))
                    retornaQuebra.insert("\n", at: retornaQuebra.index(retornaQuebra.startIndex, offsetBy: cont))
                case "7":
                    cont += 5
                    retornaQuebra.insert("\n", at: retornaQuebra.index(retornaQuebra.startIndex, offsetBy: cont))
                    retornaQuebra.insert("\n", at: retornaQuebra.index(retornaQuebra.startIndex, offsetBy: cont))
                default:
                    break
                }
                
                cont += 1
            }

            return retornaQuebra
        }
}
