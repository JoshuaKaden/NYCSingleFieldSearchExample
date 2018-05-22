//
//  ErrorConstant.swift
//  ThreeOneOne
//
//  Created by Kaden, Joshua on 2/2/16.
//  Copyright © 2016 NYC DoITT. All rights reserved.
//

import Foundation

let ErrorConstantUserInfoTitleKey = "ErrorConstantUserInfoTitleKey"

enum ErrorConstant: Int, CustomStringConvertible {
    case apiVersionCheckFail, busy, couldNotLoad, database, forwardGeocodeNonExactAddress, forwardGeocodeNotInNYC, geocoderNoResults, locationServicesDisabled, locationServicesProhibited, networkInvalidResponse, noInternet, noInternetTapToRetry, requestDuplicateFound, requestNotFound, requestStatusUnavailable, reverseGeocodeNotInNYC, singleFieldSearchNoValidResults, streetAddressAndIntersectionNoValidResults, taxiDropoffOutsideZone
    
    static var domain = "ThreeOneOneErrorDomain"
    
    var description : String {
        switch self {
        case .apiVersionCheckFail:
            return NSLocalizedString("There is a newer version of this app available for download. The version you are using is no longer supported.", comment: "")
        case .busy:
            return NSLocalizedString("The service is busy", comment: "")
        case .couldNotLoad:
            return NSLocalizedString("Could not load info. Please try again.", comment: "")
        case .database:
            return NSLocalizedString("Unexpected data error", comment: "")
        case .forwardGeocodeNonExactAddress:
            return NSLocalizedString("An exact address is required for this form; enter a building number and street name", comment: "")
        case .forwardGeocodeNotInNYC:
            return NSLocalizedString("We could not find this location in NYC; verify and try again", comment: "")
        case .geocoderNoResults:
            return NSLocalizedString("We are unable to locate you; enter a building number and street name or intersection", comment: "")
        case .locationServicesDisabled, .locationServicesProhibited:
            return NSLocalizedString("Location services have been disabled for this app", comment: "")
        case .networkInvalidResponse:
            return NSLocalizedString("Invalid response from network", comment: "")
        case .noInternet:
            return NSLocalizedString("Please check your internet connection", comment: "")
        case .noInternetTapToRetry:
            return NSLocalizedString("Could not load info. Please tap to try again.", comment: "")
        case .requestDuplicateFound:
            return NSLocalizedString("Call 311 for help", comment: "")
        case .requestNotFound:
            return NSLocalizedString("Check the number and re-enter or check back later if it was submitted within the past 24 hours", comment: "")
        case .requestStatusUnavailable:
            return NSLocalizedString("Request status is not available. Check later or call 311 for help.", comment: "")
        case .reverseGeocodeNotInNYC:
            return NSLocalizedString("This is not in NYC; use a NYC location", comment: "")
        case .singleFieldSearchNoValidResults:
            return NSLocalizedString("We are unable to accurately locate you. Enter a NYC address, or try again", comment: "")
        case .streetAddressAndIntersectionNoValidResults:
            return NSLocalizedString("We are unable to locate you; enter a building number and street name or intersection within NYC", comment: "")
        case .taxiDropoffOutsideZone:
            return NSLocalizedString("Taxi drivers are only required to drive you to any destination within the five boroughs, Nassau and Westchester counties and Newark Liberty Airport.", comment: "")
        }
    }
    
    fileprivate var userInfo : [String : Any] {
        get {
            return [NSLocalizedDescriptionKey : String(describing: self)]
        }
    }
    
    func newNSError(underlyingError: Error? = nil, userInfo customUserInfo: [String : Any]? = nil) -> NSError {
        var userInfo = self.userInfo
        if let underlyingError = underlyingError {
            userInfo[NSUnderlyingErrorKey] = underlyingError
        }
        if let customUserInfo = customUserInfo {
            for (key, value) in customUserInfo {
                userInfo[key] = value
            }
        }
        return NSError(domain: ErrorConstant.domain, code: self.rawValue, userInfo: userInfo)
    }
    
    static func errorConstantFromNSError(_ error: NSError) -> ErrorConstant? {
        if error.domain != ErrorConstant.domain { return nil }
        return ErrorConstant(rawValue: error.code)
    }
}
