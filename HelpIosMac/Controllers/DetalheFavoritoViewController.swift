//
//  DetalheFavoritoViewController.swift
//  HelpIosMac
//
//  Created by Victor on 13/09/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class DetalheFavoritoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var tituloLabel:UILabel!
    @IBOutlet weak var textoTextView:UITextView!
    @IBOutlet weak var editarTextView:UITextView!
    @IBOutlet weak var tutorialScroll:UIScrollView!
    @IBOutlet weak var imagensTutorialCollectionView: UICollectionView!
    
    var tutorial:Tutorials?

    var contexo:NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        imagensTutorialCollectionView.dataSource = self
        imagensTutorialCollectionView.reloadData()
        
        self.setupSubirCodigo()
        
        //configurando view com teclado
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //ao clicar esconde teclado
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //ao clicar esconde teclado
        view.addGestureRecognizer(tap)
        
    }
    
    //ao clicar esconde teclado
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //funcao view teclado
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    //funcao view teclado
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
        
    func setupSubirCodigo(){
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(shareImages))
        navigationItem.rightBarButtonItem = barButton
        
        if let tutorialFavorito = tutorial{
            self.tituloLabel.text = tutorialFavorito.name
            self.textoTextView.text = tutorialFavorito.textDetails
            self.editarTextView.text = tutorialFavorito.makeTutorial        
        }
    }
    
    
    func salvarTurialGravado(){
    
    if tutorial == nil {
        tutorial = Tutorials(context: contexo)
    }
        tutorial?.name = self.tituloLabel.text
        tutorial?.textDetails = self.textoTextView.text
        tutorial?.makeTutorial = self.editarTextView.text
    
        do {
            try contexo.save()
            let alert = UIAlertController(title: "Favorito", message: "Anotação salva com sucesso.", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let arrayImages = tutorial?.imagesUrl else { return 0 }
        let listNames = arrayImages as! Array<String>

        return listNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "images", for: indexPath) as! DetalhesCollectionViewCell
        let listNames = tutorial?.imagesUrl as! Array<String>
        let listName = listNames[indexPath.row]
        
        let image = ImageController().fetchImage(imageName: listName)
        
        cell.imagensTutorial.image = image
                
        return cell
    }
 
    
    @IBAction func saveAnotation(_ sender: Any) {
        salvarTurialGravado()
    }
    
    @objc func shareImages(){
        guard let nameImages = tutorial?.imagesUrl else { return }
        let nameImagesList = nameImages as! Array<String>
        var images:Array<UIImage> = []
        
        for name in nameImagesList {
            guard let image = ImageController().fetchImage(imageName: name) else { return }
            images.append(image)
        }
        
        let activityController = UIActivityViewController(activityItems: images as [Any], applicationActivities: nil)
                                
                activityController.completionWithItemsHandler = {(nil, completed, _, error)
                    in
                    if completed{
                        print("completou o Share")
                        images.removeAll()
                    }else{
                        print("cancelado o share Mano")
                        images.removeAll()
                    }
                }
                
            present(activityController, animated: true){
                print("apresentado meu share")
            }
        
    }
    
}
