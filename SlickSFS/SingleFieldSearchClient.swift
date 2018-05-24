//
//  SingleFieldSearchClient.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 1/20/16.
//  Copyright © 2016 NYC DoITT. All rights reserved.
//

import Foundation

protocol SingleFieldSearchClientProtocol {
    static func baseURL() -> URL
    func performSingleFieldSearch(_ text: String?, completion: @escaping SingleFieldSearchCompletionAction)
    func performSingleFieldSearchOnLocation(_ location: Location, shouldPreValidate: Bool, completion: @escaping SingleFieldSearchCompletionAction)
}

typealias SingleFieldSearchCompletionAction = (Result<[Location]>) -> Void

struct SingleFieldSearchClient: SingleFieldSearchClientProtocol {
    fileprivate let appID = "f1ff782e"
    fileprivate let appKey = "2515c71697e4b2d6f8039919c9bdc332"
    fileprivate let networkClient: NetworkClientProtocol
    fileprivate let urlString = "search.json"
    
    init(networkClient: NetworkClientProtocol = NetworkClient(baseURL: SingleFieldSearchClient.baseURL())) {
        self.networkClient = networkClient
    }
    
    static func baseURL() -> URL {
        return URL(string: "https://api.cityofnewyork.us/geoclient/v1/")!
    }
    
    func performSingleFieldSearch(_ text: String?, completion: @escaping SingleFieldSearchCompletionAction) {
        guard let text = text else {
            completion(.error(ErrorConstant.geocoderNoResults.newNSError()))
            return
        }
        let parameters = buildParametersFromText(text)
        networkClient.GET(urlString, parameters: parameters) {
            result in
            switch result {
            case let .success(response):
                let locations = self.buildLocationsFromResponse(response, shouldPreValidate: false)
                completion(.success(locations))
            case let .error(error):
                completion(.error(error))
            }
        }
    }
    
    func performSingleFieldSearchOnLocation(_ location: Location, shouldPreValidate: Bool, completion: @escaping SingleFieldSearchCompletionAction) {
        let parameters = self.buildParametersFromLocation(location)
        
        networkClient.GET(urlString, parameters: parameters) {
            result in
            switch result {
            case let .success(response):
//                guard let responseDictionary = response as? ObjcDictionary else {
//                    let error = ErrorConstant.NetworkInvalidResponse.newNSError()
//                    completion(.Error(error))
//                    return
//                }
                let locations = self.buildLocationsFromResponse(response, shouldPreValidate: shouldPreValidate)
                completion(.success(locations))
            case let .error(error):
                completion(.error(error))
            }
        }
    }
    
    fileprivate func buildParametersFromLocation(_ location: Location) -> ObjcDictionary {
        let addressString = location.formattedAddressLines.joined(separator: ", ").stringByTrimmingExtraneousWhitespace()
        let searchString = addressString.replacingOccurrences(of: "–", with: "-")
        return ["input" as NSObject : searchString as AnyObject, "app_id" as NSObject : self.appID as AnyObject, "app_key" as NSObject : self.appKey as AnyObject]
    }
    
    fileprivate func buildParametersFromText(_ text: String) -> ObjcDictionary {
        return ["input" as NSObject : text as AnyObject, "app_id" as NSObject : self.appID as AnyObject, "app_key" as NSObject : self.appKey as AnyObject]
    }
    
    fileprivate func buildLocationsFromResponse(_ response: ObjcDictionary, shouldPreValidate: Bool) -> [Location] {
        // Find the top-level dictionary of results.
        guard let resultsList = response["results"] as? [[AnyHashable : AnyObject]] else { return [] }
        
        var locations: Set<Location> = []
        for result in resultsList {
            guard let addressData: ObjcDictionary = result["response"] as? ObjcDictionary else { break }
            
            let latitudeRaw = addressData["latitudeInternalLabel"] ?? addressData["latitude"] ?? 0
            let longitudeRaw = addressData["longitudeInternalLabel"] ?? addressData["longitude"] ?? 0
            
            guard let latitudeValue = latitudeRaw as? Double, let longitudeValue = longitudeRaw as? Double else {
                break
            }
            
            let coordinate = Coordinate(latitude: latitudeValue, longitude: longitudeValue)
            
            var didPreValidate: Bool = false
            if shouldPreValidate {
                let airports: [AirportProtocol] = [JFKAirportLocationValidator(), LaGuardiaAirportLocationValidator()]
                airports.forEach() { airport in
                    if airport.validateCoordinate(coordinate) {
                        locations.insert(airport.buildMainLocation())
                        didPreValidate = true
                    }
                }
            }
            
            if !didPreValidate {
                let borough = addressData["firstBoroughName"] as? String ?? ""
                let firstStreetName = addressData["firstStreetNameNormalized"] as? String ?? ""
                let houseNumber = addressData["houseNumber"] as? String ?? ""
                let secondStreetName = addressData["secondStreetNameNormalized"] as? String ?? ""
                let zipCode = addressData["zipCode"] as? String ?? ""
                
                var lines: [String] = []
                if !houseNumber.isEmpty && !firstStreetName.isEmpty {
                    lines.append("\(houseNumber) \(firstStreetName)")
                } else if !firstStreetName.isEmpty && !secondStreetName.isEmpty {
                    lines.append("\(firstStreetName) & \(secondStreetName)")
                } else if !firstStreetName.isEmpty {
                    lines.append(firstStreetName)
                }
                
                if !borough.isEmpty && !zipCode.isEmpty {
                    lines.append("\(borough), \(zipCode)")
                } else {
                    if !borough.isEmpty {
                        lines.append(borough)
                    }
                    if !zipCode.isEmpty {
                        lines.append(zipCode)
                    }
                }
                
                locations.insert(Location(borough: borough, coordinate: coordinate, firstStreetName: firstStreetName, formattedAddressLines: lines, houseNumber: houseNumber, secondStreetName: secondStreetName, zipCode: zipCode))
            }
        }
        
        return Array(locations)
    }
}
