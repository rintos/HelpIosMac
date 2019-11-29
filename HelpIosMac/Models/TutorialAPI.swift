//
//  TutorialAPI.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 26/11/19.
//  Copyright © 2019 Rinver. All rights reserved.
//

import Foundation
import Alamofire

class TutorialAPI: NSObject {
    
    func getTutorial(){
        Alamofire.request("https://helpiosmac.firebaseio.com/tutorials.json", method: .get).responseJSON { (response) in
            switch response.result{
            case .success:
                if let resposta = response.result.value as? Dictionary<String, Any>{
                    let dados = resposta["details"]
                    print("dados recuperado\(dados)")
                }
                print("ok")

                break
            case .failure:
                print("gerou erro")
                break
            }
        }
    }

}
