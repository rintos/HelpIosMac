//
//  ViewController.swift
//  HelpIosMac
//
//  Created by Victor on 28/08/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    
    
    var contentList: Array<Tutorial> = TutorialDAO().returnListTutorial()
    
    @IBOutlet weak var collectionViewTutorial:UICollectionView!
    
    var listFavorite: Array<Tutorial> = []
    var detalheController = DetailsViewController()
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetail"){
            detalheController = (segue.destination as? DetailsViewController)!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewTutorial.dataSource = self
        collectionViewTutorial.delegate = self
        
    }
    
    func addTutorial(_ tutorial: Tutorial) {
        listFavorite.append(tutorial)
        collectionViewTutorial.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TutorialCollectionViewCell
        let tutorial = contentList[indexPath.item]
        cell.tituloLabel.text = tutorial.name
        cell.descricaoTextView.text = tutorial.details
        cell.imagemTutorial.image = UIImage(named: tutorial.pathImage)
        cell.layer.borderWidth = 3
        
//        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(showTutorial))
//        cell.addGestureRecognizer(recognizer)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tutorial = contentList[indexPath.item]
        print(tutorial.details)
        
        detalheController.titleDetail = tutorial.name
        detalheController.descriptionDetail = tutorial.details
        
//        let controllerDetalhes = DetailsViewController()
//        if let navigation = navigationController {
//            controllerDetalhes.titleDetail = tutorial.name
//            controllerDetalhes.descriptionDetail = tutorial.details
//            navigation.pushViewController(controllerDetalhes, animated: true)
//
//        }
        
    }
    
    @objc func showTutorial( recognizer: UILongPressGestureRecognizer){
        if(recognizer.state == UIGestureRecognizer.State.began){
            let cell = recognizer.view as! TutorialCollectionViewCell
            if let indexPath = collectionViewTutorial.indexPath(for: cell){
                let row = indexPath.item
                let tutorial = contentList[row]
                
                let detailsController = DetailsViewController()
                if let navigation = navigationController{
                    detailsController.titleDetail = tutorial.name
                    detailsController.descriptionDetail = tutorial.details
                    navigation.pushViewController(detailsController, animated: true)
                }
                
                print(tutorial.name)
            }
        }
    }
    
    //            if let indexPath = tableView.indexPath(for: cell){
    /*
     let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(showDetails))
     cell.addGestureRecognizer(recognizer)
     
     */

    
}

