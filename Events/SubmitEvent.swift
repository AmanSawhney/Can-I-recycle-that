import UIKit
import Parse
import MessageUI


class SubmitEvent: UIViewController,
    UITextFieldDelegate,
    UITextViewDelegate,
    MFMailComposeViewControllerDelegate,
    UIAlertViewDelegate,
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate,
    UIPickerViewDataSource,
    UIPickerViewDelegate
{
    
    /* Views */
    @IBOutlet weak var paperOrPlastic: UIPickerView!
    @IBOutlet var containerScrollView: UIScrollView!
    @IBOutlet var nameTxt: UITextField!
    @IBOutlet var descriptionTxt: UITextView!
    @IBOutlet var locationTxt: UITextField!
    @IBOutlet var costTxt: UITextField!
    @IBOutlet var websiteTxt: UITextField!
    @IBOutlet var eventImage: UIImageView!
    @IBOutlet var yourNameTxt: UITextField!
    @IBOutlet var yourEmailTxt: UITextField!
    @IBOutlet var numberpicker: UIPickerView!
    
    @IBOutlet var startDateOutlet: UIButton!
    @IBOutlet var endDateOutlet: UIButton!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var submitEventOutlet: UIButton!
    var clearFieldsButt = UIButton()
    
    
    /* Variables */
    var startDateSelected = false
    var startDate = NSDate()
    var endDate = NSDate()
    var colors = ["1","2","3","4"]
    var typeOfMaterial = ["Paper *10 points*", "Plastic *5 points* ", "Empty a bin *50 ponts*"]
    
    
    
    
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        numberpicker.tag = 1
        self.numberpicker.dataSource = self;
        self.numberpicker.delegate = self;
        paperOrPlastic.tag = 2
        self.paperOrPlastic.dataSource = self;
        self.paperOrPlastic.delegate = self;
        // Setup container ScrollView
        containerScrollView.contentSize = CGSizeMake(containerScrollView.frame.size.width, submitEventOutlet.frame.origin.y + 250)
        
        // Setup datePicker
        
        
        // Clear fields BarButton Item
        clearFieldsButt = UIButton(type: UIButtonType.Custom)
        clearFieldsButt.frame = CGRectMake(0, 0, 78, 36)
        clearFieldsButt.setTitle("Clear fields", forState: UIControlState.Normal)
        clearFieldsButt.setTitleColor(mainColor, forState: UIControlState.Normal)
        clearFieldsButt.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        clearFieldsButt.backgroundColor = UIColor.whiteColor()
        clearFieldsButt.layer.cornerRadius = 5
        clearFieldsButt.addTarget(self, action: "clearFields:", forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: clearFieldsButt)
        
        
        // Round views corners
        submitEventOutlet.layer.cornerRadius = 5
    }
    
    
    // MARK: - CLEAR ALL TEXTS AND IMAGE (In order for you to insert a new Event)
    func clearFields(sender:UIButton) {
        //nameTxt.text = ""
        descriptionTxt.text = ""
        //locationTxt.text = ""
        //startDateOutlet.setTitle("Tap to choose date", forState: UIControlState.Normal)
        //endDateOutlet.setTitle("Tap to choose date", forState: UIControlState.Normal)
        //costTxt.text = ""
        //websiteTxt.text = ""
        //yourNameTxt.text = ""
        //yourEmailTxt.text = ""
        eventImage.image = nil
        
        dismissKeyboard()
    }
    
    
    
    
    // MARK: - START DATE PICKER CHANGED VALUE
    func dateChanged(datePicker: UIDatePicker) {
        // Get current date
        let currentDate = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy @hh:mm a"
        let dateStr = dateFormatter.stringFromDate(datePicker.date)
        
        // SET START DATE
        if startDateSelected {
            if datePicker.date.isLessThanDate(currentDate) {
                let alert = UIAlertView(title: APP_NAME,
                    message: "Start date cannot be less than today",
                    delegate: nil,
                    cancelButtonTitle: "OK")
                alert.show()
            } else {
                startDateOutlet.setTitle(dateStr, forState: UIControlState.Normal)
                startDate = datePicker.date
            }
            
            
            // SET END DATE
        } else {
            if datePicker.date.isSameAsDate(currentDate)   ||
                datePicker.date.isLessThanDate(currentDate) {
                    let alert = UIAlertView(title: "BOOKING",
                        message: "Check out date cannot be equal or less than today",
                        delegate: nil,
                        cancelButtonTitle: "OK")
                    alert.show()
            } else {  endDateOutlet.setTitle(dateStr, forState: UIControlState.Normal)
                endDate = datePicker.date
            }
        }
        
    }
    
    
    
    
    
    
    
    // MARK: - TAP TO DISMISS KEYBOARD
    @IBAction func TapToDismissKeyboard(sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    // DISMISS KEYBOARD
    func dismissKeyboard() {
        //nameTxt.resignFirstResponder()
        descriptionTxt.resignFirstResponder()
        //locationTxt.resignFirstResponder()
        //costTxt.resignFirstResponder()
        //websiteTxt.resignFirstResponder()
        //yourNameTxt.resignFirstResponder()
        //yourEmailTxt.resignFirstResponder()
    }
    
    
    // MARK: - TEXTFIELD DELEGATES
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameTxt { descriptionTxt.becomeFirstResponder()  }
        if textField == locationTxt { locationTxt.resignFirstResponder()  }
        if textField == costTxt { websiteTxt.becomeFirstResponder()  }
        if textField == websiteTxt { websiteTxt.resignFirstResponder()  }
        if textField == yourNameTxt { yourEmailTxt.becomeFirstResponder()  }
        if textField == yourEmailTxt { yourEmailTxt.resignFirstResponder()  }
        
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        return true
    }
    
    
    // MARK: - CHOOSE IMAGE BUTTON
    @IBAction func chooseImageButt(sender: AnyObject) {
        let alert = UIAlertView(title: APP_NAME,
            message: "Select Source",
            delegate: self,
            cancelButtonTitle: "Cancel",
            otherButtonTitles: "Photo Library", "Camera")
        alert.show()
    }
    // AlertView delegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.buttonTitleAtIndex(buttonIndex) == "Photo Library" {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                imagePicker.allowsEditing = false
                dismissKeyboard()
                presentViewController(imagePicker, animated: true, completion: nil)
            }
            
        } else if alertView.buttonTitleAtIndex(buttonIndex) == "Camera" {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
                imagePicker.allowsEditing = false
                dismissKeyboard()
                presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        eventImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    // MARK: - SET START DATE BUTTON
    @IBAction func startDateButt(sender: AnyObject) {
        startDateSelected = true
        layoutButtons()
    }
    
    
    // MARK: - SET END DATE BUTTON
    @IBAction func endDateButt(sender: AnyObject) {
        startDateSelected = false
        layoutButtons()
    }
    
    // MARK: - CHANGE BUTTONS BORDER
    func layoutButtons() {
        if startDateSelected {
            startDateOutlet.layer.borderColor = mainColor.CGColor
            startDateOutlet.layer.borderWidth = 2
            endDateOutlet.layer.borderWidth = 0
        } else {
            endDateOutlet.layer.borderColor = mainColor.CGColor
            endDateOutlet.layer.borderWidth = 2
            startDateOutlet.layer.borderWidth = 0
        }
    }
    
    
    
    
    // MARK: - SUBMIT EVENT BUTTON
    @IBAction func submitEventButt(sender: AnyObject) {
        if eventImage.image != nil {
        view.showHUD(view)
        
        // Save event on Parse
        let eventsClass = PFObject(className: EVENTS_CLASS_NAME)

        if paperOrPlastic.selectedRowInComponent(0) == 0 {
            eventsClass[EVENTS_TITLE] = "Paper"
            
        }else  if paperOrPlastic.selectedRowInComponent(0) == 1
        {
            eventsClass[EVENTS_TITLE] = "Plastic"
            let query = PFQuery(className: "User")
            query.whereKey("username", equalTo: (PFUser.currentUser()?.username)!)
            query.limit = limitForRecentEventsQuery
            query.findObjectsInBackgroundWithBlock { (objects, error)-> Void in
                if error == nil {
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            var score = object.objectForKey("score") as! Int
                            score += 10
                            PFObject(className: "User")["score"] = score
                            PFObject(className: "User").saveInBackgroundWithBlock { (success, error) -> Void in
                                if error == nil {
                                    self.view.hideHUD()
                                    //self.openMailVC()
                                    
                                } else {   self.view.hideHUD()  }
                            }

                            
                        }}}}

        }else {
            eventsClass[EVENTS_TITLE] = "Writing Material"

        }
        eventsClass[EVENTS_DESCRIPTION] = descriptionTxt.text
        eventsClass[EVENTS_LOCATION] = PFUser.currentUser()?.username
        eventsClass[EVENTS_COST] = "\(numberpicker.selectedRowInComponent(0) + 1)"
        //    eventsClass[EVENTS_WEBSITE] = websiteTxt.text
        eventsClass[EVENTS_IS_PENDING] = false
        //    eventsClass[EVENTS_KEYWORDS] = "\(nameTxt.text.lowercaseString) \(locationTxt.text.lowercaseString) \(descriptionTxt.text.lowercaseString)"
        eventsClass[EVENTS_START_DATE] = datePicker.date
        eventsClass[EVENTS_END_DATE] = datePicker.date
        
        
        // Save Image (if exists)
        if eventImage.image != nil {
            let imageData = UIImageJPEGRepresentation(eventImage.image!,0.5)
            let imageFile = PFFile(name:"image.jpg", data:imageData!)
            eventsClass[EVENTS_IMAGE] = imageFile
            eventImage.image = nil
        }
        else if paperOrPlastic.selectedRowInComponent(0) == 0 {
            eventImage.image = UIImage(named: "paper")!
            let imageData = UIImageJPEGRepresentation(eventImage.image!,0.5)
            let imageFile = PFFile(name:"image.jpg", data:imageData!)
            eventsClass[EVENTS_IMAGE] = imageFile
            eventImage.image = nil
            let gameScore = PFObject(className:"User")
            gameScore["score"] = 100
            gameScore.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
            
        }else if paperOrPlastic.selectedRowInComponent(0) == 1 {
            eventImage.image = UIImage(named: "Plastic")!
            let imageData = UIImageJPEGRepresentation(eventImage.image!,0.5)
            let imageFile = PFFile(name:"image.jpg", data:imageData!)
            eventsClass[EVENTS_IMAGE] = imageFile
            eventImage.image = nil
        } else {
            eventImage.image = UIImage(named: "pencil")!
            let imageData = UIImageJPEGRepresentation(eventImage.image!,0.5)
            let imageFile = PFFile(name:"image.jpg", data:imageData!)
            eventsClass[EVENTS_IMAGE] = imageFile
            eventImage.image = nil
        }
        
        
        eventsClass.saveInBackgroundWithBlock { (success, error) -> Void in
            if error == nil {
                self.view.hideHUD()
                //self.openMailVC()
                
            } else {   self.view.hideHUD()  }
        }
        } else {
                        let alert = UIAlertView(title: "No image no save",
                            message: "Your Submition doesnt contian an image so it will not be saved",
                            delegate: nil,
                            cancelButtonTitle: "SSSOOOOOWWWWWYYYY")
                        alert.show()

        }
        
    }
    
    //    // MARK: -  OPEN MAIL CONTROLLER
    //    func openMailVC() {
    //        // This string containes standard HTML tags, you can edit them as you wish
    //        var messageStr = "<font size = '1' color= '#222222' style = 'font-family: 'HelveticaNeue'>Event Title:<strong>\(nameTxt.text)</strong><br>Description: <strong>\(descriptionTxt.text)</strong><br>Location: <strong>\(locationTxt.text)</strong><br>Start Date: <strong>\(startDateOutlet.titleLabel!.text!)</strong><br>End Date: <strong>\(endDateOutlet.titleLabel!.text!)</strong><br>Cost: <strong>\(costTxt.text)</strong><br>Website: <strong>\(websiteTxt.text)</strong><br><br>Email for reply: <strong>\(yourEmailTxt.text)</strong><br>Regards.</font>"
    //
    //
    //        var mailComposer = MFMailComposeViewController()
    //        mailComposer.mailComposeDelegate = self
    //        mailComposer.setSubject("Event Submission from \(yourNameTxt.text)")
    //        mailComposer.setMessageBody(messageStr, isHTML: true)
    //        mailComposer.setToRecipients([SUBMISSION_EMAIL_ADDRESS])
    //        // Attach the event image
    //        var imageData = UIImageJPEGRepresentation(eventImage.image, 1.0)
    //        mailComposer.addAttachmentData(imageData, mimeType: "image/jpg", fileName: "\(nameTxt.text).jpg")
    //
    //        if MFMailComposeViewController.canSendMail() {
    //            presentViewController(mailComposer, animated: true, completion: nil)
    //        } else {
    //            let alert = UIAlertView(title: APP_NAME,
    //                message: "Your device cannot send emails. Please configure an email address into Settings -> Mail, Contacts, Calendars.",
    //                delegate: nil,
    //                cancelButtonTitle: "OK")
    //            alert.show()
    //        }
    //
    //    }
    //    // Email delegate
    //    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
    //
    //        var resultMess = ""
    //        switch result.value {
    //        case MFMailComposeResultCancelled.value:
    //            resultMess = "Mail cancelled"
    //        case MFMailComposeResultSaved.value:
    //            resultMess = "Mail saved"
    //        case MFMailComposeResultSent.value:
    //            resultMess = "Thanks for submitting your Event!\nWe'll review it asap and email you when your Event will be published or in case we'll need some additional info from you"
    //        case MFMailComposeResultFailed.value:
    //            resultMess = "Something went wrong with sending Mail, try again later."
    //        default:break
    //        }
    //
    //        // Show email result alert
    //        var alert = UIAlertView(title: APP_NAME,
    //            message: resultMess,
    //            delegate: self,
    //            cancelButtonTitle: "OK" )
    //        alert.show()
    //
    //        dismissViewControllerAnimated(false, completion: nil)
    //
    //    }
    //
    //
    //
    //
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return colors.count
        }
        else {
            return typeOfMaterial.count
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerView.tag == 1 {
            return colors[row]
        }
        else {
            return typeOfMaterial[row]
        }
    }
    
}
