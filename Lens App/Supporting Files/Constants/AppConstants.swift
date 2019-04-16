//
//  AppConstants.swift
//  Lens App
//
//  Created by Apple on 26/07/18.
//  Copyright © 2018 Deftsoft. All rights reserved.
//

import Foundation

//*** MARK: Base URL's ***
    var BASE_URL = "http://1.6.98.139/webservices/photographer_app/public" //Development Local URL
//  var BASE_URL = "http://1.6.98.139/webservices/Lens_web/public"
//var BASE_URL = "http://www.thelenseapp.com/public" //Development Local URL
//var BASE_URL = "http://www.thelenseapp.com/lense_app/public" //Live URL



//basevc variable
let baseVc = BaseVC()


//*** MARK: Validations ***
let kEmailCheck = "[a-z0-9!#$%üäöß&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!üäöß#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
let kAlphaNumericSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890 ")


//*** MARK: Booking Details Arrays***
var kCurrentPhotographerArray = ["User Name", "Location", "Booking Date", "Booking Time", "Ratings", "Phone Number", "Notes"]
var kNewPhotographerArray = ["User Name", "Location", "Booking Date", "Booking Time"]
var kPastPhotographerArray = ["User Name", "Location", "Booking Date", "Booking Time", "Ratings", "Amount", "Payment Status"]
var kCurrentUserArray = ["Photographer Name", "Ratings", "Booking Date", "Booking Time", "Image Count", "Phone Number", "Notes"]
var kPastUserArray = ["Photographer Name", "Ratings", "Booking Date", "Booking Time", "Image Count", "Amount Paid"]


//*** MARK: Constants ***
let kOkay = "OKAY"
let kInformation = "Information"
let kSuccess = "Success"
let kError = "Error"
let kCancel = "CANCEL"
let kYes = "YES"
let kDone = "DONE"
let kNo = "NO"
let kNext = "NEXT"
let kEmptyString = ""


//Base VC
let kAddProfileImage = "Add Profile Image"
let kGallery = "Gallery"
let kCamera = "Camera"

//Booking Details
let kNotesPlaceholder = "Add Notes"
let kDescriptionPlaceholder = "Enter Your Description"
let kReviewPlaceholder = "Add Review (Optional)"

//MARK: Button Title
let kUPDATE = "UPDATE"
let kSAVE = "SAVE"

//*** MARK: Alerts ***
//Common
let kErrorMessage = "Something went wrong !"
let kCameraMessage = "Please provide access to Camera from settings."
let kGalleryMessage = "Please provide access to Gallery from settings."
let kLocationMessage = "Please enable location access from settings."
let kErrorWhileShowImageMessage = "Please wait for the image to load."

//Login
let kEmailValidation = "Please enter valid email address."
let kPasswordValidation = "Password must be atleast 6 characters long."
let kNewPasswordValidation = "New password must be atleast 6 characters long."
let kConfirmPasswordValidation = "Confirm Password does not match."
let kTermsValidation = "Please agree terms and conditions."

//SignupVC
let kNameValidation = "Name must be atleast 2 characters long."
let kPhoneValidation = "Please enter valid phone number."
let kSignupSuccess = "You have successfully signed up. Please verify your email address to login into the application."
let kSocialSignupSuccess = "You have successfully signed up."
let kDescriptionValidation = "Description must be atleast 4 characters long."

//Forgot Password
let kForgotEmailSent = "Forgot password link has been sent to your resgistered email address."

//Booking Details
let kNotesSuccess = "Notes saved successfully"
let kNotesValidation = "Notes must be atleast 4 characters long."


//View Images
let kImageDownloadSuccess = "Image saved to photo library."
let kRatingSuccess = "Rating submitted successfully."

// Book Photographer
let kBookPhotographerSuccess = "Request has been sent to the nearest photographer. You will receive a confirmation once photographer accepts it."
let kSelectDateMessage = "Please Select Date and Time"
let kApplyCouponCode = "Please enter a coupan code"
//Feedback
let kFeedbackPlaceholder = "Enter your message..."
let kFeedbackValidation = "Feedback must be atleast 4 characters long."
let kFeedbackSuccess = "Thank you for your feedback. We will get back to you soon."

//Cancel Booking
let kAlert = "Alert"
let kCancelBookingSure = "Are you sure you want to cancel this booking ?"

//Side Menu
let kLogoutSure = "Are you sure you want to logout ?"

//Settings
let kValidateEmail = "Profile updated successfully. Please verify your email address and login again."
let kProfileUpdateSuccess = "Profile updated successfully."
let kChangePasswordSuccess = "Password changed successfully"
let kCardUpdateSuccess = "Card details updated successfully."
let kCardAddedAuccess = "Credit card details saved successfully."
let kBankDetailsSuccess = "Paypal email account updated successfully."
let kDistanceDetailsSuccess = "Working distance updated successfully."

//Card Details
let kCardValidation = "Please enter valid card number."
let kCVVValidation = "Please enter valid cvv."
let kCardDateValidation = "Please select expiration date."

//My Bookings
let kDeclineRequestAsk = "Are you sure you want to decline request ?"
let kDeclineRequestSuccess = "Request Declined Successfully"
let kAcceptRequestSuccess = "Request Accepted Successfully"
let kAddImageValidation = "Please add all images."
let kImageUploadSuccess = "Your upload request sent successfully. Admin will process payment after confirming."
let mySubScriptionPopUpText = "Monthly subscription allows 3 bookings per month, and 5 photos per booking."
let mySubScription2PopUpText = "Monthly subscription allows 4 bookings per month, and 7 photos per booking."

//Bank Details
let kPayPalAccountValidation = "Please enter a valid paypal Account"
let kAccountNameValidation = "Account name must be atleast 2 characters long."
let kAccountNumberValidation = "Please enter valid account number."
let kBSBValidation = "Please enter valid BSB number."

//*** MARK: Titles ***
let kForgotPassword = "Forgot Password"
let kTerms = "Terms & Conditions"
let kBookPhotogrpaher = "Book Photographer"
let kMyBookings = "My Bookings"
let kBookingDetails = "Booking Details"
let kMyImages = "My Images"
let kNotifications = "Notifications"
let kSettings = "Settings"
let kViewProfile = "Profile"
let kEditProfile = "Edit Profile"
let kChangePassword = "Change Password"
let kUpdateCard = "Update Card"
let kAddCard = "Add Card"
let kRatePhotographer = "Rate Photographer"
let kRateUser = "Rate User"
let kAddDistance = "Add Distance"
let kUpdateDistance = "Update Distance"
let kUpdateBankDetails = "Update Bank Details"
let kAddBankDetails = "Add Bank Details"
let kGetDirections = "Get Directions"
let kUploadImages = "Upload Images"
let kPastBookings = "Past Bookings"

//*** MARK: Storyboard VC Identifiers ***
let kLoginVC = "LoginVC"
let kUserTypeVC = "UserTypeVC"
let kSignupVC = "SignupVC"
let kBookPhotographerVC = "BookPhotographerVC"
let kMyBookingVC = "MyBookingVC"
let kMyImagesVC = "MyImagesVC"
let kNotificationVC = "NotificationsVC"
let kSettingsVC = "SettingsVC"
let kFeedbackVC = "FeedbackVC"
let kSideMenuVC = "SideMenuVC"
let kBookingHistoryVC = "BookingHistoryVC"
let kBookingDetailsVC = "BookingDetailsVC"
let kCurrentBookingsVC = "CurrentBookingsVC"
let kImageListVC = "ImageListVC"
let kViewImageVC = "ViewImageVC"
let kViewProfileVC = "ViewProfileVC"
let kChangePasswordVC = "ChangePasswordVC"
let kCardDetailsVC = "CardDetailsVC"
let kEditProfileVC = "EditProfileVC"
let kPhotographerBookingsVC = "PhotographerBookingsVC"
let kPastBookingVC = "PastBookingVC"
let kDistanceVC = "DistanceVC"
let kBankDetailsVC = "BankDetailsVC"
let kNewBookingDetaislVC = "NewBookingDetaislVC"
let kCurrentBookingDetailsVC = "CurrentBookingDetailsVC"
let kUploadImagesVC = "UploadImagesVC"
let kDirectionsVC = "DirectionsVC"
let kPastBookingDetailsVC = "PastBookingDetailsVC"
let kPhotographerViewProfileVC = "PhotographerViewProfileVC"
let kPhotographerEditProfileVC = "PhotographerEditProfileVC"

//*** MARK: Segue Identifiers ***
let kPhotographerSignupSegue = "photographerSegue"
let kUserSignupSegue = "userSegue"
let kBusinessUserSignupSegue = "businessUserSegue"

//*** MARK: Screen Type ***
let kNew = "kNew"
var kCurrent = "kCurrent"
var kPast = "kPast"
let kUpdate = "kUpdate"
let kUser = "user"
let kPhotographer = "photographer"
let kBusinessUser = "businessUser"

//*** MARK: Cell Identifiers ***
let kMenuCell = "menuCell"
let kBookingListCell = "BookingListCell"
let kImageCell = "ImageCell"
let kNotificationCell = "NotificationCell"
let kSettingsCell = "SettingsCell"
let kPastBookingCell = "PastBookingCell"
let kAvailabilityCell = "AvailabilityCell"
let kuploadImageCell = "uploadImageCell"


//*** MARK: Data Managers ***

let kUserType = "kUserType"
let kCardAdded = "kCardAdded"
let kCardDetailsAdded = "CardDetailsAdded"
let kAccessToken = "kAccessToken"
let kUserDetails = "kUserDetails"
let kUserId = "userId"
let kDistance = "distance"
let kAvailability = "Availability"

//MARK :- Nitification Keys
let kNewRequest = "new_request"
let kActionRequestReject = "action_request_reject"
let kActionRequestAccept = "action_request_accept"
let kUplodImage = "upload_image"
let kAdminNotification = "admin_notification"

