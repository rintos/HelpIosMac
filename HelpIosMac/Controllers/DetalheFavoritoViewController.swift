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

class DetalheFavoritoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var tituloLabel:UILabel!
    @IBOutlet weak var textoTextView:UITextView!
    @IBOutlet weak var editarTextView:UITextView!
    @IBOutlet weak var tutorialScroll:UIScrollView!
    @IBOutlet weak var imagensTutorialCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var goVideo: UIButton!
    @IBOutlet weak var tutoPageControll: UIPageControl!
    
    var tutorial:Tutorials?

    var contexo:NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        imagensTutorialCollectionView.dataSource = self
        imagensTutorialCollectionView.delegate = self
        imagensTutorialCollectionView.reloadData()
        
        self.setupSubirCodigo()
        configLayout()
        
        //configurando view com teclado
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //ao clicar esconde teclado
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //ao clicar esconde teclado
        view.addGestureRecognizer(tap)
            
    }
    
    func convertStringImage () -> [String]? {
        let convertedArray = tutorial?.imagesUrl as? Array<String> ?? [""]
        let listImages = convertedArray
        
        return listImages

    }
    
    
    func configLayout(){
        saveButton.layer.cornerRadius = 20
        saveButton.layer.masksToBounds = true
        editarTextView.layer.cornerRadius = 10
        editarTextView.layer.masksToBounds = true
        textoTextView.layer.cornerRadius = 10
        textoTextView.layer.masksToBounds = true
        goVideo.layer.cornerRadius = 10
        goVideo.layer.masksToBounds = true
        tituloLabel.layer.cornerRadius = 10
        tituloLabel.layer.masksToBounds = true
        imagensTutorialCollectionView.layer.cornerRadius = 5
        imagensTutorialCollectionView.layer.masksToBounds = true
        
        if let imageCount = convertStringImage() {
            let imagescount = imageCount.count
            tutoPageControll.numberOfPages = imagescount
        }
        
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
        print("nome das imagens\(listName)")
        
        let image = ImageController().fetchImage(imageName: listName)
        
        cell.imagensTutorial.image = image
        
        return cell
    }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var size = CGSize(width:0, height: 0)
        
           if UIDevice().userInterfaceIdiom == .phone
                {
                    switch UIScreen.main.nativeBounds.height
                    {
                    case 480:
                        print("iPhone Classic")
                    case 960:
                        print("iPhone 4 or 4S")

                    case 1136:
                        print("iPhone 5 or 5S or 5C")
                    size = UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: collectionView.bounds.width, height: 300) : CGSize(width: collectionView.bounds.width, height: 323)

                    case 1334:
                        print("iPhone 6 or 6S")
                        size = UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: collectionView.bounds.width, height: 350) : CGSize(width: collectionView.bounds.width, height: 365)
                    case 2208:
                        print("iPhone 6+ or 6S+")
                        print("iPhone 6 or 6S")
                        size = UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: collectionView.bounds.width, height: 370) : CGSize(width: collectionView.bounds.width, height: 385)
                    default:
                          size = UIDevice.current.userInterfaceIdiom == .phone ? CGSize(width: collectionView.bounds.width, height: 416) : CGSize(width: collectionView.bounds.width, height: 350)
                        print("Iphone 11")
                   }
               }

              if UIDevice().userInterfaceIdiom == .pad
              {
                  if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad &&
                        (UIScreen.main.bounds.size.height == 1366 || UIScreen.main.bounds.size.width == 1366))
                  {
                         print("iPad Pro : 12.9 inch")
                  }
                  else if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad &&
                        (UIScreen.main.bounds.size.height == 1024 || UIScreen.main.bounds.size.width == 1024))
                 {
                        print("iPad 2")
                        print("iPad Pro : 9.7 inch")
                        print("iPad Air/iPad Air 2")
                        print("iPad Retina")
                    print("iPhone 6 or 6S")
                    size = UIDevice.current.userInterfaceIdiom == .pad ? CGSize(width: collectionView.bounds.width, height: 680) : CGSize(width: collectionView.bounds.width, height: 700)
                }
                 else
                 {
                        print("iPad 3")
                 }
          }
                
        return size
     }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //Serve para atualizar a página selecionada no pageControl
      //  viewWillLayoutSubviews()
        tutoPageControll.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //Serve para atualizar a página selecionada no pageControl
       //viewWillLayoutSubviews()
        tutoPageControll.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }


}
