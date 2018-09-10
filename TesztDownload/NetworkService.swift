//
//  NetworkService.swift
//  TesztDownload
//
//  Created by András Esek on 2018. 09. 09..
//  Copyright © 2018. András Esek. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    
    // Thread-safe
    private init() {}
    
    func getFile(path: String, completion: @escaping() -> Void) {
        let destination: DownloadRequest.DownloadFileDestination = {_, _ in
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentURL.appendingPathComponent(path)
            print(fileURL)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download("http://scheppend.hu/teszt/" + path, to: destination)
            .responseData { response in
                if let error = response.result.error {
                    print("Error: \(error.localizedDescription)")
                }
                
                completion()
        }
    }
}
