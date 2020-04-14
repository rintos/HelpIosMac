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
        
    @IBOutlet weak var resultadoEncontradoLabel: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    
    var internetStatus: Bool = true
    
    
    
    //MARK: Variavel
    
    var listFavorite: Array<Tutorial> = []
    var detalheController = DetailsViewController()
    var contentList: Array<Tutorial> = []
    var currentList: Array<Tutorial> = []
    var contentListTutorial: Array<Tutorial> = []
    var currentListTutorial: Array<Tutorial> = []
    let conexao = Connectivity()
    
    var presenter:TutorialPresenter!

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showDetail"){
            detalheController = (segue.destination as? DetailsViewController)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        statusView.isHidden = true
        configLayoutSearch()
        setUpSerachBar()
        
        configPresenter()
        
        configCollectionView()
    
        resultadoEncontradoLabel.isHidden = true
        internetStatusConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationItem.titleView?.backgroundColor = .blue
        self.navigationController?.navigationBar.topItem!.title = "Help Mac & iOS"
       // verificaInternet()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    // MARK: - Metodos
    
    func configPresenter() {
        self.showProgressIndicator()
        presenter = TutorialPresenter()
        presenter.attatchView(view: self)
        presenter.loadTutorialsFromFireBase()
    }
    
    func configCollectionView(){
        collectionViewTutorial.keyboardDismissMode = .onDrag
        collectionViewTutorial.dataSource = self
        collectionViewTutorial.delegate = self
     //   self.hideStatus()
    }
    
    func internetStatusConnection() {
        if !conexao.internet(){
            print("Sem internet")
        }
    }
    
    func configLayoutSearch(){
        searchTutorial.layer.cornerRadius = 6.0
        searchTutorial.layer.masksToBounds = true
    }
    
    private func setUpSerachBar(){
        searchTutorial.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentListTutorial.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TutorialCollectionViewCell
        let tutorial = currentListTutorial[indexPath.row]
        cell.configCollectionCell(tutorial)
        internetStatus = cell.celulaInternetStatus
        
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

