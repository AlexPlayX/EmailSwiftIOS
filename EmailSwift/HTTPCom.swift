//
//  HTTPCom.swift
//  EmailSwift
//
//  Created by Алексей on 5/17/19.
//  Copyright © 2019 Алексей. All rights reserved.
//

import UIKit


class HTTPCom:NSObject{
    var comR: ((Date) -> Void)!


    @IBAction func batton(_ sender: Any) {
    }

    let baseURL = NSURL(string: BASE_URL)
    func mailReturn (_ url: URL, comR: @escaping ((Data) -> Void)) {
        let request: URLRequest = URLRequest(url: baseURL as! URL)
        let session: URLSession = URLSession(configuration: .default, delegate: self as! URLSessionDelegate, delegateQueue: nil)
        let task: URLSessionDownloadTask = session.downloadTask(with: request)
        print("conect")
        task.resume()

    }
    
    

}
