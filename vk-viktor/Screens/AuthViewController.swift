//
//  ViewController.swift
//  vk-viktor
//
//  Created by Artur Igberdin on 29.01.2022.
//

import UIKit
import WebKit
import Alamofire

class AuthView: UIView {
    
}

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Решить как проверить текущую дату с expiresIn
        if !Session.shared.token.isEmpty, Session.shared.userId > 0 {
            performSegue(withIdentifier: "showFriendsScreen", sender: nil)
            return
        }
        
        authorizeToVKAPI()
        
    }
    
    func authorizeToVKAPI() {
        
    /*https ://
     oauth.vk.com
     /authorize
     ?
     client_id=7822904
     &
     display=mobile
     &
     redirect_uri=https://oauth.vk.com/blank.html
     &
     scope=262150
     &
     response_type=token
     &
     revoke=1
     &
     v=5.68
     */
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7822904"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "revoke", value: "1"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        print(urlComponents.url!)
        
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        print(navigationResponse.response.url)
        
    
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
    /*
     //Optional(https://oauth.vk.com/blank.html#
     
     access_token
     =
     92f8c18902bddb00b770d036ff6e6cbb1503c679e09e42bfabddfe9f7c8370420cf26620735b40fec98bf
     &
     expires_in
     =
     86400 (unix-time)
     &
     user_id
     =
     223761261
     */
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0] //четный key
                let value = param[1] //нечетный value
                dict[key] = value
                return dict
            }
        
        guard let token = params["access_token"], let userId = params["user_id"], let expiresIn = params["expires_in"] else { return }
        
        Session.shared.token = token
        Session.shared.userId = userId
        Session.shared.expiresIn = expiresIn
        
        
        print(token)
        
        performSegue(withIdentifier: "showFriendsScreen", sender: nil)
        
        decisionHandler(.cancel)
        
    }
}

