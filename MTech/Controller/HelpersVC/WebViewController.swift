//
//  WebViewController.swift
//  MTech
//
//  Created by Adem Özsayın on 12.09.2020.
//  Copyright © 2020 Adem Özsayın. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var Activity: UIActivityIndicatorView!

    var url : URL
    var webView : WKWebView!
    var textColor : UIColor?
    var barColor : UIColor?
    
    init(url: URL, title: String?, textColor: UIColor?, barColor: UIColor?) {
        self.url = url
        self.textColor = textColor
        self.barColor = barColor
        super.init(nibName: nil, bundle: nil)
        
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SPNativeColors.customGray
        webView = WKWebView(frame: view.frame, configuration: WKWebViewConfiguration())
        webView.load(URLRequest(url: url))
        view.addSubview(webView)
        
        Activity = UIActivityIndicatorView(style: .white)
        Activity.frame = CGRect(x: (self.view.frame.width / 2) - 20, y: (self.view.frame.height - self.topbarHeight) / 2 - 20 , width: 40, height: 40)
        Activity.color = self.textColor//SPNativeColors.green
        
        webView.addSubview(Activity)
        Activity.startAnimating()
        webView.navigationDelegate = self
        Activity.hidesWhenStopped = true

        // reconfig the navigation bar
        navigationController?.navigationBar.tintColor = textColor
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : textColor ?? .black
        ]
        navigationController?.navigationBar.barTintColor = barColor
        navigationController?.navigationBar.isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Kapat", style: .done, target: self, action: #selector(close))

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Activity.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Activity.stopAnimating()
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

