//
//  ViewController.swift
//  HelpIosMac
//
//  Created by Victor on 28/08/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

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
    var tutorialsList: Array<Tutorials> = []
    var listaImages: Array<UIImage> = []
    var listaParaImagens: Array<Tutorial> = []
    
    var listImagesArray: [UIImage] = []

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetail"){
            detalheController = (segue.destination as? DetailsViewController)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        
        loadingSpinner?.startAnimating()
        
        configLayoutSearch()
        setUpSerachBar()
        collectionViewTutorial.keyboardDismissMode = .onDrag
        
        collectionViewTutorial.dataSource = self
        collectionViewTutorial.delegate = self
        
         setupDadosFirebase { listaTutorials in
            for listaTutorial in listaTutorials {
               // print(listaTutorial.details)
                self.currentList.append(listaTutorial)
                self.contentList.append(listaTutorial)
                self.listaParaImagens.append(listaTutorial)
                self.collectionViewTutorial.reloadData()
                self.loadingSpinner?.stopAnimating()

             //   print("contagem de namesofimage: \(listaTutorials.count)")
                
            }
        }

    }
    
    func configLayoutSearch(){
        searchTutorial.layer.cornerRadius = 6.0
        searchTutorial.layer.masksToBounds = true
    }
    
    func activityIndicator(){
        loadingSpinner?.hidesWhenStopped = true
    }

    func recebeDadosFirebase(_ tutorial: Tutorial){
        var listaTutorial: Array<Tutorial> = []
        listaTutorial.append(tutorial)
      //  print("contagem\(listaTutorial.count)")
    }

    func setupDadosFirebase(_ callback:@escaping(_ listaTutorial: Array<Tutorial> ) -> () ){
        FireBase().getDadosFirebase({ (listaTutorial) in
            callback(listaTutorial)
        })
        
        
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
        let tutorial = currentList[indexPath.row]
        cell.configCollectionCell(tutorial)
        
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tutorial = currentList[indexPath.item]
        detalheController.tutorialDetail = tutorial
        
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

