//
//  File.swift
//  JMT
//
//  Created by 이지훈 on 2023/03/01.
//

import Foundation
import UIKit
import GoogleSignIn

func sendIDTokenToServer() {
    let url = URL(string: "http://34.64.165.38:8080/api/v1/auth/google"
)
    // ID Token 값을 가져옴
    guard let authentication = GIDSignIn.sharedInstance()?.currentUser?.authentication,
          let idToken = authentication.idToken else {
        print("ID Token not found")
        return
    }

    // HTTP 요청 생성
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    // HTTP 요청 헤더 설정 (Content-Type, Authorization)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")

    // HTTP 요청 실행
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        // 에러 발생시 처리
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }

        // 서버 응답 처리
        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid response")
            return
        }
        switch httpResponse.statusCode {
        case 200..<300:
            // 성공적인 응답 처리
            print("ID Token sent successfully")
        default:
            // 에러 응답 처리
            print("Error response: \(httpResponse.statusCode)")
        }
    }
    task.resume()
}
}
