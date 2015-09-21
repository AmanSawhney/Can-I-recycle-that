/* ----------------------
 
  - Events -

  created by FV iMAGINATION ©2015
  for CodeCanyon.net

---------------------------*/

import Foundation
import UIKit


// APP NAME (Change it accordingly to the name you'll give to this app)
let APP_NAME = "Can I recycle that?"

// YOU CAN CHANGE THE "20" VALUE AS YOU WISH, THAT'S THE MAX. AMOUNT OF EVENTS THE APP WILL QUERY IN THE HOME SCREEN
let limitForRecentEventsQuery = 10000

// EMAIL ADDRESS TO EDIT (To get submitted events notifications)
let SUBMISSION_EMAIL_ADDRESS = "submission@example.com"

// EMAIL ADDRESS TO EDIT (where users can directly contact you)
let CONTACT_EMAIL_ADDRESS = "amansawhney@sawhneygames.com"

// EMAIL ADDRESS TO EDIT (where users can report inappropriate contents - accordingly to Apple EULA terms)
let REPORT_EMAIL_ADDRESS = "report@example.com"

/* IMPORTANT: REPLACE THE RED STRING BELOW WITH THE UNIT ID YOU'VE GOT BY REGISTERING YOUR APP IN http://www.apps.admob.com */
let ADMOB_UNIT_ID = "ca-app-pub-4509898719172538/7374982604"
//================================================================


// ERROR ALERT VIEW
//let error = NSError()
//var errorAlert = UIAlertView(title: APP_NAME,
//    message: "\(error.localizedDescription)",
//    delegate: nil,
//    cancelButtonTitle: "OK" )


// USEFUL PALETTE OF COLORS
let mainColor = UIColor(red: 63.0/255.0, green: 174.0/255.0, blue: 181.0/255.0, alpha: 1.0)

let red = UIColor(red: 237.0/255.0, green: 85.0/255.0, blue: 100.0/255.0, alpha: 1.0)
let orange = UIColor(red: 250.0/255.0, green: 110.0/255.0, blue: 82.0/255.0, alpha: 1.0)
let yellow = UIColor(red: 255.0/255.0, green: 207.0/255.0, blue: 85.0/255.0, alpha: 1.0)
let lightGreen = UIColor(red: 160.0/255.0, green: 212.0/255.0, blue: 104.0/255.0, alpha: 1.0)
let mint = UIColor(red: 72.0/255.0, green: 207.0/255.0, blue: 174.0/255.0, alpha: 1.0)
let aqua = UIColor(red: 79.0/255.0, green: 192.0/255.0, blue: 232.0/255.0, alpha: 1.0)
let blueJeans = UIColor(red: 93.0/255.0, green: 155.0/255.0, blue: 236.0/255.0, alpha: 1.0)
let lavander = UIColor(red: 172.0/255.0, green: 146.0/255.0, blue: 237.0/255.0, alpha: 1.0)
let darkPurple = UIColor(red: 150.0/255.0, green: 123.0/255.0, blue: 220.0/255.0, alpha: 1.0)
let pink = UIColor(red: 236.0/255.0, green: 136.0/255.0, blue: 192.0/255.0, alpha: 1.0)
let darkRed = UIColor(red: 218.0/255.0, green: 69.0/255.0, blue: 83.0/255.0, alpha: 1.0)
let paleWhite = UIColor(red: 246.0/255.0, green: 247.0/255.0, blue: 251.0/255.0, alpha: 1.0)
let lightGray = UIColor(red: 230.0/255.0, green: 233.0/255.0, blue: 238.0/255.0, alpha: 1.0)
let mediumGray = UIColor(red: 204.0/255.0, green: 208.0/255.0, blue: 217.0/255.0, alpha: 1.0)
let darkGray = UIColor(red: 67.0/255.0, green: 74.0/255.0, blue: 84.0/255.0, alpha: 1.0)
let brownLight = UIColor(red: 198.0/255.0, green: 156.0/255.0, blue: 109.0/255.0, alpha: 1.0)




// HUD VIEW (customizable by editing the code below)
var hudView = UIView()
var animImage = UIImageView(frame: CGRectMake(0, 0, 80, 80))

extension UIView {
    func showHUD(inView: UIView) {
        hudView.frame = CGRectMake(0, 0, inView.frame.size.width, inView.frame.size.height)
        hudView.backgroundColor = UIColor.whiteColor()
        hudView.alpha = 0.9
        
        let imagesArr = ["h0", "h1", "h2", "h3", "h4", "h5", "h6", "h7", "h8", "h9"]
        let images = NSMutableArray()
        for var i = 0;   i < imagesArr.count;   i++ {
            images.addObject(UIImage(named: imagesArr[i])!)
        }
        //animImage.animationImages = images as [AnyObject]
        animImage.animationDuration = 0.7
        animImage.center = hudView.center
        hudView.addSubview(animImage)
        animImage.startAnimating()
        
        inView.addSubview(hudView)
    }
    
    func hideHUD() {  hudView.removeFromSuperview()  }
}





// PARSE CONFIGURATION ===========================================================
let PARSE_APP_KEY = "e1OiFeI8ZnHHBYKXrYSN62FU0Ggf5McQitWDwvQg"
let PARSE_CLIENT_KEY = "r9iA39psGUYXpTerXLGBMuUfsYbL0DaXPJCn5r1c"


// ( DO NOT edit the variables below, otherwise the app won't work properly)

// EVENTS CLASS
var EVENTS_CLASS_NAME = "Events"
var EVENTS_TITLE = "title"
var EVENTS_DESCRIPTION = "description"
var EVENTS_WEBSITE = "website"
var EVENTS_LOCATION = "location"
var EVENTS_START_DATE = "startDate"
var EVENTS_END_DATE = "endDate"
var EVENTS_COST = "cost"
var EVENTS_IMAGE = "image"
var EVENTS_IS_PENDING = "isPending"
var EVENTS_KEYWORDS = "keywords"

// EVENT GALLERY CLASS
var GALLERY_CLASS_NAME = "Gallery"
var GALLERY_EVENT_ID = "eventID"
var GALLERY_IMAGE = "image"



//-----------------------------------------



// DATE EXTENSION TO COMPARE DATES
extension NSDate {
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool {
        var isGreater = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        return isGreater
}

func isLessThanDate(dateToCompare : NSDate) -> Bool {
        var isLess = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        return isLess
}
    
func isSameAsDate(dateToCompare : NSDate) -> Bool {
        var isEqualTo = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedSame {
            isEqualTo = true
        }
        return isEqualTo
}
    
} // end extension




