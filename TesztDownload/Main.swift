//
//  Main.swift
//  TesztDownload
//
//  Created by András Esek on 2018. 09. 09..
//  Copyright © 2018. András Esek. All rights reserved.
//

import UIKit
import AVKit
import QuickLook

class Main: UIViewController, QLPreviewControllerDataSource {
    
    var selectedVideo = "video.mp4"
    var file = ""

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var downloadOutlet: UIButton!
    @IBOutlet weak var downloadVideo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        play.alpha = 0
        downloadVideo.alpha = 0
        label.alpha = 0
    }
    
    @IBAction func sgmAction(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedVideo = "video.mp4"
        case 1:
            selectedVideo = "video2.mp4"
        case 2:
            selectedVideo = "video3.mp4"
        case 3:
            selectedVideo = "video4.mp4"
        default:
            break;
        }
        
        let documentURL = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true)
        
        let fileUrl = documentURL?.appendingPathComponent(selectedVideo)
        if FileManager.default.fileExists(atPath: (fileUrl?.path)!){
            play.setTitle("PLAY \(selectedVideo)", for: .normal)
            play.alpha = 1
            downloadVideo.alpha = 0
        } else {
            downloadVideo.setTitle("DOWNLOAD \(selectedVideo)", for: .normal)
            play.alpha = 0
            downloadVideo.alpha = 1
        }
    }
    
    func downloadVideo(video: String){
        self.label.alpha = 1
        self.label.text = "\(video) downloading..."
        NetworkService.shared.getFile(path: video, completion: {
            self.ready(video: video)
        })
    }
    
    func ready(video: String){
        let documentURL = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true)
        
        let fileUrl = documentURL?.appendingPathComponent(video)
        
        if FileManager.default.fileExists(atPath: (fileUrl?.path)!) {
            label.alpha = 1
            label.text = "\(video) downloaded"
            play.setTitle("PLAY \(selectedVideo)", for: .normal)
            play.alpha = 1
            downloadVideo.alpha = 0
        } else {
            print("no webview")
        }
    }
    
    func playVideo() {
        let documentURL = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true)
        
        let fileUrl = documentURL?.appendingPathComponent(selectedVideo)
        
        if FileManager.default.fileExists(atPath: (fileUrl?.path)!) {
            let video = AVPlayer(url: fileUrl!)
            let videoPlayer = AVPlayerViewController()
            videoPlayer.entersFullScreenWhenPlaybackBegins = true
            videoPlayer.showsPlaybackControls = false
            videoPlayer.exitsFullScreenWhenPlaybackEnds = true
            videoPlayer.player = video
            
            present(videoPlayer, animated: true, completion:
                video.play
            )
            
        } else {
            print("no webview")
        }
    }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        let documentURL = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true)
        
        let fileUrl = documentURL?.appendingPathComponent(file)
        
        return fileUrl! as QLPreviewItem
    }
    
    func downloadPPT(ppt: String){
        NetworkService.shared.getFile(path: ppt, completion: {
            self.load(ppt: ppt)
        })
    }
    
    func load(ppt: String){
        let documentURL = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true)
        
        let fileUrl = documentURL?.appendingPathComponent(ppt)
        
        let previewController = QLPreviewController()
        previewController.dataSource = self
        present(previewController, animated: true)
    }
    
    @IBAction func downloadVideo(_ sender: UIButton) {
        downloadVideo(video: selectedVideo)
    }
    
    @IBAction func playVideo(_ sender: Any) {
        playVideo()
    }
    @IBAction func openPPT(_ sender: UIButton) {
        file = "sample.ppt"
        downloadPPT(ppt: file)
    }
    @IBAction func openPDF(_ sender: UIButton) {
        file = "sample.pdf"
        downloadPPT(ppt: file)
    }
    
    

}
