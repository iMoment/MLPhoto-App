//
//  CameraViewController.swift
//  MLPhoto
//
//  Created by Stanley Pan on 28/09/2017.
//  Copyright © 2017 Stanley Pan. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

enum FlashState {
    case off
    case on
}

class CameraViewController: UIViewController {
    
    //  MARK: Variables
    var captureSession: AVCaptureSession!
    var captureOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoData: Data?
    var flashControlState = FlashState.off
    
    //  MARK: Outlets
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var roundedContainerView: RoundedShadowView!
    @IBOutlet weak var identificationLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var flashButton: RoundedShadowButton!
    @IBOutlet weak var snapshotImageView: RoundedShadowImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView(_:)))
        tapGesture.numberOfTapsRequired = 1
        
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
                self.cameraView.addGestureRecognizer(tapGesture)
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
    
    @objc func didTapCameraView(_ tapGesture: UITapGestureRecognizer) {
        let settings = AVCapturePhotoSettings()
        settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
        
        if flashControlState == .off {
            settings.flashMode = .off
        } else {
            settings.flashMode = .on
        }
        
        captureOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func resultsMethod(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else { return }
        
        for classification in results {
            if classification.confidence < 0.5 {
                self.identificationLabel.text = "I'm not sure what this is. Please try again."
                self.confidenceLabel.text = ""
                break
            } else {
                self.identificationLabel.text = classification.identifier
                self.confidenceLabel.text = "CONFIDENCE: \(Int(classification.confidence * 100))%"
                break
            }
        }
    }
    
    @IBAction func flashButtonPressed(_ sender: RoundedShadowButton) {
        switch flashControlState {
        case .off:
            flashButton.setTitle("FLASH ON", for: .normal)
            flashControlState = .on
        case .on:
            flashButton.setTitle("FLASH OFF", for: .normal)
            flashControlState = .off
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint(error.localizedDescription)
        } else {
            photoData = photo.fileDataRepresentation()
            
            do {
                let model = try VNCoreMLModel(for: SqueezeNet().model)
                let request = VNCoreMLRequest(model: model, completionHandler: resultsMethod)
                let handler = VNImageRequestHandler(data: photoData!)
                try handler.perform([request])
            } catch {
                debugPrint(error.localizedDescription)
            }
            
            let image = UIImage(data: photoData!)
            self.snapshotImageView.image = image
        }
    }
}




























