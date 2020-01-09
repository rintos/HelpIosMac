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

    
    init(id: String, name: String, details: String, pathImage: String = "", makeTutorial: String = "", imagesUrl: Array<String> = [], linkVideo: String = "", images: [NSObject] = [], imgData: [UIImage] = []){
        self.id = id
        self.name = name
        self.details = details
        self.pathImage = pathImage
        self.makeTutorial = makeTutorial
        self.imagesUrl = imagesUrl
        self.linkVideo = linkVideo
        self.images = images
        self.imgData = imgData
    }
    
    
}
