//
//  NetworkClient.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 12/30/15.
//  Copyright © 2015 NYC DoITT. All rights reserved.
//

import Foundation

typealias ObjcDictionary = [AnyHashable : Any]

protocol NetworkClientProtocol {
    var baseURL: URL { get }
    func GET(_ URLString: String!, parameters: ObjcDictionary, result: @escaping (Result<ObjcDictionary>) -> Void)
    func POST(_ URLString: String!, parameters: ObjcDictionary, result: @escaping (Result<ObjcDictionary>) -> Void)
    func syncGET(_ URLString: String!, parameters: ObjcDictionary) -> Result<AnyObject>
}

struct NetworkClient: NetworkClientProtocol {
    
    let baseURL: URL
    fileprivate let requestOperationManager: AFHTTPRequestOperationManager
    
    init(baseURL: URL) {
        requestOperationManager = AFHTTPRequestOperationManager(baseURL: baseURL)
        requestOperationManager.securityPolicy.allowInvalidCertificates = true
        self.baseURL = baseURL
    }
    
    func POST(_ URLString: String!, parameters: ObjcDictionary, result: @escaping (Result<ObjcDictionary>) -> Void) {
        self.requestOperationManager.post(URLString, parameters: parameters,
            success: {
                operation, response in
                result(.success(response as! ObjcDictionary))
            }, failure: {
                operation, error in
                guard let responseDictionary: [String : Any] = operation?.responseObject as? [String : Any] else {
                    result(.error(error! as NSError))
                    return
                }
                let customError = ErrorConstant.networkInvalidResponse.newNSError(underlyingError: error, userInfo: responseDictionary)
                result(.error(customError))
            }
        )
    }
    
    func GET(_ URLString: String!, parameters: ObjcDictionary, result: @escaping (Result<ObjcDictionary>) -> Void) {
        self.requestOperationManager.get(URLString, parameters: parameters,
            success: {
                operation, response in
                result(.success(response as! ObjcDictionary))
            }, failure: {
                operation, error in
                guard let responseDictionary: [String : Any] = operation?.responseObject as? [String : Any] else {
                    result(.error(error! as NSError))
                    return
                }
                let customError = ErrorConstant.networkInvalidResponse.newNSError(underlyingError: error, userInfo: responseDictionary)
                result(.error(customError))
            }
        )
    }
    
    func syncGET(_ URLString: String!, parameters: ObjcDictionary) -> Result<AnyObject> {
        do {
            let response = try self.requestOperationManager.syncGET(URLString, parameters: parameters, operation: nil) as AnyObject
            return .success(response)
        } catch let error as NSError {
            return .error(error)
        }
    }
}
