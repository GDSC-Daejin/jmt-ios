//
//  ViewController.swift
//  JMT
//
//  Created by 이지훈 on 2023/02/22.
//,ㅣ,ㅣ,ㅣ,

import UIKit
import GoogleSignIn
import AuthenticationServices

class ViewController: UIViewController {
    
    @IBOutlet weak var signInView: UIView!
    
    
    override func loadView() {
        super.loadView()
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton()
        
          
    }
//
//    func google() {
//
//          let config = GIDConfiguration(clientID: "625819013497-pim0dcaslvffl3umu725k4d3svts3oti.apps.googleusercontent.com")
//
//          GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
//              if let error = error { return }
//              guard let user = user else { return }
//
//              print(user)
//          }
//    }
 
    func addButton() {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
        signInView.addSubview(button)
    }
    
    @objc func loginHandler() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    
    @IBAction func googleLogin(_ sender: Any) {
      //  846233671186-v1mirmbuqar5n0djl73cefot811vutne.apps.googleusercontent.com
      //  com.googleusercontent.apps.846233671186-v1mirmbuqar5n0djl73cefot811vutne
        
        let id = "846233671186-v1mirmbuqar5n0djl73cefot811vutne.apps.googleusercontent.com"
        // 여기서는 반전시키지 말고 ID값 그대로 적용한다.
        let signInConfig = GIDConfiguration(clientID: id)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
          guard error == nil else { return }
          guard let user else { return }
          
          let email = user.profile?.email
          let name = user.profile?.name
          
          
          // 1. do를 통해 가져오기
          user.authentication.do { authentication, error in
            guard let authentication = authentication else { return }
            let idToken       = authentication.idToken
            let accessToken   = authentication.accessToken
            let refreshToken  = authentication.refreshToken
            let clientID      = authentication.clientID
          }
          
          // 2. authentication에서 바로 가져오기
          let idToken       = user.authentication.idToken
          let accessToken   = user.authentication.accessToken
          let refreshToken  = user.authentication.refreshToken
          let clientID      = user.authentication.clientID
          print(accessToken)
        }
        
        
    }
    
    
    
    
    
}

extension ViewController : ASAuthorizationControllerDelegate  {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = credential.user
            print("👨‍🍳 \(user)")
            if let email = credential.email {
                print("✉️ \(email)")
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error \(error)")
    }
}

