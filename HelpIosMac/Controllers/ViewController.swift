//
//  ViewController.swift
//  HelpIosMac
//
//  Created by Victor on 28/08/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate {

    
    
    var contentList: Array<Tutorial> = TutorialDAO().returnListTutorial()
    
    var currentList: Array<Tutorial> = TutorialDAO().returnListTutorial()
    
    @IBOutlet weak var collectionViewTutorial:UICollectionView!
    
    @IBOutlet weak var searchTutorial: UISearchBar!
    
    var listFavorite: Array<Tutorial> = []
    var detalheController = DetailsViewController()
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetail"){
            detalheController = (segue.destination as? DetailsViewController)!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSerachBar()
        collectionViewTutorial.keyboardDismissMode = .onDrag
        
        collectionViewTutorial.dataSource = self
        collectionViewTutorial.delegate = self
        
    }
    
    private func setUpSerachBar(){
        searchTutorial.delegate = self
    }
    
    func addTutorial(_ tutorial: Tutorial) {
        listFavorite.append(tutorial)
        collectionViewTutorial.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TutorialCollectionViewCell
        let tutorial = currentList[indexPath.item]
        cell.tituloLabel.text = tutorial.name
        cell.descricaoTextView.text = tutorial.details
      //  cell.imagemTutorial.image = UIImage(named: tutorial.pathImage)
        cell.layer.borderWidth = 3
        
        if let pathArrayImage = tutorial.imagesUrl.first {
            //print("Caminho da imagem pegando um item do array manualmente: \(String(describing: pathArrayImage))")
            cell.imagemTutorial.image = UIImage(named: pathArrayImage)

        }
        
//        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(showTutorial))
//        cell.addGestureRecognizer(recognizer)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tutorial = currentList[indexPath.item]
      //  print(tutorial.details)
        
        detalheController.titleDetail = tutorial.name
        detalheController.descriptionDetail = tutorial.details
        detalheController.tutorialDetail = tutorial
        detalheController.linkVideo = tutorial.linkVideo
        
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
                let tutorial = currentList[row]
                
                let detailsController = DetailsViewController()
                if let navigation = navigationController{
                    detailsController.titleDetail = tutorial.name
                    detailsController.descriptionDetail = tutorial.details
                    navigation.pushViewController(detailsController, animated: true)
                }
                
              //  print(tutorial.name)
            }
        }
    }
    
    //            if let indexPath = tableView.indexPath(for: cell){
    /*
     let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(showDetails))
     cell.addGestureRecognizer(recognizer)
     
     */

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentList = contentList
            collectionViewTutorial.reloadData()
            return
        }
        currentList = contentList.filter({ (conteudo) -> Bool in
            (conteudo.details.lowercased().contains(searchText.lowercased()))
        })
        collectionViewTutorial.reloadData()
    }
    
    
    
}

