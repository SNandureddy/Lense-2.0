//
//  BookingVM.swift
//  Lens App
//
//  Created by Apple on 21/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

class BookingVM {
    public static let shared = BookingVM()
    private init() {}
    
    //variables
    var bookingRequestes = [PhotographerBookingDetails]()
    var currentBookingRequestes = [PhotographerCurrentBookingDetails]()
    var userPastBookings = [UserPastBookingDetails]()
    var userCurrentBooking: UserCurrentBookingDetails!
    var pastBookingRequestes = [PhotographerBookingDetails]()
    var userBookingImages = [UserPastBookingDetails]()
    var leftBookingObject : leftBookingsDetail!
    var userCurrentBookingArray = [UserCurrentBookingDetails]()
    
    func bookPhotographer(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.bookPhotographer(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func myBookings(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.myBookings(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            if DataManager.userType == kPhotographer {//if user is a photographer
                if dict[APIKeys.kBookingType] as! Int == 3 { // 3 -> new bookings
                    self.parseNewBookingData(responseDict: responseDict)
                }else if  dict[APIKeys.kBookingType] as! Int == 1{// 1 -> current bookings
                    self.parseCurrnetBookingData(responseDict: responseDict)
                }else {  // 2 -> past bookings
                    self.parsePastBookingData(responseDict: responseDict)
                }
            }else { //if user is normal user
                if dict[APIKeys.kBookingType] as! Int == 1 {
                    self.parseUserCurrentBookingData(responseDict: responseDict)
                }else {
                    self.parseUserPastBookingData(responseDict: responseDict)
                }
            }
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func addBookingNote(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.addBookingNote(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func actionOnBookingRequest(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.actionOnBookingRequest(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func uploadImages(dict: JSONDictionary, imageData: [String: Data], response: @escaping responseCallBack) {
        APIManager.uploadImages(dict: dict, imageData: imageData, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func addBookigNote(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.addBookingNote(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func addBookingReview(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.addBookingReview(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func getAllImages(response: @escaping responseCallBack) {
        APIManager.getAllImages(successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            self.parseImagesData(responseDict: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiAfterDownload(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.callApiAfterDownload(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    func cancelBooking(dict: JSONDictionary, response: @escaping responseCallBack) {
        APIManager.cancelBooking(dict: dict, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    func bookings(response: @escaping responseCallBack) {
        APIManager.bookings(successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            self.parseBookingsData(responseDict: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    func addPackage(id:Int, response: @escaping responseCallBack) {
        APIManager.addPackage(id: id, successCallback: { (responseDict) in
            let message = responseDict[APIKeys.kMessage] as? String ?? APIManager.OTHER_ERROR
            //self.parseBookingsData(responseDict: responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
}
