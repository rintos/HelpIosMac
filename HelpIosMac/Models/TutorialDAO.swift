//
//  TutorialDAO.swift
//  HelpIosMac
//
//  Created by Victor on 29/08/2019.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit

class TutorialDAO: NSObject {

    func returnListTutorial()-> Array<Tutorial>{
        
//        let contentList = [ Tutorial(name:"Verificar IP",details:"Abrir terminal e digitar ifocnfig e apertar ENTER", pathImage:"3ip.png",imagesUrl: ["img10.jpg", "img11.jpg","img9.jpg"], linkVideo: "xSLucTaX8GM"),
//                            Tutorial(name:"Instalar Impressora",details:"Acessar preferencias do sistemas e cponfigurar e selecionar drievrpreferencias do sistemas e cponfigurar e selecionar drievrpreferencias do sistemas e cponfigurar e selecionar drievrpreferencias do sistemas e cponfigurar e selecionar drievr", pathImage:"2share.png", imagesUrl: ["img1.jpg", "img2.jpg","img3.jpg"], linkVideo: "qxdkIcjn260"),
//                            Tutorial(name:"Limpar Cache",details:" Abrir o terminal do e digitar seguintes comandos a apertar Enterseguintes comandos a apertar Enterseguintes comandos a apertar Enterseguintes comandos a apertar Enterseguintes comandos a apertar Enter", pathImage:"1sobre.png", imagesUrl: ["img4.jpg", "img5.jpg","img6.jpg"], linkVideo: "Zi5vI9rTq18"),
//                            Tutorial(name:"Como compartilhar arquivos",details:"Em preferencias de sistema configurar senha e alterar configuracoes de share  sistema configurar senha e alterar configuracoes de share  sistema configurar senha e alterar configuracoes de share  sistema configurar senha e alterar configuracoes de share  sistema configurar senha e alterar configuracoes de share  ", pathImage:"2share.png", imagesUrl: ["img7.jpg", "img8.jpg","img9.jpg"], linkVideo: "SjlwKPt_bzE")]
        
        let contentList = [ Tutorial(name:"Engessado na Classe DAO",details:"Abrir terminal e digitar ifocnfig e apertar ENTER", pathImage:"3ip.png",imagesUrl: ["img10.jpg", "img11.jpg","img9.jpg"], linkVideo: "xSLucTaX8GM", images: [], imgData: [])]
        
        return contentList
        
    }
    
    func returnListImages()-> Array<String>{
        let contentListImage = ["3ip.png","2share.png","1sobre.png","2share.png"]
        return contentListImage
    }
    
}
