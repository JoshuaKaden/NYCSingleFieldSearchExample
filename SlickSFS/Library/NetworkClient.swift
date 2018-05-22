//
//  NetworkClient.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 12/30/15.
//  Copyright © 2015 NYC DoITT. All rights reserved.
//

import Foundation
import AFNetworking

typealias ObjcDictionary = [AnyHashable : Any]

protocol NetworkClientProtocol {
    var baseURL: URL { get }
    func GET(_ URLString: String!, parameters: ObjcDictionary, result: @escaping (Result<ObjcDictionary>) -> Void)
    func POST(_ URLString: String!, parameters: ObjcDictionary, result: @escaping (Result<ObjcDictionary>) -> Void)
}

struct NetworkClient: NetworkClientProtocol {
    
    let baseURL: URL
    fileprivate let requestOperationManager: AFHTTPSessionManager
    
    init(baseURL: URL) {
        requestOperationManager = AFHTTPSessionManager(baseURL: baseURL)
        requestOperationManager.securityPolicy.allowInvalidCertificates = true
        self.baseURL = baseURL
    }
    
    func POST(_ URLString: String!, parameters: ObjcDictionary, result: @escaping (Result<ObjcDictionary>) -> Void) {
        requestOperationManager.post(URLString, parameters: parameters, progress: nil, success: {
            operation, response in
            result(.success(response as! ObjcDictionary))
        }, failure: {
            operation, error in
            result(.error(ErrorConstant.networkInvalidResponse.newNSError(underlyingError: error, userInfo: nil)))
        })
    }
    
    func GET(_ URLString: String!, parameters: ObjcDictionary, result: @escaping (Result<ObjcDictionary>) -> Void) {
        requestOperationManager.get(URLString, parameters: parameters, progress: nil, success: {
            operation, response in
            result(.success(response as! ObjcDictionary))
        }, failure: {
            operation, error in
            result(.error(ErrorConstant.networkInvalidResponse.newNSError(underlyingError: error, userInfo: nil)))
        })
    }
}
