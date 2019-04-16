//
//  BookingDataModel.swift
//  Lens App
//
//  Created by Apple on 13/08/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

//User Booking Details
struct UserCurrentBookingDetails {
    var id: Int!
    var photographerName: String!
    var photographerImageUrl: URL?
    var photohgrapherRating: Double!
    var userRating: Double!
    var date: String!
    var time: String!
    var imageCount: Int!
    var photohgrapherPhoneNumber: String!
    var notes: String?
    var status: String?
    var dateTimeMili:Double!
    var packageAmount: String!
    
    init(bookingDetails: JSONDictionary) {
        self.id = bookingDetails[APIKeys.kId] as? Int ?? 0
        self.packageAmount = bookingDetails[APIKeys.kpackageAmount] as? String ?? kEmptyString
        let dateTime = bookingDetails[APIKeys.kBookingDateMili] as? Double ?? 0.0
        let myDate = Date(milliseconds: dateTime)
        self.date = myDate.stringFromDate(format: .shortMDYDate, type: .local)
        self.time = myDate.stringFromDate(format: .time, type: .local)
        self.dateTimeMili = dateTime
        if let photoArray = bookingDetails[APIKeys.kBookingImagesList]as? JSONArray{
            self.imageCount = photoArray.count
        }
        self.photohgrapherRating = bookingDetails[APIKeys.kPhotographerBookingRating] as? Double ?? 0.0
        self.notes = bookingDetails[APIKeys.kNote] as? String ?? ""
        self.userRating = bookingDetails[APIKeys.kAverageUserRating] as? Double ?? 0.0
        self.status = bookingDetails[APIKeys.kRequestStatus] as? String ?? "0"
        if let photographerDetails = bookingDetails[APIKeys.kPhotographerDetail] as? JSONDictionary {
            self.photographerName = photographerDetails[APIKeys.kFullName] as? String ?? ""
            self.photographerImageUrl = URL(string: BASE_URL.appending(photographerDetails[APIKeys.kImage] as? String ?? ""))
            self.photohgrapherPhoneNumber = photographerDetails[APIKeys.kPhoneNumber] as? String ?? ""
        }
    }
}


//User Booking Details
struct packagesDetail{
    var amount:String!
    var id:Int!
    var packageName:String!
    var userType:String!
}
struct leftBookingsDetail {
    var id: Int!
    var userType: String!
    var packageName: String!
    var amount: String!
    var completeBookingsCount: Int!
    var message: String! = kEmptyString
    var packId:Int!
    var packages = [packagesDetail]()
    
    init(dict: JSONDictionary) {
        if let packageArray = dict[APIKeys.kPackages] as? JSONArray{
            for packDict in packageArray{
                let packId = packDict[APIKeys.kId] as? Int ?? 0
                let type = packDict[APIKeys.kUserType] as? String ?? ""
                let name = packDict[APIKeys.Kpackage_name] as? String ?? ""
                let amount = packDict[APIKeys.kAmount] as? String ?? ""
                self.packages.append(packagesDetail(amount: amount, id: packId, packageName: name, userType: type))
            }
        }
        if let myDetailDict = dict[APIKeys.Kpackage_details] as? JSONDictionary{
            self.id = myDetailDict[APIKeys.kId] as? Int ?? 0
            self.userType = myDetailDict[APIKeys.kUserType] as? String ?? ""
            self.packageName = myDetailDict[APIKeys.Kpackage_name] as? String ?? ""
            self.amount = myDetailDict[APIKeys.kAmount] as? String ?? ""
        }
        self.completeBookingsCount = dict[APIKeys.Kuser_completed_bookings_count] as? Int ?? 0
        self.packId = dict[APIKeys.kPackageId] as? Int ?? 0
        if self.userType == kUser.capitalized{
            self.message = "$\(self.amount!)"
        }
        else {
            var totalBookings = 3
            if self.packId == 3 {
                totalBookings = 4
            }
            self.message = "\(totalBookings-self.completeBookingsCount)" // > 0 ? "\(totalBookings-self.completeBookingsCount) bookings left" : "No booking left"
        }
    }
}

//User Booking Details
struct UserPastBookingDetails {
    var id: Int!
    var photographerName: String!
    var photographerImageUrl: URL?
    var photohgrapherRating: Double!
    var userRating: Double!
    var date: String!
    var time: String!
    var imageCount: Int!
    var amountPaid: String?
    var downloadStatus: [Int]! = [Int]()
    var ratingStatus:Bool! = false
    var bookingImages = [ImageDetails]()
    
    init(bookingDetails: JSONDictionary) {
        self.id = bookingDetails[APIKeys.kId] as? Int ?? 0
        let dateTime = bookingDetails[APIKeys.kBookingDateMili] as? Double ?? 0.0
        let myDate = Date(milliseconds: dateTime)
        self.date = myDate.stringFromDate(format: .shortMDYDate, type: .local)
        self.time = myDate.stringFromDate(format: .time, type: .local)
        self.imageCount = bookingDetails[APIKeys.kImageCount] as? Int ?? 0
        self.amountPaid = (bookingDetails[APIKeys.kAmount] as? String ?? "0.00")
        self.photohgrapherRating = bookingDetails[APIKeys.kAveragePhotographerRating] as? Double ?? 0.0
        self.userRating = bookingDetails[APIKeys.kAverageUserRating] as? Double ?? 0.0
        
        
        if let photographerDetails = bookingDetails[APIKeys.kPhotographerDetail] as? JSONDictionary {
            self.photographerName = photographerDetails[APIKeys.kFullName] as? String ?? ""
            self.photographerImageUrl = URL(string: BASE_URL.appending(photographerDetails[APIKeys.kImage] as? String ?? ""))
        }
        
        if let imageDetails = bookingDetails[APIKeys.kBookingImagesList] as? JSONArray {
            self.downloadStatus.removeAll()
            for index in 0..<imageDetails.count {
                if let myStatus = imageDetails[index][APIKeys.kStatus] as? Int  {
                    self.downloadStatus.append(myStatus)
                }
                else {
                    self.downloadStatus.append(0)
                }
            }
            if !self.downloadStatus.contains(1){
                if bookingDetails[APIKeys.kUserBookingRating] as? JSONDictionary == nil {
                    self.ratingStatus = true
                }
                else {
                    self.ratingStatus = false
                }
            }
            
            for  image in imageDetails{
                let imageObj  = ImageDetails(imageDetails: image)
                self.bookingImages.append(imageObj)
            }
        }
        
    }
}

//Photographer Booking New Request Details
struct PhotographerBookingDetails {
    var id: Int!
    var name: String!
    var image: URL?
    var date: String!
    var time: String!
    var location: String!
    var phoneNumber: String?
    var email: String!
    var paymentStatus: Int!
    var rating : Double!
    var amount : Double!
    var dateTimeMilli:Double!
    
    init(bookingDetails: JSONDictionary) {
        self.id = bookingDetails[APIKeys.kId] as? Int ?? 0
        self.location = bookingDetails[APIKeys.kLocation] as? String ?? ""
        let dateTime = bookingDetails[APIKeys.kBookingDateMili] as? Double ?? 0.0
        let myDate = Date(milliseconds: dateTime)
        self.date = myDate.stringFromDate(format: .shortMDYDate, type: .local)
        self.time = myDate.stringFromDate(format: .time, type: .local)
        self.dateTimeMilli = dateTime
        self.rating  = Double(bookingDetails[APIKeys.kAverageUserRating] as? Double ?? 0.0)
        self.paymentStatus = bookingDetails[APIKeys.KBookingPayemntStatus] as? Int ?? 0
        let myAmount = bookingDetails[APIKeys.kpackage_amount] as? String ?? "0.0"
        self.amount = Double(myAmount)
        if let userDetails = bookingDetails[APIKeys.kUserDetail] as? JSONDictionary {
            self.name = userDetails[APIKeys.kFullName] as? String ?? ""
            self.image = URL(string: BASE_URL.appending(userDetails[APIKeys.kImage] as? String ?? ""))
            self.phoneNumber = userDetails[APIKeys.kPhoneNumber] as? String ?? ""
            self.email = userDetails[APIKeys.kEmail] as? String ?? ""
        }
    }
}

//Photographer current Booking  Details
struct PhotographerCurrentBookingDetails {
    var id: Int!
    var name: String!
    var image: URL?
    var date: String!
    var time: String!
    var role: Int!
    var location: String!
    var phoneNumber: String?
    var email: String!
    var userRating: Double!
    var photoGrapherRating: Double!
    var notes: String!
    var latitude: Double!
    var longitude: Double!
    var bookingImages = [ImageDetails]()
    var packId:Int!
    var dateTimeMilli:Double!
    
    init(bookingDetails: JSONDictionary) {
        self.id = bookingDetails[APIKeys.kId] as? Int ?? 0
        self.packId = bookingDetails[APIKeys.kPackageId] as? Int ?? 0
        self.location = bookingDetails[APIKeys.kLocation] as? String ?? ""
        let dateTime = bookingDetails[APIKeys.kBookingDateMili] as? Double ?? 0.0
        let myDate = Date(milliseconds: dateTime)
        self.date = myDate.stringFromDate(format: .shortMDYDate, type: .local)
        self.time = myDate.stringFromDate(format: .time, type: .local)
        self.dateTimeMilli = dateTime
        self.latitude = bookingDetails[APIKeys.kLatitude1] as? Double ?? 0.0
        self.longitude = bookingDetails[APIKeys.kLongitude1] as? Double ?? 0.0
        self.notes = bookingDetails[APIKeys.kNote] as? String ?? ""
        
        self.photoGrapherRating = bookingDetails[APIKeys.kAveragePhotographerRating] as? Double ?? 0.0
        self.userRating = bookingDetails[APIKeys.kAverageUserRating] as? Double ?? 0.0
        
        
        if let userDetails = bookingDetails[APIKeys.kUserDetail] as? JSONDictionary {
            self.name = userDetails[APIKeys.kFullName] as? String ?? ""
            self.image = URL(string: BASE_URL.appending(userDetails[APIKeys.kImage] as? String ?? ""))
            self.phoneNumber = userDetails[APIKeys.kPhoneNumber] as? String ?? ""
            self.email = userDetails[APIKeys.kEmail] as? String ?? ""
            self.role = userDetails[APIKeys.kRole] as? Int ?? 0
            
        }
        
        if let imageDetails = bookingDetails[APIKeys.kBookingImagesList] as? JSONArray {
            for  image in imageDetails{
                let imageObj  = ImageDetails(imageDetails: image)
                self.bookingImages.append(imageObj)
            }
        }
    }
}



extension BookingVM {
    //photographer
    func parseNewBookingData(responseDict: JSONDictionary) {
        print(responseDict)
        self.bookingRequestes.removeAll()
        if let data = responseDict[APIKeys.kData] as? JSONDictionary {
            if let bookingDataArray = data[APIKeys.kData] as?  JSONArray {
                for booking in bookingDataArray {
                    let PhotographerBooking =  PhotographerBookingDetails(bookingDetails: booking)
                    self.bookingRequestes.append(PhotographerBooking)
                }
            }
        }
    }
    
    func parsePastBookingData(responseDict: JSONDictionary) {
        print(responseDict)
        self.pastBookingRequestes.removeAll()
        if let data = responseDict[APIKeys.kData] as? JSONDictionary {
            if let bookingDataArray = data[APIKeys.kData] as?  JSONArray {
                for booking in bookingDataArray {
                    let PhotographerBooking =  PhotographerBookingDetails(bookingDetails: booking)
                    self.pastBookingRequestes.append(PhotographerBooking)
                }
            }
        }
    }
    
    func parseCurrnetBookingData(responseDict: JSONDictionary) {
        print(responseDict)
        self.currentBookingRequestes.removeAll()
        if let data = responseDict[APIKeys.kData] as? JSONDictionary {
            if let bookingDataArray = data[APIKeys.kData] as?  JSONArray {
                for booking in bookingDataArray {
                    let PhotographerBooking =  PhotographerCurrentBookingDetails(bookingDetails: booking)
                    self.currentBookingRequestes.append(PhotographerBooking)
                }
            }
        }
    }
    
    //user
    func parseUserCurrentBookingData(responseDict: JSONDictionary){
        userCurrentBookingArray.removeAll()
        if let data = responseDict[APIKeys.kData] as? JSONDictionary {
            if let bookingDataArray = data[APIKeys.kData] as?  JSONArray {
                for booking in bookingDataArray {
                    userCurrentBookingArray.append(UserCurrentBookingDetails(bookingDetails: booking))
                    
                    //                    if let bookingPhotographerdetail = booking[APIKeys.kBookingPhographerDetail] as? JSONDictionary {
                    //
                    //                        var myDict = bookingPhotographerdetail
                    //                        if myDict[APIKeys.kBookingDateMili] == nil
                    //                        {
                    //                            myDict[APIKeys.kBookingDateMili] = booking[APIKeys.kBookingDateMili] as? Double ?? 0.0
                    //                        }
                    //                        if myDict[APIKeys.kAveragePhotographerRating] == nil
                    //                        {
                    //                            myDict[APIKeys.kPhotographerBookingRating] = booking[APIKeys.kAveragePhotographerRating] as? Double ?? 0.0
                    //                        }
                    //                        if myDict[APIKeys.kAverageUserRating] == nil
                    //                        {
                    //                            myDict[APIKeys.kUserBookingRating] = booking[APIKeys.kAverageUserRating] as? Double ?? 0.0
                    //                        }
                    //
                    //                        myDict[APIKeys.kPhotographerDetail] = booking[APIKeys.kPhotographerDetail] as? JSONDictionary ?? JSONDictionary()
                    //                        myDict[APIKeys.kBookingImagesList] = booking[APIKeys.kBookingImagesList]as? JSONArray ?? JSONArray()
                    //                       myDict[APIKeys.kNote] = booking[APIKeys.kNote] as? String ?? kEmptyString
                    //                        userCurrentBooking = UserCurrentBookingDetails(bookingDetails: myDict )
                    
                    
                    
                    
                    
                    //                        if bookingPhotographerdetail[APIKeys.kStatus] as? Int ?? 1 == 2 {
                    //                            userCurrentBooking = UserCurrentBookingDetails(bookingDetails: booking)
                    //                        }
                    //}
                }
            }
        }
    }
    
    func parseUserPastBookingData(responseDict: JSONDictionary){
        userPastBookings.removeAll()
        debugPrint(responseDict)
        if let data = responseDict[APIKeys.kData] as? JSONDictionary {
            if let bookingDataArray = data[APIKeys.kData] as?  JSONArray {
                for booking in bookingDataArray {
                    let pastBooking = UserPastBookingDetails(bookingDetails: booking)
                    self.userPastBookings.append(pastBooking)
                }
            }
        }
    }
    
    func parseImagesData(responseDict: JSONDictionary) {
        userBookingImages.removeAll()
        print(responseDict)
        if let data = responseDict[APIKeys.kData] as? JSONDictionary {
            if let bookingDataArray = data[APIKeys.kData] as?  JSONArray {
                for booking in bookingDataArray {
                    let pastBooking = UserPastBookingDetails(bookingDetails: booking)
                    self.userBookingImages.append(pastBooking)
                }
            }
        }
    }
    
    func parseBookingsData(responseDict: JSONDictionary) {
        
        if let data = responseDict[APIKeys.kData] as? JSONDictionary {
            self.leftBookingObject = leftBookingsDetail(dict: data)
        }
    }
    
    
}
