//
//  ViewController.swift
//  JMT
//
//  Created by 이지훈 on 2023/02/22.

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
            sendIDTokenToServer(idToken: idToken) { _ in }
        }
    }
    
    
    func addButton() {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.addTarget(self, action: #selector(loginHandler), for: .touchUpInside)
        signInView.addSubview(button)
    }
    
    
    func sendIDTokenToServer(idToken: String?, completion: @escaping (GoogleSignUpModel?) -> ()) {
        //let url = URL(string: "http://34.64.165.38:8080/api/v1/auth/google")! // 서버 URL
        
        // 1
        let url = URL(string: "http://34.64.147.86:8080/api/v1/auth/google")! // 서버 URL
        
        //2
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //3
        let token = ["token": idToken]
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 4 json encoding 하기
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: token, options: [.prettyPrinted])
            //print("Token", String(data: jsonData, encoding: .utf8))
            
            //request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            // 5 바디에 담기
            request.httpBody = jsonData
            
        } catch {
            print(error)
        }
        
        //요청 6
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(nil)
            }
            
            //7 되면 말하기
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Error: HTTP status code \(httpStatus.statusCode)")
                return
            }
            
            if let jsonData = data {
                do {
                    let decode = JSONDecoder()
                    let responseData = try decode.decode(GoogleSignUpModel.self, from: jsonData)
                    
                    completion(responseData)
                    
                } catch {
                    completion(nil)
                }
            }
        }
        
        task.resume() //보내고
    }
    
    @objc func loginHandler() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    let signInConfig = GIDConfiguration(clientID:  "846233671186-1ri677r59p8slvhu0ph98kg2ir0kuk45.apps.googleusercontent.com")
   // com.googleusercontent.apps.846233671186-1ri677r59p8slvhu0ph98kg2ir0kuk45


    @IBAction func signIn(sender: Any) {
        
        GIDSignIn.sharedInstance.signIn(with: signInConfig,presenting:  self) { (user: GIDGoogleUser?, error: Error?) in
            guard error == nil else { return }
            guard let user = user else { return }
            //
            //            user.refreshTokensIfNeeded { (user: GIDGoogleUser?, error: Error?) in
            //                guard error == nil else { return }
            //                guard let user = user else { return }
            
            let idToken = user.authentication.idToken
            
            let emailAddress = user.profile?.email
            
            self.sendIDTokenToServer(idToken: idToken) { data in
                print(idToken)

                print(data )
            }
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
            guard let appleIDToken = credential.identityToken else {
                print("Unable to fetch identity token.")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Use the ID token as needed.
            print("Received ID token: \(idTokenString)")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error \(error)")
    }
}
//
//extension AppleSignInManager: ASAuthorizationControllerDelegate {
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            guard let nonce = currentNonce else {
//                fatalError("Invalid state: A login callback was received, but no login request was sent.")
//            }
//            guard let appleIDToken = appleIDCredential.identityToken else {
//                print("Unable to fetch identity token.")
//                return
//            }
//            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//                return
//            }
//            // Use the ID token as needed.
//            print("Received ID token: \(idTokenString)")
//        }
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("Sign in with Apple errored: \(error)")
//    }
// }

