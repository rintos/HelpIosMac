//
//  TutorialProtocol.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 14/04/20.
//  Copyright © 2020 Rinver. All rights reserved.
//

import UIKit

protocol TutorialProtocol {
    func onSuccess(tutorials: [Tutorial])
    func onError(error: Error?)
}

extension ViewController: TutorialProtocol {
    
    func onSuccess(tutorials: [Tutorial]) {
                
        for tutorial in tutorials {
                self.currentList.append(tutorial)
                self.contentList.append(tutorial)
                self.collectionViewTutorial.reloadData()
            }
            
            let sortedCurrentList = self.currentList.sorted { (date1, date2) -> Bool in
                date1.created_at > date2.created_at
            }
            
            let sortedContentList = self.contentList.sorted { (date1, date2) -> Bool in
                date1.created_at > date2.created_at
            }
            
            self.currentListTutorial = sortedCurrentList
            self.contentListTutorial = sortedContentList
        
        self.collectionViewTutorial.reloadData()
        
        self.hideProgressIndicator()
        self.refreshControl.endRefreshing()
    
    }
    
    func onError(error: Error?) {
        
        print("-------->\(String(describing: error?.localizedDescription))")
        self.refreshControl.endRefreshing()

    }
    
    
    
    
}
