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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 구글 로그인 하고나서 sign-in 에 받은 토큰을 idtoken에 넣고 서버로 전송
        if let idToken = UserDefaults.standard.string(forKey: "googleIDToken") {
            tokenSignInExample(idToken: idToken)
        }
    }
 
    func addButton() {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
        signInView.addSubview(button)
    }
    
    
    func tokenSignInExample(idToken: String) {
        guard let authData = try? JSONEncoder().encode(["idToken": idToken]) else {
            return
        }
        let url = URL(string: "https://saboten.loca.lt/api/v1/auth/google")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            // Handle response from your backend.
        }
        task.resume()
    }
//
//    func sendIDTokenToServer(idToken: String) {
//        let url = URL(string: "https://saboten.loca.lt/api/v1/auth/google")! // 서버 URL
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        let postString = "idToken=\(idToken)"
//        request.httpBody = postString.data(using: .utf8)
//
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let data = data, error == nil else {
//                print("Error: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                print("Error: HTTP status code \(httpStatus.statusCode)")
//                return
//            }
//
//            // 서버로부터의 응답 처리
//            let responseString = String(data: data, encoding: .utf8)
//            print("Response: \(responseString ?? "")")
//        }
//
//        task.resume()
//    }
//
    @objc func loginHandler() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
     let signInConfig = "846233671186-v1mirmbuqar5n0djl73cefot811vutne.apps.googleusercontent.com"
    
    @IBAction func googleLogin(_ sender: Any) {
        

        GIDSignIn.sharedInstance.signIn(with: self.signInConfig, presenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }

            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else { return }
                guard let user = user else { return }

                let idToken = user.idToken
                // Send ID token to backend (example below).
            }
        }
        }
//          let email = user.profile?.email
//          let name = user.profile?.name
//
////
////          // 1. do를 통해 가져오기
////          user.authentication.do { authentication, error in
////            guard let authentication = authentication else { return }
////            let idToken       = authentication.idToken
////            let accessToken   = authentication.accessToken
////            let refreshToken  = authentication.refreshToken
////            let clientID      = authentication.clientID
////          }
////
//          // 2. authentication에서 바로 가져오기
//          let idToken       = user.authentication.idToken
//          let accessToken   = user.authentication.accessToken
//          let refreshToken  = user.authentication.refreshToken
//          let clientID      = user.authentication.clientID
//          print(accessToken)
//        }

        //        GIDSignIn.sharedInstance.signIn(with: self) { signInResult, error in
//            guard error == nil else { return }
//            guard let signInResult = signInResult else { return }
//
//            signInResult.user.refreshTokensIfNeeded { user, error in
//                guard error == nil else { return }
//                guard let user = user else { return }
//
//                let idToken = user.idToken
//                // Send ID token to backend (example below).
//            }
//        }


    
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

