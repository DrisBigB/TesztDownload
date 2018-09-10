//
//  PptVC.swift
//  TesztDownload
//
//  Created by András Esek on 2018. 09. 10..
//  Copyright © 2018. András Esek. All rights reserved.
//

import UIKit
import QuickLook

class PptVC: UIViewController, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        let documentURL = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true)
        
        let fileUrl = documentURL?.appendingPathComponent("sample.ppt")
        
        return fileUrl! as QLPreviewItem
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadPPT(ppt: "sample.ppt")
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
}
