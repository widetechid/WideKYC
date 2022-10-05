//
//  ViewController.swift
//  sdkDemo
//
//  Created by H, Alfatkhu on 24/03/22.
//

import UIKit
import Foundation
import SwiftyJSON
import AVFoundation
import SVProgressHUD
import widekyc


class ViewController:UIViewController,  UITextFieldDelegate, delegateProduct {

    @IBOutlet weak var titleApp: UILabel!
    @IBOutlet weak var txtHost: UITextField!
    @IBOutlet weak var txtApi: UITextField!
    @IBOutlet weak var txtProduct: UITextField!
    @IBOutlet weak var lbServiceLevel: UILabel!
    @IBOutlet weak var txtServiceLevel: UITextField!
    @IBOutlet weak var constrainBtnStart: NSLayoutConstraint!
    
    var wkyc = WKYC()
    var wkycConfig = WKYCConfig()
    var wkycid = WKYCID()
    var clientConfig = ClientConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        txtHost.delegate = self
        txtApi.delegate = self
        txtProduct.delegate = self
        txtServiceLevel.delegate = self

        titleApp.text = "Demo"

        txtHost.text = "http://34.101.86.149:8081"
        txtApi.text = "/initMerchant"
        txtProduct.text = WKYCConstants.PASSIVE_LIVENESS
        
        txtHost.textColor = .gray
        txtApi.textColor = .gray
        txtProduct.textColor = .gray
        txtServiceLevel.textColor = .gray
        
        if txtProduct.text == WKYCConstants.PASSIVE_LIVENESS{
            constrainBtnStart.constant = 114
            lbServiceLevel.isHidden = false
            txtServiceLevel.isHidden = false
            txtServiceLevel.text = "62000"
        }
        else{
            constrainBtnStart.constant = 20
            lbServiceLevel.isHidden = true
            txtServiceLevel.isHidden = true
        }

        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        txtProduct.addTarget(self, action: #selector(myTargetFunction), for: .touchDown)
        txtServiceLevel.addTarget(self, action: #selector(clickServiceLevel), for: .touchDown)
        
    }
    
    @objc func clickServiceLevel(textField: UITextField) {
        if(textField == txtServiceLevel){
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
   @objc func dismissKeyboard() {
        txtServiceLevel.resignFirstResponder()
        view.endEditing(true)
    }
    
    func updateLayout(productChoice : String){
        if txtProduct.text == WKYCConstants.PASSIVE_LIVENESS{
            constrainBtnStart.constant = 114
            lbServiceLevel.isHidden = false
            txtServiceLevel.isHidden = false
            txtServiceLevel.text = "62000" //WKYCConstants.SL_PASSIVE_LIVENESS_MED
        }
        else if txtProduct.text == WKYCConstants.ID_VALIDATION{
            constrainBtnStart.constant = 114
            lbServiceLevel.isHidden = false
            txtServiceLevel.isHidden = false
            txtServiceLevel.text = WKYCConstants.SL_ID_VALIDATION_UI
        }
        else if txtProduct.text == WKYCConstants.ID_RECOGNIZE{
            constrainBtnStart.constant = 114
            lbServiceLevel.isHidden = false
            txtServiceLevel.isHidden = false
            txtServiceLevel.text = "62010" //WKYCConstants.SL_ID_RECOGNIZE_ENT
        }
        else if txtProduct.text == WKYCConstants.PASSPORT_RECOGNIZE{
            constrainBtnStart.constant = 114
            lbServiceLevel.isHidden = false
            txtServiceLevel.isHidden = false
            txtServiceLevel.text = WKYCConstants.SL_PASSPORT_RECOGNIZE_MED
        }
        else{
            constrainBtnStart.constant = 20
            lbServiceLevel.isHidden = true
            txtServiceLevel.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == txtHost || textField == txtApi || textField == txtServiceLevel{
            textField.resignFirstResponder()
            return true
        }
        
        return false
    }
    
    @objc func myTargetFunction(textField: UITextField) {
        if(textField == txtProduct){
            self.performSegue(withIdentifier: "GoProduct", sender: self)
        }
    }

    @IBAction func btnStart(_ sender: Any) {
        loadingShow()
        if (txtProduct.text == "03" || txtProduct.text == "04") {
            wkycConfig.product = txtProduct.text
            if (txtProduct.text == "04") {
                wkycConfig.serviceLevel = txtServiceLevel.text
            }

            let request = WKYCRequest()
            request.wkycConfig = wkycConfig
            
            let dictJson = NSMutableDictionary()
            dictJson[WKYCConstants.LOCALE] = WKYCConstants.LANG_EN
            dictJson[WKYCConstants.UI_CONFIG_PATH] = "config.json"
            clientConfig.clientConfig = dictJson
            request.clientConfig = clientConfig
            request.wkycID = wkycid
            
            let requestData = NSMutableDictionary()

            loadingDismis()
            
            do {
                try WKYC.sharedInstance.start(request: request,
                    completeCallback: { [self] value in
                        if value.status == "Error"{
                           showAlertMessage(vc: self, titleStr: "Warning", messageStr: String(format: "%@", value.message!))
                        }
                        else{
                            let urlStr = txtProduct.text == "03" ? "http://10.240.39.120:5002/v1/extract-kk" : "http://10.240.39.120:5002/v1/extract-passport"
                            
                            let Url = URL(string: urlStr)

                            do {
                                let params = value.data["params"] as? String ?? ""
                                let data = Data(params.utf8)
                                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                                    let base64Image: String
                                    if txtProduct.text == "03" {
                                        base64Image = jsonResult.object(forKey: WKYCConstants.KK_IMAGE) as! String
                                    }else {
                                        base64Image = jsonResult.object(forKey: WKYCConstants.PASSPORT_IMAGE) as! String
                                    }
                                    requestData.setValue(base64Image, forKey: "img")
                                 }
                            } catch let error as NSError {
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "Warning", message: String(format: "%@", error.localizedDescription), preferredStyle: UIAlertController.Style.alert)
                                    let alertOk = UIAlertAction(title: "Ok", style: .default, handler: { action in
                                    })
                                    alert.addAction(alertOk)
                                    UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true)
                                }
                            }
                            
                            LocalRequest().request(with: Url, bodyDic: (requestData as! [String : Any]), completionHandler: {[self] result, error  in
                                    if result?.count != 0{
                                        DispatchQueue.main.async { [self] in
                                            showAlertMessage(vc: self, titleStr: "Result", messageStr: String(format: "%@", result!))
                                        }
                                    }
                                    else{
                                        DispatchQueue.main.async { [self] in
                                            showAlertMessage(vc: self, titleStr: "Warning", messageStr: error!.localizedDescription)
                                        }
                                    }
                                })
                            }
                    }
                    , interruptCallback: { value in
                        DispatchQueue.main.async { [self] in
                            showAlertMessage(vc: self, titleStr: "Warning", messageStr: String(format: "%@", value.message!))
                        }
                    }
                    , cancelCallback: { value in
                        DispatchQueue.main.async { [self] in
                            showAlertMessage(vc: self, titleStr: "Warning", messageStr: String(format: "%@", value.message!))
                        }
                    }
                )
              } catch let e {
                  showAlertMessage(vc: self, titleStr: "Warning", messageStr: String(format: "%@", e.localizedDescription))
              }
        }else {
            self.mockInitRequest(completion: { [self] result, error  in
                if result!.count == 0{
                    DispatchQueue.main.async { [self] in
                       showAlertMessage(vc: self, titleStr: "Warning", messageStr: "network exception, please try again")
                    }
                }
                else{
                    let resultJson = result!.object(forKey: "statusCode") as? String ?? ""
                    if resultJson == "ERROR"{
                        DispatchQueue.main.async { [self] in
                            showAlertMessage(vc: self, titleStr: "Warning", messageStr: "Service Error")
                        }
                    }
                    else{
                        /**
                        * You need to provide WKYCID for product 02 with service level 62021 to work
                        */

                        wkycid.nik = "3203012503770011"
                        wkycid.name = "Guohui Chen"
                        wkycid.birthdate = "25-03-1977"
                        wkycid.birthplace = "Fujian"
                        wkycid.address = "Jl Selamet, Perumahan Rancabali"


                        let dict = result!.object(forKey: "content") as? NSDictionary ?? [:]
                        wkycConfig.trxId = dict.object(forKey: "trxId") as? String
                        wkycConfig.product = dict.object(forKey: "product") as? String
                        wkycConfig.gatewayUrl = dict.object(forKey: "gatewayUrl") as? String
                        wkycConfig.serviceLevel = dict.object(forKey: "serviceLevel") as? String


                        let request = WKYCRequest()
                        request.wkycConfig = wkycConfig
                        let dictJson = NSMutableDictionary()
                        dictJson[WKYCConstants.LOCALE] = WKYCConstants.LANG_EN
                        dictJson[WKYCConstants.UI_CONFIG_PATH] = "config.json"
                        clientConfig.clientConfig = dictJson
                        request.clientConfig = clientConfig
                        request.wkycID = wkycid


                         do {
                             try  WKYC.sharedInstance.start(request: request,
                                completeCallback: { [self]value in
                                    if value.status == "Error"{
                                        showAlertMessage(vc: self, titleStr: "Warning", messageStr: String(format: "%@", value.message!))
                                    }
                                    else{
                                        /**
                                         * this is how to get processed image from product 00 & 01
                                         * image will be send only onCompleted callback
                                         * String imagePath = response.data.getString("WKYCConstants.PROCESSED_IMAGE_PATH");
                                         * String imageBase64 = getBase64FromPath(imagePath);
                                         */
                                        let Url = URL(string: String(format: "%@", wkycConfig.gatewayUrl!))

                                        print("value:",value.data)

                                                LocalRequest().request(with: Url, bodyDic: value.data, completionHandler: {[self] result, error  in
                                                     if result?.count != 0{
                                                         print("result:",result as Any)
                                                         let content = result!.object(forKey: "content") as? NSDictionary ?? [:]
                                                         let trxId = content.object(forKey: WKYCConstants.TRX_ID) as? String ?? ""

                                                         DispatchQueue.main.async { [self] in
                                                             checkResultWithId(transactionId: trxId)
                                                        }
                                                     }
                                                    else{
                                                        DispatchQueue.main.async { [self] in
                                                            showAlertMessage(vc: self, titleStr: "Warning", messageStr: error!.localizedDescription)
                                                        }
                                                    }
                                                  })
                                       }
                                    }
                                     , interruptCallback: { value in
                                 DispatchQueue.main.async { [self] in
                                                showAlertMessage(vc: self, titleStr: "Warning", messageStr: String(format: "%@", value.message!))
                                            }
                                    }
                                     , cancelCallback: { value in
                                 DispatchQueue.main.async { [self] in
                                            showAlertMessage(vc: self, titleStr: "Warning", messageStr: String(format: "%@", value.message!))
                                        }
                                    }
                                )
                           } catch let e {
                               showAlertMessage(vc: self, titleStr: "Warning", messageStr: String(format: "%@", e.localizedDescription))
                           }
                    }
                }
            })
        }
    }
    
    func checkResultWithId(transactionId : String){
        let Url = URL(string: String(format: "%@%@", txtHost.text!,  "/checkResult"))
        let _paramDicCheckResult = [
            WKYCConstants.TRX_ID : transactionId,
        ] as [String:Any]
        
        print("_paramDicCheckResult:",_paramDicCheckResult)
        
        LocalRequest().request(with: Url, bodyDic: _paramDicCheckResult, completionHandler: { [self] result, error  in
                 if result?.count != 0{
                     if(wkycConfig.product == "01"){
                         DispatchQueue.main.async { [self] in
                                 showAlertMessage(vc: self, titleStr: "Result", messageStr: String(format: "%@", result!))
                             }
                        }
                         else{
                             DispatchQueue.main.async { [self] in
                                 showAlertMessage(vc: self, titleStr: "Result", messageStr: String(format: "%@", result!))
                             }
                         }
                     loadingDismis()
                 }
                else{
                    loadingDismis()
                    DispatchQueue.main.async { [self] in
                        showAlertMessage(vc: self, titleStr: "Warning", messageStr: error!.localizedDescription)
                    }
                }
            })
    }
    
    func mockInitRequest(completion: @escaping (NSDictionary?, NSError?) -> Void) {  // <- HERE
        // This async call will be thrown onto a thread and then this function will return immediately
            let Url = URL(string: String(format: "%@%@", txtHost.text!, txtApi.text!))
        
            let json = JSON(wkyc.getMetaInfo())
            let metaInfo = String(data: try! JSONEncoder().encode(json), encoding: .utf8)
        
        
             let _paramDic = [
                WKYCConstants.META_INFO: metaInfo as Any,
//                "{\"osVersion\":\"15.5\",\"deviceId\":\"1973BC92-EA55-46D8-B8AE-E79B82FC1F60\",\"deviceModel\":\"Assalamua’laikum ughtie !\",\"appName\":\"com.wide.wide_wallet\",\"appVersion\":\"1.0.0\",\"deviceType\":\"ios\"}",
                WKYCConstants.PRODUCT: txtProduct.text!,
                WKYCConstants.SERVICE_LEVEL : txtServiceLevel.text!
             ] as [String: AnyObject]
        
        print("params",_paramDic)
        
        LocalRequest().request(with: Url, bodyDic: _paramDic, completionHandler: {[self] result, error  in
                 loadingDismis()
                 if result?.count != 0{
                     completion(result!, nil)
                 }
                else{
                    completion(nil, error!)
                }
              })
    }

    func ResultDelegate(dictData: NSDictionary) {
        showAlertMessage(vc: self, titleStr: "Warning", messageStr: String(format: "%@", dictData))
    }

    func ProductDelegate(str: String) {
        txtProduct.text = ""
        txtProduct.text = str
        
        updateLayout(productChoice: txtProduct.text!)
    }
    
    private func getBase64FromPath(_ fullPath: String!) -> String! {
           let urlPath = URL(string: fullPath)
           let imageData:NSData = NSData(contentsOf: urlPath!)!
           let image = UIImage(data: imageData as Data)
            
           let imageDatas: Data = image!.jpegData(compressionQuality: 0.4) ?? Data()
           let encodedImage: String = imageDatas.base64EncodedString()
           return encodedImage
    }
    
    
    func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let alertOk = UIAlertAction(title: "Ok", style: .default, handler: { action in

        })
        alert.addAction(alertOk)
        vc.present(alert, animated: true, completion: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "GoProduct" :
            let popUpViewController:popUpProduct = segue.destination as! popUpProduct
            popUpViewController.delegateProduct = self
            break;
        default:
            break;
        }
    }
}

