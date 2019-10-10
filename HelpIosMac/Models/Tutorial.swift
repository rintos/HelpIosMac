//
//  Tutorial.swift
//  HelpIosMac
//
//  Created by Victor on 29/08/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import Foundation

class Tutorial: NSObject {

    let name: String
    let details: String
    let pathImage: String
    let makeTutorial: String
    
    init(name: String, details: String, pathImage: String = "", makeTutorial: String = ""){
        self.name = name
        self.details = details
        self.pathImage = pathImage
        self.makeTutorial = makeTutorial
        
    }
}
