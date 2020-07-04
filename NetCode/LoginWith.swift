//
//  LoginWith.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
extension LoginView {
    func loginWith(auth: String) -> Void {
        let request = formRequest(
            url: userDataURL,
            auth: auth
        )
        DispatchQueue.main.async {
            let result = getUserData(with: request)
            var user: User!
            
            switch result {
            case .failure(.statusCode(code: 403)):
                errorText = "Wrong Token / Password"
                return
            case let .failure(.statusCode(code: errorCode)):
                errorText = "Error \(errorCode): Could not login to Toggl"
                return
            case let .failure(error):
                print(error)
                fatalError() // no error screen yet implemented
            case let .success(newUser):
                user = newUser
            }
            
            try! saveKeys(user: user)
            
            // bind token, also dismisses login screen
            self.settings.user = user
        }
    }
}
