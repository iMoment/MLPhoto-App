//
//  CameraViewController.swift
//  MLPhoto
//
//  Created by Stanley Pan on 28/09/2017.
//  Copyright © 2017 Stanley Pan. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {
    
    //  MARK: Outlets
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var roundedContainerView: RoundedShadowView!
    @IBOutlet weak var identificationLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var flashButton: RoundedShadowButton!
    @IBOutlet weak var snapshotImageView: RoundedShadowImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
