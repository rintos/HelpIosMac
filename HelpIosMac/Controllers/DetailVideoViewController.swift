//
//  DetailVideoViewController.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 22/10/19.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
import Foundation

class DetailVideoViewController: UIViewController {

    @IBOutlet weak var playerView:WKYTPlayerView!
    
    var urlVideo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.load(withVideoId: urlVideo)
        // Do any additional setup after loading the view.
    }
    
}
