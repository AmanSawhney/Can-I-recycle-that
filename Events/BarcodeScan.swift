import UIKit
import Parse
import ParseUI
import AVFoundation


class BarcodeScan: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    var alertBuyShit = UIAlertView()
    var objectPFSTUFF: PFObject!
    var name: AnyObject!
    var descriptionOfObject: AnyObject!
    var type: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allow the view to resize freely
        self.highlightView.autoresizingMask =   [UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        
        // Select the color you want for the completed scan reticle
        self.highlightView.layer.borderColor = UIColor.greenColor().CGColor
        self.highlightView.layer.borderWidth = 3
        
        // Add it to our controller's view as a subview.
        self.view.addSubview(self.highlightView)
        
        
        // For the sake of discussion this is the camera
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Create a nilable NSError to hand off to the next method.
        // Make sure to use the "var" keyword and not "let"
        var _:AVCaptureDeviceInput
        let _:NSError?
        
        
        do {
            let input = try AVCaptureDeviceInput(device: device) as AVCaptureDeviceInput
            session.addInput(input)
        } catch let error as NSError {
            print(error)
        }
        
        
        // If our input is not nil then add it to the session, otherwise we're kind of done!
        
        
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        session.addOutput(output)
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.addSublayer(previewLayer)
        
        // Start the scanner. You'll have to end it yourself later.
        session.startRunning()
        
    }
    func queryCode(code: String) {
        view.showHUD(view)
        print(Int(code)!)
        let query = PFQuery(className: "Barcode")
        query.whereKey("BarcodeID", equalTo: Int(code)!)
        query.limit = limitForRecentEventsQuery
        query.findObjectsInBackgroundWithBlock { (objects, error)-> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    if objects.count == 0 {
                        self.alertBuyShit.tag = 2
                        self.alertBuyShit.delegate = self
                        self.alertBuyShit.title = "Well Shit"
                        self.alertBuyShit.message = "Looks like I don't have that item in my database so you have to put it in manually.  Sorry!"
                        self.alertBuyShit.addButtonWithTitle("Shit")
                        self.alertBuyShit.addButtonWithTitle("Cancel")
                        self.alertBuyShit.show()
                    }
                    for object in objects {
                        self.name = object.objectForKey("ItemString")!
                        self.descriptionOfObject = object.objectForKey("Description")
                        self.type = object.objectForKey("Type") as! String
                        self.alertBuyShit.tag = 1
                        self.alertBuyShit.delegate = self
                        self.alertBuyShit.title = "Your object is \(self.name)"
                        self.alertBuyShit.message = "\(self.descriptionOfObject!)"
                        self.alertBuyShit.addButtonWithTitle("Ok")
                        self.alertBuyShit.addButtonWithTitle("Cancel")
                        self.alertBuyShit.show()
                        self.objectPFSTUFF = object
                        

                    } }
                // Reload CollView
                self.view.hideHUD()
                
            } else {   self.view.hideHUD()  }
            
            
        }
    }
    // This is called when we find a known barcode type with the camera.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var highlightViewRect = CGRectZero
        
        var barCodeObject : AVMetadataObject!
        
        var detectionString : String!
        
        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
            AVMetadataObjectTypeCode39Code,
            AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code,
            AVMetadataObjectTypeEAN8Code,
            AVMetadataObjectTypeCode93Code,
            AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code,
            AVMetadataObjectTypeQRCode,
            AVMetadataObjectTypeAztecCode
        ]
        
        
        // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
        for metadata in metadataObjects {
            
            for barcodeType in barCodeTypes {
                
                if metadata.type == barcodeType {
                    barCodeObject = self.previewLayer.transformedMetadataObjectForMetadataObject(metadata as! AVMetadataMachineReadableCodeObject)
                    
                    highlightViewRect = barCodeObject.bounds
                    
                    detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    
                    self.session.stopRunning()
                    
                    self.alert(detectionString)
                    break
                }
                
            }
        }
        
        //print(detectionString)
        self.highlightView.frame = highlightViewRect
        self.view.bringSubviewToFront(self.highlightView)
        
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int)
    {
        if alertView.tag == 1 {
            switch buttonIndex
            {
            case 0:
                // Save event on Parse
                let eventsClass = PFObject(className: EVENTS_CLASS_NAME)
                if type == "Paper" {
                    eventsClass[EVENTS_TITLE] = "Paper"
                }else  if type == "Plastic"
                {
                    eventsClass[EVENTS_TITLE] = "Plastic"
                }else {
                    eventsClass[EVENTS_TITLE] = "Other"
                    
                }
                eventsClass[EVENTS_DESCRIPTION] = description
                eventsClass[EVENTS_LOCATION] = PFUser.currentUser()?.username
                eventsClass[EVENTS_COST] = "\(1)"
                //    eventsClass[EVENTS_WEBSITE] = websiteTxt.text
                eventsClass[EVENTS_IS_PENDING] = false
                //    eventsClass[EVENTS_KEYWORDS] = "\(nameTxt.text.lowercaseString) \(locationTxt.text.lowercaseString) \(descriptionTxt.text.lowercaseString)"
                let date = NSDate()
                let formatter = NSDateFormatter()
                formatter.timeStyle = .ShortStyle
                formatter.stringFromDate(date)
                eventsClass[EVENTS_START_DATE] = date
                eventsClass[EVENTS_END_DATE] = date
                
                
                // Save Image (if exists)
                if type == "Paper" {
                    var eventImage = UIImage(named: "paper")!
                    let imageData = UIImageJPEGRepresentation(eventImage,0.5)
                    let imageFile = PFFile(name:"image.jpg", data:imageData!)
                    eventsClass[EVENTS_IMAGE] = imageFile
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
                    
                }else if type == "Plastic" {
                    var eventImage = UIImage(named: "Plastic")!
                    let imageData = UIImageJPEGRepresentation(eventImage,0.5)
                    let imageFile = PFFile(name:"image.jpg", data:imageData!)
                    eventsClass[EVENTS_IMAGE] = imageFile
                } else {
                    var eventImage = UIImage(named: "pencil")!
                    let imageData = UIImageJPEGRepresentation(eventImage,0.5)
                    let imageFile = PFFile(name:"image.jpg", data:imageData!)
                    eventsClass[EVENTS_IMAGE] = imageFile
                }
                
                
                eventsClass.saveInBackgroundWithBlock { (success, error) -> Void in
                    if error == nil {
                        self.view.hideHUD()
                        //self.openMailVC()
                        
                    } else {   self.view.hideHUD()  }
                }
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("nextView") as! UITabBarController
                self.presentViewController(nextViewController, animated:true, completion:nil)
                
                
            default:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("nextView") as! UITabBarController
                self.presentViewController(nextViewController, animated:true, completion:nil)
                

            }
        }else {
            switch buttonIndex
            {
            default:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("nextView") as! UITabBarController
                self.presentViewController(nextViewController, animated:true, completion:nil)
                

            }
        }
    }
    func alert(Code: String){
        queryCode(Code)
        self.session.startRunning()
        // for alert add .Alert instead of .Action Sheet
        
        
        // start copy
        
        //        let firstAlertAction:UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:
        //
        //
        //            {
        //                (alertAction:UIAlertAction!) in
        //
        //
        //                // action when pressed
        //
        //                self.session.startRunning()
        //
        //
        //
        //
        //        })
        
        
        // end copy
        
        
        
        
        
        
        
    }
}