//
//  ImageService.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 02/12/19.
//  Copyright © 2019 Rinver. All rights reserved.
//

import Foundation
import UIKit

class ImageService{
    
    static func downloadImage(withURL url: URL, completion: @escaping(_ image:UIImage?)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, url, error in
            var downloadedImage:UIImage?
            
            if let data = data{
                downloadedImage = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
            
        }
        dataTask.resume()
    }
}
