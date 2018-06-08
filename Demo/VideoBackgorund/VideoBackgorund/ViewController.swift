//
//  ViewController.swift
//  VideoBackgorund
//
//  Created by MBA0202 on 6/5/18.
//  Copyright © 2018 MBA0202. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    var testCrash: TestCrash = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkImageView.image = testCrash.image
        guard let path = Bundle.main.path(forResource:"kimsohyun", ofType: "mp4") else {
            print("Cannot find this video")
            return
        }
        
        avPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        avPlayerLayer.frame = self.view.layer.bounds
        self.view.backgroundColor = .clear
        self.view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
        
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = .black
        view.alpha = 0.5
        self.view.insertSubview(view, belowSubview: overlayView)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero, completionHandler: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
        paused = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
}

enum TestCrash {
    case normal
    
    var image: UIImage? {
        switch self {
        case .normal: return UIImage(named: "img_check")
        }
    }
}

