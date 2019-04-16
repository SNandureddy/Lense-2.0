//
//  APIService+Booking.swift
//  Lens App
//
//  Created by Apple on 21/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.


import Foundation

enum BookingAPIServices: APIService {
    
    case bookPhotographer(dict: JSONDictionary)
    case myBookings(dict: JSONDictionary)
    case actionOnBookingRequest(dict: JSONDictionary)
    case uploadImages(dict: JSONDictionary)
    case addBookigNote(dict: JSONDictionary)
    case addBookingReview(dict: JSONDictionary)
    case addBookingNote(dict: JSONDictionary)
    case getAllImages()
    case callApiAfterDownload(dict: JSONDictionary)
    case cancelBooking(dict: JSONDictionary)
    case bookings()
    case addPacakge(id: Int)

    var path: String {
        var path = ""
        switch self {
        case .bookPhotographer:
            path = BASE_URL.appending("/api/send-booking-request")
        case .myBookings:
             path = BASE_URL.appending("/api/my-bookings")
        case .actionOnBookingRequest:
            path = BASE_URL.appending("/api/action-on-booking-request")
        case .uploadImages:
            path = BASE_URL.appending("/api/upload-booking-images")
        case .addBookigNote:
            path = BASE_URL.appending("/api/add-booking-note")
        case .addBookingReview:
            path = BASE_URL.appending("/api/add-booking-review")
        case .addBookingNote:
             path = BASE_URL.appending("/api/add-booking-note")
        case .getAllImages:
             path = BASE_URL.appending("/api/get-all-images")
        case .callApiAfterDownload:
            path = BASE_URL.appending("/api/download-photo-done-by-user")
        case .cancelBooking:
            path = BASE_URL.appending("/api/user-cancel-request")
        case .bookings:
            path = BASE_URL.appending("/api/bookings")
        case .addPacakge:
            path = BASE_URL.appending("/api/update-package")
            
            
        }
        return path
    }
    
    var resource: Resource {
        var resource: Resource!
        switch self {
        case let .bookPhotographer(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        case let .myBookings(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        case let .actionOnBookingRequest(dict):
             resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        case let .uploadImages(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        case let .addBookigNote(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        case let .addBookingReview(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        case let .addBookingNote(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        case  .getAllImages:
            resource = Resource(method: .post, parameters: nil, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        case let .callApiAfterDownload(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
      
        case let .cancelBooking(dict):
            resource = Resource(method: .post, parameters: dict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        case .bookings:
            resource = Resource(method: .get, parameters: nil, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        case let .addPacakge(id) :
            var parameterDict = JSONDictionary()
            parameterDict[APIKeys.kPackageId] = id
            resource = Resource(method: .post, parameters: parameterDict, headers: [APIKeys.kAuthorization: DataManager.accessToken!])
        }
        return resource
    }
}

// MARK: Method for webservice
extension APIManager {
    
    class func bookPhotographer(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        BookingAPIServices.bookPhotographer(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func myBookings(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        BookingAPIServices.myBookings(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func addNotes(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        BookingAPIServices.actionOnBookingRequest(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func actionOnBookingRequest(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        BookingAPIServices.actionOnBookingRequest(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func uploadImages(dict: JSONDictionary, imageData: [String: Data], successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        BookingAPIServices.uploadImages(dict: dict).request(imageDict: imageData,success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func addBookingNote(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        BookingAPIServices.addBookingNote(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }

    class func addBookingReview(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        BookingAPIServices.addBookingReview(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func getAllImages(successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        BookingAPIServices.getAllImages().request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApiAfterDownload(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        BookingAPIServices.callApiAfterDownload(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func cancelBooking(dict: JSONDictionary, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        BookingAPIServices.cancelBooking(dict: dict).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }

    class func bookings(successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        BookingAPIServices.bookings().request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func addPackage(id: Int, successCallback: @escaping JSONDictionaryResponseCallback, failureCallback: @escaping APIServiceFailureCallback) {
        BookingAPIServices.addPacakge(id: id).request(success: { (response) in
            if let responseDict = response as? JSONDictionary {
                successCallback(responseDict)
            }
            else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
}

