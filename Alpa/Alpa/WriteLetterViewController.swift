//
//  WriteLetterViewController.swift
//  Alpa
//
//  Created by ROHAN DAVE on 01/08/16.
//  Copyright © 2016 Rohan Dave. All rights reserved.
//

import UIKit
import AVFoundation

import FirebaseDatabase
import FirebaseAuth



private let MAXIMUM_CAMERA_CAPTURES_PER_SESSION = 3
private let CAMERA_TIMER_TRIGGER_DURATION = 8.5



class WriteLetterViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, AVCapturePhotoCaptureDelegate
{
    // MARK:
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    var currentKeyboardHeight: CGFloat!
    
    // Data
    var recipientContactProperties: FacebookFriendProperties! = FacebookFriendProperties()
    var currentLetterObject: Letter! = Letter()
    var conversationId: String!
    
    // Helper References
    var indexPathOfCellInWritingMode: IndexPath!
    var defaultNewLetterString: String!
    var isWritingNewLetter: Bool!
    var isLetterFromSelf: Bool!
    var shouldDetectEmotions: Bool! = false
    var shouldStopCameraCapture: Bool! = false
    var succesfullCameraCaptures: Int = 0
    var characterCount: Int = 0
    
    // Camera properties
    var cameraDevice: AVCaptureDevice!
    var cameraOutput: AVCaptureStillImageOutput!
    let cameraSession: AVCaptureSession! = AVCaptureSession()
    var cameraVideoPreviewLayer: AVCaptureVideoPreviewLayer!
    var cameraCaptureTimer: Timer!
    
    
    // MARK:
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupGradientBackground()
        
        // TableView Setup
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 70;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.cameraView.backgroundColor = UIColor.clear
        self.cameraView.isHidden = false
        
        self.isLetterFromSelf = (currentUserFacebookId == self.currentLetterObject.senderFbId) || (currentUserFacebookId == self.recipientContactProperties.facebookUserId)
        self.shouldDetectEmotions = (self.currentLetterObject.isLetterRead == false) && (currentUserFacebookId != self.currentLetterObject.senderFbId) && (currentUserFacebookId.characters.count > 0)
        
        if (self.isWritingNewLetter == true) {
            let barButtonItem = UIBarButtonItem(title: NSLocalizedString("Send", comment: ""), style: .done, target: self, action:  #selector(WriteLetterViewController.sendButtonTapped))
            self.navigationItem.setRightBarButton(barButtonItem, animated: true)
            
            self.defaultNewLetterString = String(format: "Dear %@, \n\n", self.recipientContactProperties.name)
            
            self.cameraView.isHidden = true
        }
        else if (self.shouldDetectEmotions == true) {
                // Camera Setup
                if let device = self.deviceForFrontCamera() {
                self.cameraDevice = device
                self.beginCameraSession()
            }
        }
        else {
            let barButton = UIBarButtonItem(title: NSLocalizedString("Emotions", comment: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(WriteLetterViewController.emotionInfoButtonTapped(sender:)))
            self.navigationItem.rightBarButtonItem = barButton
        }
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(WriteLetterViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(WriteLetterViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if (self.cameraSession.isRunning && (self.cameraSession.outputs.first != nil) && self.isWritingNewLetter == false) {
            // Activate Camera Timer
            self.cameraCaptureTimer = Timer.scheduledTimer(timeInterval: CAMERA_TIMER_TRIGGER_DURATION, target: self, selector: #selector(WriteLetterViewController.captureUserPictureBasedOnTimer), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        self.stopCameraCaptureTimer()
        self.cameraSession.stopRunning()
    }
    
    
    // MARK:
    // MARK: Action Methods
    
    func emotionInfoButtonTapped(sender: UIBarButtonItem) {
        
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "LetterEmotionViewController") as? LetterEmotionViewController  {
            controller.hidesBottomBarWhenPushed = true
            controller.emotionData = Array(self.currentLetterObject.emotionData)
            
            var title: String = NSLocalizedString("Your Emotions", comment: "")
            
            if (self.isLetterFromSelf == true) {
                title = ""
                if let receiverName = self.recipientContactProperties.name.components(separatedBy: " ").first {
                    title = NSLocalizedString(String(format: "%@'s Emotions", receiverName), comment: "")
                }
            }
            
            controller.navigationItem.title = title
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func sendButtonTapped(sender: UIBarButtonItem) {
        
        if (self.validateNewLetterData() == false) {
            return
        }
        
        var senderDictionary:[String : String] = [:]
        
        if let user = FIRAuth.auth()?.currentUser {
            for profile in user.providerData {
                senderDictionary = ["name" : profile.displayName!,
                                    "email": profile.email!,
                                    "facebookUserId" : profile.uid,
                                    "profilePictureUrl" : profile.photoURL!.absoluteString]
            }
        }
        
        let senderObject = FacebookFriendProperties(propertiesDictionary: senderDictionary)
        let letterText: String!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        let letterDate = dateFormatter.string(from: NSDate() as Date)
        
        if let cell = self.tableView.cellForRow(at: self.indexPathOfCellInWritingMode) as? WriteLetterTableViewCell {
            
            letterText = cell.letterTextView.text
            
            self.currentLetterObject = Letter(date: letterDate, fullLetterText: letterText, recieverObject: self.recipientContactProperties, senderObject: senderObject)
            
            DataService.dataService.postNewLetterInDatabase(newLetterObject: self.currentLetterObject, uniqueConversationId: self.conversationId)
            
            DataService.dataService.updateRecentContactsListInDatabase(receiverFacebookUserId: self.currentLetterObject.reciever?.facebookUserId)
            
            DataService.dataService.updateReceiverRecentContactsListInDatabase(receiverFacebookUserId: self.currentLetterObject.reciever?.facebookUserId, senderFacebookUserId: self.currentLetterObject.sender?.facebookUserId)
            
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }
    }
    
    
    // MARK:
    // MARK: Keyboard Handling
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.currentKeyboardHeight = keyboardSize.height
            self.updateConstraintsForKeyboard()
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        self.currentKeyboardHeight = 0.0
        self.updateConstraintsForKeyboard()
    }
    
    
    // MARK:
    // MARK: UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        // Just one section for one letter.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Just one letter should be presented.
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WriteLetterTableViewCell") as? WriteLetterTableViewCell {
            
            cell.letterTextView.delegate = self
            
            if (self.isWritingNewLetter == true) {
                self.indexPathOfCellInWritingMode = indexPath
                cell.configureNewLetterCell(letterText: self.defaultNewLetterString, letterDate: NSDate())
            } else {
                // Use the letter text from database.
                cell.letterTextView.isEditable = false
                cell.configureCellToDisplayLetter(letterObject: self.currentLetterObject)
            }
            
            return cell
        }
        
        return WriteLetterTableViewCell()
    }
    
    
    // MARK:
    // MARK: UITableViewDelegate Methods
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var fbUserId: String?
        
        if (self.isLetterFromSelf == true) {
            fbUserId = currentUserFacebookId
        }
        else {
            fbUserId = self.recipientContactProperties.facebookUserId
        }
        
        if let letterCell = cell as? WriteLetterTableViewCell {
            if let image = CacheService.cacheService.fetchUserImageFromCache(fbUserId: fbUserId) {
                letterCell.setUserImage(image: image)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // No header view required
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        // No footer view required
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        // No header view required, so minimum possible height for header.
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if (self.isWritingNewLetter) {
            return 4
        }
        
        // We need to leave some space after the last cell, so that the cell can 
        // scrolled above the @c cameraView and the letter is readable.
        return self.cameraView.bounds.size.height + 8
    }
    
    
    // MARK:
    // MARK: UITextViewDelegate Methods
    
     func textViewDidChange(_ textView: UITextView) {
        
        let currentOfSet = self.tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        self.tableView.setContentOffset(currentOfSet, animated: false)
    }
    
    
    // MARK:
    // MARK: AVCapturePhotoCaptureDelegate Methods
    
    @available(iOS 10.0, *)
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let sampleBuffer = photoSampleBuffer,
            let previewBuffer = previewPhotoSampleBuffer,
            let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            self.handleSuccessfulPhotoCapture(imageData: imageData)
        }
    }
    
    
    // MARK:
    // MARK: Helper Methods
    
    // MARK: Camera
    
    private func deviceForFrontCamera() -> AVCaptureDevice? {
        
        if #available(iOS 10.0, *) {
            return AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
        }
        
        // For devices with iOS version < 10.0
        if let videoDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) {
            for device in videoDevices as! [AVCaptureDevice] {
                // Find the device with front camera.
                if (device.position == AVCaptureDevicePosition.front && device.hasMediaType(AVMediaTypeVideo)) {
                    return device
                }
            }
        }
    
        return nil
    }
    
    private func beginCameraSession() {
        
        var sessionError: NSError? = nil
        var deviceInput: AVCaptureInput?
        
        do {
            deviceInput = try AVCaptureDeviceInput(device: self.cameraDevice)
        } catch let error as NSError {
            sessionError = error
            print ("Camera Session Error: %@", sessionError?.localizedDescription as Any)
        }
        
        if (self.cameraSession.canAddInput(deviceInput)) {
            self.cameraSession.addInput(deviceInput)
            self.cameraSession.sessionPreset = AVCaptureSessionPresetMedium
            
            self.cameraVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.cameraSession)
            self.cameraVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            let cameraViewBounds = self.cameraView.bounds
            self.cameraVideoPreviewLayer.bounds = cameraViewBounds
            self.cameraVideoPreviewLayer.position = CGPoint(x: cameraViewBounds.midX, y: cameraViewBounds.midY)
            self.cameraView.layer.addSublayer(self.cameraVideoPreviewLayer)
            
            self.cameraSession.startRunning()
        }
        
        if #available(iOS 10.0, *) {
            let photoOutput = AVCapturePhotoOutput()
            if (self.cameraSession.canAddOutput(photoOutput) == true) {
                self.cameraSession.addOutput(photoOutput)
            }
            
        }
        else {
            self.cameraOutput = AVCaptureStillImageOutput()
            self.cameraOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            
            if (self.cameraSession.canAddOutput(self.cameraOutput) == true) {
                self.cameraSession.addOutput(self.cameraOutput)
            }
        }
    }
    
    @objc private func captureUserPictureBasedOnTimer() {
        
        if (self.shouldStopCameraCapture == true) {
            self.stopCameraCaptureTimer()
            return
        }
        
        if #available(iOS 10.0, *) {
            if let photoOutput = self.cameraSession.outputs.first as? AVCapturePhotoOutput {
                
                let settings = AVCapturePhotoSettings()
                let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first
                let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType as Any,
                                     kCVPixelBufferWidthKey as String: 160 as Any,
                                     kCVPixelBufferHeightKey as String: 160 as Any]
                settings.previewPhotoFormat = previewFormat
                
                photoOutput.capturePhoto(with: settings, delegate: self)
            }
            
            return
        }

        // For iOS versions < 10.0
        let captureConnection = self.cameraOutput.connection(withMediaType: AVMediaTypeVideo)
        
        self.cameraOutput.captureStillImageAsynchronously(from: captureConnection) { (imageDataBuffer: CMSampleBuffer?, captureError: Error?) in
            
            if let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer) {
                self.handleSuccessfulPhotoCapture(imageData: imageData)
            }
        }
    }
    
    private func handleSuccessfulPhotoCapture(imageData: Data) {
        
        self.fetchEmotionalData(imageData: imageData)
        
        // To save the image to Photos Album for testing.
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    private func fetchEmotionalData(imageData: Data) {
        
        DataService.dataService.getEmotionResults(imageData: imageData, completionBlock: { (json, requestError) in
            
            self.succesfullCameraCaptures += 1
            if (self.succesfullCameraCaptures == MAXIMUM_CAMERA_CAPTURES_PER_SESSION) {
                self.shouldStopCameraCapture = true
            }
            
            if (requestError != nil) {
                print("EMOTION REQUEST ERROR %@", requestError?.localizedDescription as Any)
            } else {
                self.handleSuccessfulEmotionResultRequest(json: json)
            }
        })
    }
    
    private func handleSuccessfulEmotionResultRequest(json: Any?) {
        
        if let resultArray = json as? [[String : Any]],
            let scores = resultArray.first?["scores"] as? [String : Any] {
            
            var mutableScores: [String : String] = [:]
            
            for (key, value) in scores {
                if let doubleValue = value as? Double {
                    mutableScores[key] = String(describing: doubleValue)
                }
            }
            
            mutableScores["captureCount"] = String(self.succesfullCameraCaptures)
            
            DataService.dataService.postEmotionalDataInDatabase(conversationId: self.conversationId, letterId: self.currentLetterObject.letterId, emotionDataCaptureNumber: self.succesfullCameraCaptures, emotionData: mutableScores)
            
            if ( self.succesfullCameraCaptures == 1) {
                // Update the letter status to true, when the first successul camera capture is processed.
                DataService.dataService.postLetterReadStatus(conversationId: self.conversationId, letterId: self.currentLetterObject.letterId)
            }
        }
    }

    private func stopCameraCaptureTimer() {
        
        if (self.cameraCaptureTimer != nil) {
            self.cameraCaptureTimer.invalidate()
            self.cameraCaptureTimer = nil
        }
    }
    
    // MARK: Constraints Update
    
    private func updateConstraintsForKeyboard() {
        
        // If the keyboard is visible, then the tableView needs to be scrollable above the keyboard. Else, constant will be zero.
        self.tableViewBottomConstraint.constant = (self.currentKeyboardHeight > 0.0) ? (self.currentKeyboardHeight + 4) : 0.0
    }
    
    // MARK: Data Validation
    
    private func validateNewLetterData() -> Bool {
        
        let minCharactersValidation = self.validateNewLetterDataForMinCharacters()
        let maxCharactersValidation = self.validateNewLetterDataForMaxCharacters()
        
        if (minCharactersValidation == false) {
            let title = NSLocalizedString("At least 120 characters required", comment: "")
            let messageFormat = String(format: "You have written %ld characters. Write down some more words.", self.characterCount)
            let message = NSLocalizedString(messageFormat, comment: "")
            
            self.presentAlertControllerWithOkButton(title: title, message: message)
            
            return false
        }
        
        if (maxCharactersValidation == false) {
            let title = NSLocalizedString("Maximum 8000 characters limit.", comment: "")
            let messageFormat = String(format: "You have written %ld characters. Remove some words.", self.characterCount)
            let message = NSLocalizedString(messageFormat, comment: "")
            
            self.presentAlertControllerWithOkButton(title: title, message: message)
            
            return false
        }
        
        return true
    }
    
    private func validateNewLetterDataForMinCharacters() -> Bool {
        
        // Check the user has written something in the textView after the default text.
        if let cell = self.tableView.cellForRow(at: self.indexPathOfCellInWritingMode) as? WriteLetterTableViewCell {
            
            self.characterCount = cell.letterTextView.text.characters.count
            
            return (cell.letterTextView.text.characters.count >= 120)
        }
        
        return false
    }
    
    private func validateNewLetterDataForMaxCharacters() -> Bool {
        
        // Check the user has written something in the textView after the default text.
        if let cell = self.tableView.cellForRow(at: self.indexPathOfCellInWritingMode) as? WriteLetterTableViewCell {
            
            self.characterCount = cell.letterTextView.text.characters.count
            
            return (cell.letterTextView.text.characters.count <= 8000)
        }
        
        return false
    }
}
