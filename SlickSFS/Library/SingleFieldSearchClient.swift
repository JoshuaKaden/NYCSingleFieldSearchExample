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
    func performSingleFieldSearchOnLocations(_ locations: [Location], shouldPreValidate: Bool, completion: @escaping SingleFieldSearchCompletionAction)
}

typealias SingleFieldSearchCompletionAction = (Result<[Location]>) -> Void

struct SingleFieldSearchClient: SingleFieldSearchClientProtocol {
    fileprivate let appID = "aece611a"
    fileprivate let appKey = "88b12a0aeec471190fce20246414a65d"
    fileprivate let networkClient: NetworkClientProtocol
    fileprivate let urlString = "search.json"
    
    init(networkClient: NetworkClientProtocol = NetworkClient(baseURL: SingleFieldSearchClient.baseURL())) {
        self.networkClient = networkClient
    }
    
    static func baseURL() -> URL {
        return URL(string: "https://api.cityofnewyork.us/geoclient/v1/")!
    }
    
    func performSingleFieldSearchOnLocations(_ locations: [Location], shouldPreValidate: Bool, completion: @escaping SingleFieldSearchCompletionAction) {
        if locations.isEmpty {
            completion(.error(ErrorConstant.geocoderNoResults.newNSError()))
            return
        }
        
        if locations.count == 1 {
            let location = locations.first!
            self.performSingleFieldSearchOnLocation(location, shouldPreValidate: shouldPreValidate, completion: completion)
            return
        }
        
        var resultSet : Set<Location> = []
        
        for location in locations {
            
            let result = self.networkClient.syncGET(self.urlString, parameters: self.buildParametersFromLocation(location))
            switch result {
            case .error(_):
                // no op
                break
                
            case let .success(response):
                guard let response: [AnyHashable : Any] = response as? [AnyHashable: Any] else { break }
                let resultLocations = self.buildLocationsFromResponse(response, sourceLocation: location, shouldPreValidate: shouldPreValidate)
                for resultLocation in resultLocations {
                    resultSet.insert(resultLocation)
                }
            }
        }
        
        let results : [Location] = Array(resultSet)
        completion(.success(results))
    }
    
    fileprivate func performSingleFieldSearchOnLocation(_ location: Location, shouldPreValidate: Bool, completion: @escaping SingleFieldSearchCompletionAction) {
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
                let locations = self.buildLocationsFromResponse(response, sourceLocation: location, shouldPreValidate: shouldPreValidate)
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
    
    fileprivate func buildLocationsFromResponse(_ response: ObjcDictionary, sourceLocation: Location, shouldPreValidate: Bool) -> [Location] {
        // Find the top-level dictionary of results.
        guard let resultsList = response["results"] as? [[AnyHashable : AnyObject]] else { return [] }
        
        var locations: Set<Location> = []
        for result in resultsList {
            guard let addressData: ObjcDictionary = result["response"] as? ObjcDictionary else { break }
            
            //            let coordinate = sourceLocation.coordinate
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
                
                locations.insert(Location(borough: borough, coordinate: coordinate, firstStreetName: firstStreetName, houseNumber: houseNumber, secondStreetName: secondStreetName, zipCode: zipCode))
            }
        }
        
        return Array(locations)
    }
}
