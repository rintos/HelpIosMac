//
//  ViewController.swift
//  HelpIosMac
//
//  Created by Victor on 28/08/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate, UICollectionViewDelegateFlowLayout {
        
    @IBOutlet weak var collectionViewTutorial:UICollectionView!
    
    @IBOutlet weak var searchTutorial: UISearchBar!
    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView?
    
    @IBOutlet weak var resultadoEncontradoLabel: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    
    
    //MARK: Variavel
    
    var listFavorite: Array<Tutorial> = []
    var detalheController = DetailsViewController()
    var contentList: Array<Tutorial> = []
    var currentList: Array<Tutorial> = []
    var contentListTutorial: Array<Tutorial> = []
    var currentListTutorial: Array<Tutorial> = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetail"){
            detalheController = (segue.destination as? DetailsViewController)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  statusView.isHidden = true
        
        activityIndicator()
        loadingSpinner?.startAnimating()
        
        configLayoutSearch()
        setUpSerachBar()
        collectionViewTutorial.keyboardDismissMode = .onDrag
        
        collectionViewTutorial.dataSource = self
        collectionViewTutorial.delegate = self
        
        setupDataFireBase()
        
        resultadoEncontradoLabel.isHidden = true
        
//         setupDadosFirebase { listaTutorials in
//            for listaTutorial in listaTutorials {
//                print("lista dados viewController:\(listaTutorial.details)")
//                self.currentList.append(listaTutorial)
//                self.contentList.append(listaTutorial)
//                self.collectionViewTutorial.reloadData()
//                self.loadingSpinner?.stopAnimating()
//
//             //   print("contagem de namesofimage: \(listaTutorials.count)")
//
//            }
//        }


        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationItem.titleView?.backgroundColor = .blue
        self.navigationController?.navigationBar.topItem!.title = "Help Mac & iOS"

    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    // MARK: - Metodos
    
    func configLayoutSearch(){
        searchTutorial.layer.cornerRadius = 6.0
        searchTutorial.layer.masksToBounds = true
    }
    
    func activityIndicator(){
        loadingSpinner?.hidesWhenStopped = true
        statusView.isHidden = true
    }
    
    func setupDataFireBase(){
        
        FireBase.getDataFireStore { listTutorial in
            for tutorial in listTutorial {
                self.currentList.append(tutorial)
                self.contentList.append(tutorial)
                self.collectionViewTutorial.reloadData()
                self.loadingSpinner?.stopAnimating()
            }
            
            let sortedCurrentList = self.currentList.sorted { (date1, date2) -> Bool in
                date1.created_at > date2.created_at
            }
            
            let sortedContentList = self.contentList.sorted { (date1, date2) -> Bool in
                date1.created_at > date2.created_at
            }
            
            self.currentListTutorial = sortedCurrentList
            self.contentListTutorial = sortedContentList
            
        }
        
    }

//    func setupDadosFirebase(_ callback:@escaping(_ listaTutorial: Array<Tutorial> ) -> () ){
//        FireBase().getDadosFirebase({ (listaTutorial) in
//            callback(listaTutorial)
//        })
//
//    }
    
    private func setUpSerachBar(){
        searchTutorial.delegate = self
    }
    
    func addTutorial(_ tutorial: Tutorial) {
        listFavorite.append(tutorial)
        collectionViewTutorial.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentListTutorial.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TutorialCollectionViewCell
        let tutorial = currentListTutorial[indexPath.row]
        cell.configCollectionCell(tutorial)
        
        return cell
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tutorial = currentListTutorial[indexPath.item]
        detalheController.tutorialDetail = tutorial
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == ""{
            statusView.isHidden = true
            resultadoEncontradoLabel.isHidden = true
        } else {
            statusView.isHidden = false
            resultadoEncontradoLabel.isHidden = false
        }
        
        guard !searchText.isEmpty else {
            currentListTutorial = contentListTutorial
            collectionViewTutorial.reloadData()
            return
        }
        currentListTutorial = contentListTutorial.filter({ (conteudo) -> Bool in
            (conteudo.details.lowercased().contains(searchText.lowercased()))
        })
        
        let resultadoLabel = String(currentListTutorial.count)
        
        if currentListTutorial.count == 1 {
             resultadoEncontradoLabel.text = "\(resultadoLabel) resultado encontrado."
         } else if currentListTutorial.count > 1 {
             resultadoEncontradoLabel.text = "\(resultadoLabel) resultados encontrados."
         } else {
             resultadoEncontradoLabel.text = "não foi encontrado tutorial "
         }
 
        collectionViewTutorial.reloadData()
    }
    
}
