//
//  FavoritosTableViewController.swift
//  HelpIosMac
//
//  Created by Victor on 11/09/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class FavoritosTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var lista = TutorialDAO().returnListTutorial()
    var detalheFavoritoController = DetalheFavoritoViewController()
    
    var gerenciadorDeResultados:NSFetchedResultsController<Tutorials>?
    
    var contexo:NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    let fileManager = FileManager.default
    let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    //MARK: - View Life Cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem!.title = "Favoritos"
        
        self.recuperaTutorials()
        
        let barButton =  UIBarButtonItem(title: "Home", style: UIBarButtonItem.Style.done, target: self, action: #selector(home))
        navigationItem.rightBarButtonItem = barButton
        
        self.tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationItem.titleView?.backgroundColor = .blue
        self.navigationController?.navigationBar.topItem!.title = "Favoritos"

    }
    
    //MARK: - Metodos
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detalhe"){
            detalheFavoritoController = (segue.destination as? DetalheFavoritoViewController)!
        }
    }
    
    func recuperaTutorials(){
        let pesquisaTutorial:NSFetchRequest<Tutorials> = Tutorials.fetchRequest()
        let ordenaNome = NSSortDescriptor(key: "name", ascending: true)
        pesquisaTutorial.sortDescriptors = [ordenaNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaTutorial, managedObjectContext: contexo, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorDeResultados?.delegate = self
        
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    @objc func home(){
        if let navigation = navigationController{
            navigation.popToRootViewController(animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let listaTutorials = TutorialDAO().recuperaTutorials()
//        guard let listaTutorials = gerenciadorDeResultados?.fetchedObjects?.count else { return 0 }
        return listaTutorials.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FavoriteTableViewCell
//        guard let listaTutorials = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return cell }
        let listaTutorial = TutorialDAO().recuperaTutorials()
        let listaTutorials = listaTutorial[indexPath.row]

        
        cell.favoriteTitleLabel.text = listaTutorials.name
        cell.favoriteTextLabel.text = listaTutorials.textDetails
        
         let listNames = listaTutorials.imagesUrl as! Array<String>
         if let name = listNames.first {
            if let image = ImageController().fetchImage(imageName: name){
                cell.imageTutorial.image = image
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            
//            guard let tutorialSelecionado = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else {return}
            let listaTutorial = TutorialDAO().recuperaTutorials()
            let tutorialSelecionado = listaTutorial[indexPath.row]
            let names = tutorialSelecionado.imagesUrl as! Array<String>
            for name in names {
                ImageController().deleteImage(imageName: name)
            }
            TutorialDAO().deleteTutorial(tutorial: tutorialSelecionado)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let listaTutorials = gerenciadorDeResultados?.fetchedObjects![indexPath.row] else { return }
        let listaTutorial = TutorialDAO().recuperaTutorials()
        let listaTutorials = listaTutorial[indexPath.row]
        detalheFavoritoController.tutorial = listaTutorials

        }
    
    //MARK: - Fetched Results Controller Delegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexpath = indexPath else {return}
            tableView.deleteRows(at: [indexpath], with: .fade)
            break
        default:
            tableView.reloadData()
        }
    }

}
