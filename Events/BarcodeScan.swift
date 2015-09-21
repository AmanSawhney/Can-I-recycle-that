import UIKit
import AVFoundation


class BarcodeScan: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    var alertBuyShit = UIAlertView()
    
    
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
        var input:AVCaptureDeviceInput
        let error:NSError?
        

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
    
    print(detectionString)
    self.highlightView.frame = highlightViewRect
    self.view.bringSubviewToFront(self.highlightView)
    
}



func alert(Code: String){
    alertBuyShit.tag = 5
    alertBuyShit.delegate = self
    alertBuyShit.title = Code
    alertBuyShit.message = ""
    alertBuyShit.addButtonWithTitle("Ok")
    alertBuyShit.addButtonWithTitle("")
    alertBuyShit.addButtonWithTitle("Cancel")
    alertBuyShit.show()
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