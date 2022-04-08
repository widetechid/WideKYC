//
//  Modal.swift
//  sdkDemo
//
//  Created by H, Alfatkhu on 24/03/22.
//

import UIKit
import Foundation
import SVProgressHUD
import AVFoundation
import Vision

public class ModalAlert: NSObject {
    
    func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let alertOk = UIAlertAction(title: "ok", style: .default, handler: { action in

        })
        alert.addAction(alertOk)
        vc.present(alert, animated: true, completion: nil)
    }
    
    public func visualization(_ image: UIImage, observations: [VNDetectedObjectObservation]) -> UIImage {
        var transform = CGAffineTransform.identity
            .scaledBy(x: 1, y: -1)
            .translatedBy(x: 1, y: -image.size.height)
        transform = transform.scaledBy(x: image.size.width, y: image.size.height)

        UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()

        image.draw(in: CGRect(origin: .zero, size: image.size))
        context?.saveGState()

        context?.setLineWidth(2)
        context?.setLineJoin(CGLineJoin.round)
        context?.setStrokeColor(UIColor.black.cgColor)
        context?.setFillColor(red: 0, green: 1, blue: 0, alpha: 0.3)

        observations.forEach { observation in
            let bounds = observation.boundingBox.applying(transform)
            context?.addRect(bounds)
        }

        context?.drawPath(using: CGPathDrawingMode.fillStroke)
        context?.restoreGState()
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage!
    }
    
    
    func loadingShow(){
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(.white)           //Ring Color
        SVProgressHUD.setBackgroundColor(.gray)
        SVProgressHUD.show()
    }

    func loadingDismis(){
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(.white)           //Ring Color
        SVProgressHUD.setBackgroundColor(.gray)
        SVProgressHUD.dismiss()
    }
}
