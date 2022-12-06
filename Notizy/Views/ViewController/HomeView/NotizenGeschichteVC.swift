//
//  NotizenGeschichteVC.swift
//  Notizy
//
//  Created by Mirko Weitkowitz on 29.11.22.
//
//https://de.wikipedia.org/wiki/Notiz

import UIKit
import WebKit


class NotizenGeschichteVC: UIViewController,UISearchBarDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://de.wikipedia.org/wiki/Notiz")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        searchBar.text = url.absoluteString
        searchBar.delegate = self
        webView.navigationDelegate = self
    }
    
    //MARK: - IBActions
    @IBAction func goBack(_ sender: UIButton) {
        webView.goBack()
    }
    
    @IBAction func goForward(_ sender: UIButton) {
        webView.goForward()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchText = searchBar.text
        let newURL = URL(string: searchText!)
        let urlRequest = URLRequest(url: newURL!)
        
        webView.load(urlRequest)
        
        // Keyboard verschwinden lassen bei Suche
        searchBar.resignFirstResponder()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        searchBar.text = webView.url?.absoluteString
    }
    
    
}







