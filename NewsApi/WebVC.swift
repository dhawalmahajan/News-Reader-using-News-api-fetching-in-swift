//
//  WevVC.swift
//  NewsApi
//
//  Created by Dhawal Mahajan on 22/12/18.
//  Copyright © 2018 Dhawal Mahajan. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController {

    var url: String?
    @IBOutlet var webView: WKWebView!
    override func viewDidLoad() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(URLRequest(url: URL(string: url ?? "")!))
        super.viewDidLoad()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension WebVC: WKUIDelegate, WKNavigationDelegate {
    
}
