//
//  CameraViewController.swift
//  MLPhoto
//
//  Created by Stanley Pan on 28/09/2017.
//  Copyright © 2017 Stanley Pan. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    //  MARK: Variables
    var captureSession: AVCaptureSession!
    var captureOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    //  MARK: Outlets
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var roundedContainerView: RoundedShadowView!
    @IBOutlet weak var identificationLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var flashButton: RoundedShadowButton!
    @IBOutlet weak var snapshotImageView: RoundedShadowImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.captureSession = AVCaptureSession()
        self.captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        
        let backgroundCamera = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            let input = try AVCaptureDeviceInput(device: backgroundCamera!)
            if captureSession.canAddInput(input) == true {
                captureSession.addInput(input)
            }
            
            self.captureOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddOutput(captureOutput) == true {
                captureSession.addOutput(captureOutput!)
                
                self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                self.previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                
                self.cameraView.layer.addSublayer(previewLayer!)
                self.captureSession.startRunning()
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.previewLayer.frame = self.cameraView.bounds
    }
}






























