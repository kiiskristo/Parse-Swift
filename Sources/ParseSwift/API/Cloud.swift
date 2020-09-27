//
//  Cloud.swift
//  ParseSwift
//
//  Created by Kristo Kiis on 27.09.2020.
//  Copyright © 2020 Parse Community. All rights reserved.
//

import Foundation

public struct Cloud {

    /**
     Makes a *synchronous* request to login a user with specified credentials.

     Returns an instance of the successfully logged in `ParseUser`.
     This also caches the user locally so that calls to `+current` will use the latest logged in user.

     - parameter function: The name of the cloud function.
     - parameter parameters: The parameters to pass to cloud function.

     - throws: An error of type `ParseUser`.
     - returns: An instance of the logged in `ParseUser`.
     If login failed due to either an incorrect password or incorrect username, it throws a `ParseError`.
    */
    public static func callFunctionIn<T: Decodable>(
        function: String,
        parameters: [String: String]? = nil) throws -> T {
        return try cloudCommand(function: function, params: parameters).execute(options: [])
    }

    /**
     Makes an *asynchronous* request to log in a user with specified credentials.
     Returns an instance of the successfully logged in `ParseUser`.

     This also caches the user locally so that calls to `+current` will use the latest logged in user.
     - parameter function: The name of the cloud function.
     - parameter parameters: The parameters to pass to cloud function.
     - parameter callbackQueue: The queue to return to after completion. Default value of .main.
     - parameter completion: The block to execute.
     It should have the following argument signature: `(Result<Self, ParseError>)`.
    */
    public static func callFunctionInBackground<T: Decodable>(
        function: String,
        parameters: [String: String]? = nil,
        callbackQueue: DispatchQueue = .main,
        completion: @escaping (Result<T, ParseError>) -> Void
    ) {
        return cloudCommand(function: function, params: parameters)
            .executeAsync(options: [], callbackQueue: callbackQueue, completion: completion)
    }

    private static func cloudCommand<T: Decodable>(function: String, params: [String: String]? = nil) -> API.Command<NoBody, T> {

        return API.Command<NoBody, T>(method: .GET,
                                         path: .cloud(function: function),
                                         params: params) { (data) -> T in
            return try ParseCoding.jsonDecoder().decode(T.self, from: data)
        }
    }
}
