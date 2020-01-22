//
//  TutorialDAO.swift
//  HelpIosMac
//
//  Created by Victor on 29/08/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import CoreData


class TutorialDAO: NSObject {
    
    
    var contexto:NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
        return appDelegate.persistentContainer.viewContext
    }
    
    var gerenciadorDeResultados:NSFetchedResultsController<Tutorials>?
    
    
    func recuperaTutorials() -> Array<Tutorials>{
        let pesquisaTutorial:NSFetchRequest<Tutorials> = Tutorials.fetchRequest()
        let ordenaNome = NSSortDescriptor(key: "name", ascending: true)
        pesquisaTutorial.sortDescriptors = [ordenaNome]
        
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaTutorial, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        gerenciadorDeResultados?.delegate = self as? NSFetchedResultsControllerDelegate
        
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch  {
            print(error.localizedDescription)
        }
        
        
        guard let listaTutorial = gerenciadorDeResultados?.fetchedObjects else { return [] }
        
        return listaTutorial
    }
    
    func saveTutorial(tutorialSave: Tutorial){
        
        var tutorial:NSManagedObject?
        guard let id = UUID(uuidString: tutorialSave.id as! String) else { return }
        
        let tutos = recuperaTutorials().filter() { $0.id == id }
        
        if tutos.count > 0 {
            guard let tutoEncontrado = tutos.first else { return }
            tutorial = tutoEncontrado
        }
        else {
            let entidade = NSEntityDescription.entity(forEntityName: "Tutorials", in: contexto)
            tutorial = NSManagedObject(entity: entidade!, insertInto: contexto)
        }

        
        tutorial?.setValue(id, forKey: "id")
        tutorial?.setValue(tutorialSave.name, forKey: "name")
        tutorial?.setValue(tutorialSave.details, forKey: "textDetails")
        tutorial?.setValue(tutorialSave.imagesUrl, forKey: "imagesUrl")
        tutorial?.setValue("temp", forKey: "imageName")
                
        for nameOfImages in tutorialSave.imagesUrl {
            FireBase().getImage(nameOfImages) { (imageData) in
                ImageController().saveImage(image: imageData, imageName: nameOfImages)
                    }
            }
        
        atualizaContexto()
        
        print("tutorial foi Salvo com sucesso jhahahhahahahah!!!!")

    }
    
    func atualizaContexto() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteTutorial(tutorial:Tutorials){
        contexto.delete(tutorial)
        atualizaContexto()
    }

//    func returnListTutorial()-> Array<Tutorial>{
//
////        let contentList = [ Tutorial(name:"Verificar IP",details:"Abrir terminal e digitar ifocnfig e apertar ENTER", pathImage:"3ip.png",imagesUrl: ["img10.jpg", "img11.jpg","img9.jpg"], linkVideo: "xSLucTaX8GM"),
////                            Tutorial(name:"Instalar Impressora",details:"Acessar preferencias do sistemas e cponfigurar e selecionar drievrpreferencias do sistemas e cponfigurar e selecionar drievrpreferencias do sistemas e cponfigurar e selecionar drievrpreferencias do sistemas e cponfigurar e selecionar drievr", pathImage:"2share.png", imagesUrl: ["img1.jpg", "img2.jpg","img3.jpg"], linkVideo: "qxdkIcjn260"),
////                            Tutorial(name:"Limpar Cache",details:" Abrir o terminal do e digitar seguintes comandos a apertar Enterseguintes comandos a apertar Enterseguintes comandos a apertar Enterseguintes comandos a apertar Enterseguintes comandos a apertar Enter", pathImage:"1sobre.png", imagesUrl: ["img4.jpg", "img5.jpg","img6.jpg"], linkVideo: "Zi5vI9rTq18"),
////                            Tutorial(name:"Como compartilhar arquivos",details:"Em preferencias de sistema configurar senha e alterar configuracoes de share  sistema configurar senha e alterar configuracoes de share  sistema configurar senha e alterar configuracoes de share  sistema configurar senha e alterar configuracoes de share  sistema configurar senha e alterar configuracoes de share  ", pathImage:"2share.png", imagesUrl: ["img7.jpg", "img8.jpg","img9.jpg"], linkVideo: "SjlwKPt_bzE")]
//
//        let contentList = [ Tutorial(id: "1", name:"Engessado na Classe DAO",details:"Abrir terminal e digitar ifocnfig e apertar ENTER", pathImage:"3ip.png",imagesUrl: ["img10.jpg", "img11.jpg","img9.jpg"], linkVideo: "xSLucTaX8GM", images: [], imgData: [])]
//
//        return contentList
//
//    }
//
//    func returnListImages()-> Array<String>{
//        let contentListImage = ["3ip.png","2share.png","1sobre.png","2share.png"]
//        return contentListImage
//    }
    
    
    
}
