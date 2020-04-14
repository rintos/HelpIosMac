//
//  DetailsViewController.swift
//  HelpIosMac
//
//  Created by Victor on 28/08/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import SDWebImage

class DetailsViewController: UIViewController,UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var goVideo: UIButton!
    @IBOutlet weak var tutoPageControll: UIPageControl!
    
    
    
    //MARK: - Variaveis
    //Variaveis que recebem dados da ViewController
   // var listImages = TutorialDAO().returnListImages()
    var tutorialDetail: Tutorial? // recebe o tutorial selecionado da viewConroller
        
    var tutorials:Tutorials?
    var detailVideo = DetailVideoViewController()
    
    var contexo:NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
        return appDelegate.persistentContainer.viewContext
    }

    var tutorialZoom:TutorialItemProtocol!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButton =  UIBarButtonItem(title: "Salvar", style: UIBarButtonItem.Style.done, target: self, action: #selector(realizaSalvamento))
        navigationItem.rightBarButtonItem = barButton
        
        imagesCollectionView.dataSource = self
        imagesCollectionView.delegate = self
        imagesCollectionView.reloadData()
        
        setupDadosView()
        configLayout()
        
    }
    
    //MARK: - Metodos
    
    func configLayout(){
        titleTextLabel.layer.cornerRadius = 10
        titleTextLabel.layer.masksToBounds = true
        goVideo.layer.cornerRadius = 10
        goVideo.layer.masksToBounds = true
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.masksToBounds = true
        
        if let numberOfImages = tutorialDetail?.imagesUrl.count {
            tutoPageControll.numberOfPages = numberOfImages
        }
     //   tutoPageControll.hidesForSinglePage = true
        
        tutoPageControll.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setupDadosView(){
        guard let detalheTutorial = tutorialDetail else { return }
        self.titleTextLabel.text = detalheTutorial.name
        self.descriptionTextView.text = Tutorial.organizaTexto(detalheTutorial.details)
    }
        
    func recuperaTutorial()->Tutorial?{
        
        guard let titulo = titleTextLabel?.text else { return nil }
        guard let texto = descriptionTextView?.text else { return nil }
        guard let pathArrayImage = tutorialDetail?.imagesUrl else { return nil }
        guard let id = tutorialDetail?.id else { return nil }
        guard let date = tutorialDetail?.created_at else { return nil }
        
        let tutorial = Tutorial(id: id, name: titulo, details: texto, imagesUrl: pathArrayImage, images: [], created_at: date)
     
        return tutorial
    }
    
    // MARK: - CoreData Save
    
    @objc func realizaSalvamento(){
        
        guard let tutorial = recuperaTutorial() else { return }
        TutorialDAO().saveTutorial(tutorialSave: tutorial)
        
        let alert = UIAlertController(title: "Tutorial", message: "Tutorial salvo com sucesso no dispositivo", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: nil)
            alert.addAction(ok)
            
        present(alert, animated: true)
    }
      
    //MARK: - Configurando CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let images = tutorialDetail?.imagesUrl.count else { return 0 }
        return images
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageHome", for: indexPath) as! CollectionViewCell
        
        guard let namesOfImage = tutorialDetail?.imagesUrl[indexPath.row] else { return cell }
        
        cell.configCell(namesOfImage)
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let images = tutorialDetail?.imagesUrl[indexPath.row] {
//            let viewImage = showViewController(storyboard: "Main", identifier: "ImageZoomViewController") as! ImageZoomViewController
                showImage(image: images)

        }


    }

    //Corrige problema de tamamho da celular do scrollView com UIPageController
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        tutoPageControll.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        tutoPageControll.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    //MARK:- For Display the page number in page controll of collection view Cell
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let visibleRect = CGRect(origin: self.imagesCollectionView.contentOffset, size: self.imagesCollectionView.bounds.size)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        if let visibleIndexPath = self.imagesCollectionView.indexPathForItem(at: visiblePoint) {
//            self.tutoPageControll.currentPage = visibleIndexPath.row
//        }
//    }
    
    
    
    @IBAction func showVideo(_ sender: Any) {
        let videoDetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailVideoViewController") as! DetailVideoViewController
        videoDetailController.tutorialVideo = tutorialDetail
        navigationController?.pushViewController(videoDetailController, animated: true)
    }
    
}


extension DetailsViewController: TutorialItemProtocol {
    
    
    func showImage(image: String) {
        
        let viewImage = goToViewWithPushNavController(storyboard: "Main", identifier: "ImageZoomViewController", animated: true) as! ImageZoomViewController
        viewImage.img = image
    }
    
//     let popOverVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageZoomViewController") as! ImageZoomViewController
//
//        popOverVc.img = image
//
//        self.addChild(popOverVc)
//        self.view.addSubview(popOverVc.view)
//        popOverVc.didMove(toParent: self)
//    }
    
    
    
}
