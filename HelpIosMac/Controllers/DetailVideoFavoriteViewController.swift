//
//  DetailVideoFavoriteViewController.swift
//  HelpIosMac
//
//  Created by Victor Soares de Almeida on 22/10/19.
//  Copyright © 2019 Rinver. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class DetailVideoFavoriteViewController: UIViewController {
    
    @IBOutlet weak var videoView:WKYTPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        videoView.load(withVideoId: "Mc0TMWYTU_k")

        // Do any additional setup after loading the view.
    }
    

}
