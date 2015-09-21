import UIKit
import Parse
import GoogleMobileAds
import iAd
import AudioToolbox


class Home: UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UITextFieldDelegate,
    GADBannerViewDelegate,
    ADBannerViewDelegate
{
    
    /* Views */
    @IBOutlet var eventsCollView: UICollectionView!
    
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTxt: UITextField!
    @IBOutlet var searchCityTxt: UITextField!
    
    
    //Ad banners properties
    var iAdBannerView = ADBannerView()
    var adMobBannerView = GADBannerView()
    
    /* Variables */
    var eventsArray = NSMutableArray()
    var cellSize = CGSize()
    var searchViewIsVisible = false
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PREDEFINED SIZE OF THE EVENT CELLS
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            // iPhone
            cellSize = CGSizeMake(view.frame.size.width-30, 270)
        } else  {
            // iPad
            cellSize = CGSizeMake(350, 270)
        }
        
        // Init ad banners
        initiAdBanner()
        initAdMobBanner()
        
        
        // Search View initial setup
        searchView.frame.origin.y = -searchView.frame.size.height
        searchView.layer.cornerRadius = 10
        searchViewIsVisible = false
        searchTxt.resignFirstResponder()
        searchCityTxt.resignFirstResponder()
        
        // Set placeholder's color and text for Search text fields
        searchTxt.attributedPlaceholder = NSAttributedString(string: "Type an event name (or leave it blank)", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()] )
        searchCityTxt.attributedPlaceholder = NSAttributedString(string: "Type a city/town name (or leave it blank)", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()] )
        
        
        // Call a Parse query
        queryLatestEvents()
    }
    
    
    
    // MARK: - QUERY LATEST EVENTS
    func queryLatestEvents() {
        view.showHUD(view)
        eventsArray.removeAllObjects()
        
        var query = PFQuery(className: EVENTS_CLASS_NAME)
        query.whereKey(EVENTS_LOCATION, equalTo: PFUser.currentUser()!.username!)
        query.whereKey(EVENTS_IS_PENDING, equalTo: false)
        query.orderByDescending(EVENTS_START_DATE)
        query.limit = limitForRecentEventsQuery
        query.findObjectsInBackgroundWithBlock { (objects, error)-> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.eventsArray.addObject(object)
                    } }
                // Reload CollView
                self.eventsCollView.reloadData()
                self.view.hideHUD()
                
            } else {   self.view.hideHUD()  }
            
            
        }
    }
    
    
    
    
    
    // MARK: -  COLLECTION VIEW DELEGATES
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
        
        var eventsClass = PFObject(className: EVENTS_CLASS_NAME)
        eventsClass = eventsArray[indexPath.row] as! PFObject
        
        
        // GET EVENT'S IMAGE
        let imageFile = eventsClass[EVENTS_IMAGE] as? PFFile
        imageFile?.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData {
                    cell.eventImage.image = UIImage(data:imageData)
                } } }
        
        
        // GET EVENT'S START DATE (for the labels on the left side of the event's image)
        let dayFormatter = NSDateFormatter()
        dayFormatter.dateFormat = "dd"
        let dayStr = dayFormatter.stringFromDate(eventsClass[EVENTS_START_DATE] as! NSDate)
        cell.dayNrLabel.text = dayStr
        
        let monthFormatter = NSDateFormatter()
        monthFormatter.dateFormat = "MMM"
        let monthStr = monthFormatter.stringFromDate(eventsClass[EVENTS_START_DATE] as! NSDate)
        cell.monthLabel.text = monthStr
        
        let yearFormatter = NSDateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let yearStr = yearFormatter.stringFromDate(eventsClass[EVENTS_START_DATE] as! NSDate)
        cell.yearLabel.text = yearStr
        
//
//        // GET EVENT'S TITLE
        cell.titleLbl.text = "\(eventsClass[EVENTS_TITLE]!)".uppercaseString
//        
//        // GET EVENT'S LOCATION
        cell.locationLabel.text = "\(eventsClass[EVENTS_LOCATION]!)".uppercaseString
//        
//        
//        //GET EVENT START AND END DATES & TIME
//        var startDateFormatter = NSDateFormatter()
//        startDateFormatter.dateFormat = "MMM dd @hh:mm a"
//        let startDateStr = startDateFormatter.stringFromDate(eventsClass[EVENTS_START_DATE] as! NSDate).uppercaseString
//        var endDateFormatter = NSDateFormatter()
//        endDateFormatter.dateFormat = "MMM dd @hh:mm a"
//        let endDateStr = endDateFormatter.stringFromDate(eventsClass[EVENTS_END_DATE] as! NSDate).uppercaseString
//        
//        if startDateStr == endDateStr {  cell.timeLabel.text = startDateStr
//        } else {  cell.timeLabel.text = "\(startDateStr) - \(endDateStr)"
//        }
        
        // GET EVENT'S COST
        cell.costLabel.text = "\(eventsClass[EVENTS_COST]!)".uppercaseString
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSize
    }
    
    
    // MARK: - TAP A CELL TO OPEN EVENT DETAILS CONTROLLER
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        var eventsClass = PFObject(className: EVENTS_CLASS_NAME)
//        eventsClass = eventsArray[indexPath.row] as! PFObject
//        hideSearchView()
//        
//        let edVC = storyboard?.instantiateViewControllerWithIdentifier("EventDetails") as! EventDetails
//        edVC.eventObj = eventsClass
//        navigationController?.pushViewController(edVC, animated: true)
//    }
    
    
    
    
    
    
    // MARK: - SEARCH EVENTS BUTTON
    @IBAction func searchButt(sender: AnyObject) {
        searchViewIsVisible = !searchViewIsVisible
        
        if searchViewIsVisible {  showSearchView()
        } else { hideSearchView()  }
        
    }
    
    
    // MARK: - TEXTFIELD DELEGATE (tap Search on the keyboard to launch a search query) */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        hideSearchView()
        
        // Make a new Parse query
        eventsArray.removeAllObjects()
        let keywordsArray = searchTxt.text!.componentsSeparatedByString(" ") as [String]
        // println("\(keywordsArray)")
        
        var query = PFQuery(className: EVENTS_CLASS_NAME)
        if searchTxt.text != "" {
            query.whereKey(EVENTS_KEYWORDS, containsString: "\(keywordsArray[0])".lowercaseString)
        }
        if searchCityTxt.text != ""{
            query.whereKey(EVENTS_KEYWORDS, containsString: "\(searchCityTxt.text)".lowercaseString)
        }
        query.whereKey(EVENTS_IS_PENDING, equalTo: false)
        
        // Execute query
        query.findObjectsInBackgroundWithBlock { (objects, error)-> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.eventsArray.addObject(object)
                    } }
                
                // Reload CollView
                if self.eventsArray.count > 0 {
                    self.eventsCollView.reloadData()
                    self.title = "Events Found"
                } else {
                    var alert = UIAlertView(title: APP_NAME,
                        message: "No results. Please try a different search",
                        delegate: nil,
                        cancelButtonTitle: "OK")
                    alert.show()
                    
                    self.queryLatestEvents()
                }
                
            } else { self.view.hideHUD()  }
        }
        
        
        return true
    }
    
    
    
    
    // MARK: - SHOW/HIDE SEARCH VIEW
    func showSearchView() {
        searchTxt.becomeFirstResponder()
        searchTxt.text = "";  searchCityTxt.text = ""
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.searchView.frame.origin.y = 32
            }, completion: { (finished: Bool) in })
    }
    func hideSearchView() {
        searchTxt.resignFirstResponder(); searchCityTxt.resignFirstResponder()
        searchViewIsVisible = false
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.searchView.frame.origin.y = -self.searchView.frame.size.height
            }, completion: { (finished: Bool) in })
    }
    
    
    
    // MARK: -  REFRESH  BUTTON
    @IBAction func refreshButt(sender: AnyObject) {
        queryLatestEvents()
        searchTxt.resignFirstResponder();  searchCityTxt.becomeFirstResponder()
        hideSearchView()
        searchViewIsVisible = false
        
        self.title = "Recent Events"
    }
    
    
    
    
    
    
    // MARK: -  iAD + ADMOB BANNER METHODS
    
    // Initialize Apple iAd banner
    func initiAdBanner() {
        iAdBannerView = ADBannerView(frame: CGRectMake(0, self.view.frame.size.height, 0, 0) )
        iAdBannerView.delegate = self
        iAdBannerView.hidden = true
        view.addSubview(iAdBannerView)
    }
    
    // Initialize Google AdMob banner
    func initAdMobBanner() {
        adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSizeMake(320, 50))
        adMobBannerView.frame = CGRectMake(0, self.view.frame.size.height, 320, 50)
        adMobBannerView.adUnitID = ADMOB_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        // adMobBannerView.hidden = true
        view.addSubview(adMobBannerView)
        
        let request = GADRequest()
        adMobBannerView.loadRequest(request)
    }
    
    
    // Hide the banner
    func hideBanner(banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        // Hide the banner moving it below the bottom of the screen
        banner.frame = CGRectMake(0, self.view.frame.size.height, banner.frame.size.width, banner.frame.size.height)
        UIView.commitAnimations()
        banner.hidden = true
        
    }
    
    // Show the banner
    func showBanner(banner: UIView) {
        UIView.beginAnimations("showBanner", context: nil)
        
        // Move the banner on the bottom of the screen
        banner.frame = CGRectMake(0, self.view.frame.size.height - banner.frame.size.height - 44,
            banner.frame.size.width, banner.frame.size.height);
        
        UIView.commitAnimations()
        banner.hidden = false
        
    }
    
    // iAd banner available
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        print("iAd loaded!")
        hideBanner(adMobBannerView)
        showBanner(iAdBannerView)
    }
    
    // NO iAd banner available
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        print("iAd can't looad ads right now, they'll be available later")
        hideBanner(iAdBannerView)
        let request = GADRequest()
        adMobBannerView.loadRequest(request)
    }
    
    
    // AdMob banner available
    func adViewDidReceiveAd(view: GADBannerView!) {
        print("AdMob loaded!")
        hideBanner(iAdBannerView)
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        print("AdMob Can't load ads right now, they'll be available later \n\(error)")
        hideBanner(adMobBannerView)
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
