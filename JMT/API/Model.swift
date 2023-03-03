//
//  Model.swift
//  JMT
//
//  Created by 이지훈 on 2023/03/02.
//

import UIKit

struct GoogleSignUpModel: Decodable {
    let data: TokenResponse?
    let message: String?
    let code: String?
}

struct TokenResponse: Decodable {
    let grantType: String
    let accessToken: String
    let refreshToken: String
    let accessTokenExpiresIn: Int
}
