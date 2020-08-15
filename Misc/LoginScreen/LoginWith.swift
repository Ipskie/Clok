//
//  LoginWith.swift
//  Clok
//
//  Created by Secret Asian Man Dev on 1/7/20.
//  Copyright © 2020 Secret Asian Man 3. All rights reserved.
//

import Foundation
import Combine

extension LoginView {
    func loginWith(auth: String) -> Void {
        let request = formRequest(
            url: userDataURL,
            auth: auth
        )
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { _ in
                print("completed!")
            }, receiveValue: {
                print($0.fullName)
            })
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
                errorText = "Unknown Error \(error)"
                return
            case let .success(newUser):
                user = newUser
            }
            
            /// save user's login details in Keychain
            try! saveKeys(user: user)
            
            /// set user, also dismisses login screen
            settings.user = user
        }
    }
}
