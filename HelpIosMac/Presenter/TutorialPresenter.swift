//
//  TutorialPresenter.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 14/04/20.
//  Copyright © 2020 Rinver. All rights reserved.
//

import UIKit
import Firebase

class TutorialPresenter {
    
    var view:TutorialProtocol!
    
    func attatchView(view: TutorialProtocol) {
        self.view = view
    }
    
    func loadTutorialsFromFireBase() {
        
        FireBase.getDataFireStore { listTutorial, erro in
        
            self.view.onError(error: erro)
            self.view.onSuccess(tutorials: listTutorial)
        }
    }
    
}
