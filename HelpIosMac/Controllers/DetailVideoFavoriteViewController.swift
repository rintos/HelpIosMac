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
    @IBOutlet weak var statusVideoLabel: UILabel!
    
    //MARK: - Atributos
    
    var tutorialVideo:Tutorials?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayVideo()
    }
    
    // MARK: - Metodos
    
    func displayVideo() {
        guard let video = tutorialVideo?.linkVideo else { return }
        
        if video.count > 1 {
            statusVideoLabel.isHidden = true
            videoView.load(withVideoId: video)
        } else {
            statusVideoLabel.isHidden = false
            statusVideoLabel.text = "Video não disponivel no momento."
        }
        
    }
    
    

}
