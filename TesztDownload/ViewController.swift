//
//  ViewController.swift
//  TesztDownload
//
//  Created by András Esek on 2018. 09. 08..
//  Copyright © 2018. András Esek. All rights reserved.
//

import UIKit
import WebKit
import Zip



class ViewController: UIViewController, WKNavigationDelegate {

    var webView: UIWebView!
    
    override func loadView() {
        webView = UIWebView()
     //   webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        loadZip(zip: "sampleWeb.zip")
    }
    
    func loadFile(file: String){
        NetworkService.shared.getFile(path: file, completion: {
            self.load(file: file)
        })
    }
    
    func load(file: String){
        let documentURL = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true)
        
        let fileUrl = documentURL?.appendingPathComponent(file)
        
        if FileManager.default.fileExists(atPath: (fileUrl?.path)!) {
            print("True")
            let request = URLRequest(url: fileUrl!)
            webView.loadRequest(request)
        } else {
            print("no webview")
        }
    }
    
    
    func loadZip(zip: String){
        NetworkService.shared.getFile(path: zip, completion: {
            self.unZip(zip: zip)
        })
    }
    
    func unZip(zip: String){
        let documentURL = try? FileManager.default.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: true)
        
        let fileUrl = documentURL?.appendingPathComponent(zip)
       
        if FileManager.default.fileExists(atPath: (fileUrl?.path)!) {
            do {
                let filePath = fileUrl
                let unzipDirectory = try Zip.quickUnzipFile(filePath!) // Unzip
                print("Unzipped to \(documentURL)")
                fillInContent(folder: "sampleWeb", file: "sample.html")
            }
            catch {
                print("Something went wrong")
            }
        } else {
            print("no webview")
        }
        
    }
        
    private func fillInContent(folder: String, file: String) {
            let documentURL = try? FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: true)
            
        let fileUrl = documentURL?.appendingPathComponent("\(folder)/\(file)")
            
            if FileManager.default.fileExists(atPath: (fileUrl?.path)!) {
                print("True")
                let request = URLRequest(url: fileUrl!)
                webView.loadRequest(request)
            } else {
                print("no webview")
            }
        }
}

