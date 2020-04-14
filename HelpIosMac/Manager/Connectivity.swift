//
//  Connectivity.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 09/04/20.
//  Copyright © 2020 Rinver. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
   
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func verifyStatusInternet() -> String {
        if Connectivity.isConnectedToInternet(){
            print("Internet Esta Funcionando")
            let alert = "Carregando"
            return alert
        } else {
            print("Verifique sua conexao de internet")
            let alert = "Verique sua internet"
            return alert
        }
    }
    
    func internet() -> Bool{
        if Connectivity.isConnectedToInternet(){
            return true
        } else {
            return false
        }
    }
    
}
