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
    @IBOutlet weak var statusVideoLabel: UILabel!
    
    
    //MARK: - Atributes
    
    var tutorialVideo:Tutorial?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayVideo()
    }

    func displayVideo() {
        guard let urlVideo = tutorialVideo?.linkVideo else { return  }
        if urlVideo.count > 1 {
            statusVideoLabel.isHidden = true
            playerView.load(withVideoId: urlVideo)
        } else {
            statusVideoLabel.isHidden = false
            statusVideoLabel.text = "Video não disponivel no momento."
        }
    }

}
