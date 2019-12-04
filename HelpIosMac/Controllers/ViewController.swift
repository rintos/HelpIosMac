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
        
    @IBOutlet weak var collectionViewTutorial:UICollectionView!
    
    @IBOutlet weak var searchTutorial: UISearchBar!
    
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView?
    
    //MARK: Variavel
    
    var listFavorite: Array<Tutorial> = []
    var detalheController = DetailsViewController()
    var contentList: Array<Tutorial> = TutorialDAO().returnListTutorial()
    var currentList: Array<Tutorial> = TutorialDAO().returnListTutorial()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetail"){
            detalheController = (segue.destination as? DetailsViewController)!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        
        loadingSpinner?.startAnimating()
        
        setUpSerachBar()
        collectionViewTutorial.keyboardDismissMode = .onDrag
        
        collectionViewTutorial.dataSource = self
        collectionViewTutorial.delegate = self
        
         setupDadosFirebase { listaTutorials in
            for listaTutorial in listaTutorials {
               // print(listaTutorial.details)
                self.currentList.append(listaTutorial)
                self.contentList.append(listaTutorial)
                self.collectionViewTutorial.reloadData()
                self.loadingSpinner?.stopAnimating()
            }
        }
    }
    
    func activityIndicator(){
        loadingSpinner?.hidesWhenStopped = true
    }

    func recebeDadosFirebase(_ tutorial: Tutorial){
        var listaTutorial: Array<Tutorial> = []
        listaTutorial.append(tutorial)
      //  print("contagem\(listaTutorial.count)")
    }

    func setupDadosFirebase(_ callback:@escaping(_ listaTutorial: Array<Tutorial> ) -> Void){
        FireBase().getDadosFirebase { (listaTutorial) in
            callback(listaTutorial)
        }
    }
    
    func setupImage(_ fileName: String, completion:@escaping(_ image:UIImage) -> Void){
        FireBase().getImage(fileName: fileName, completion: { (image) in
            completion(image)
        }) { (error) in
            print(error)
        }
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
            setupImage(pathArrayImage) { (image) in
                cell.imagemTutorial.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tutorial = currentList[indexPath.item]
        detalheController.tutorialDetail = tutorial
    }
    
    @objc func showTutorial( recognizer: UILongPressGestureRecognizer){
        if(recognizer.state == UIGestureRecognizer.State.began){
            let cell = recognizer.view as! TutorialCollectionViewCell
            if let indexPath = collectionViewTutorial.indexPath(for: cell){
                let row = indexPath.item
                let tutorial = currentList[row]
                
                let detailsController = DetailsViewController()
                if let navigation = navigationController{
                    detailsController.tutorialDetail = tutorial
                    navigation.pushViewController(detailsController, animated: true)
                }
                
              //  print(tutorial.name)
            }
        }
    }

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

