//
//  DemoViewController.swift
//  sdkDemo
//
//  Created by Wide Technologies Indonesia, PT on 26/10/22.
//

import UIKit
import Foundation
import SwiftyJSON
import AVFoundation
import SVProgressHUD
import widekyc


class DemoViewController:UIViewController, UITextFieldDelegate, delegateProduct {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var apiTextField: UITextField!
    @IBOutlet weak var productOption: UITextView!
    @IBOutlet weak var serviceLevelLabel: UILabel!
    @IBOutlet weak var serviceLevelTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startButtonTopConstraint: NSLayoutConstraint!
    
    var wkyc = WKYC()
    var wkycConfig = WKYCConfig()
    var wkycid = WKYCID()
    var clientConfig = ClientConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostTextField.text = UserDefaults.standard.string(forKey: "host_url") ?? "http://[host_url]:[host_port]/"
        hostTextField.placeholder = "host_url"
        hostTextField.delegate = self
        hostTextField.tag = 1
        hostTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        apiTextField.text = UserDefaults.standard.string(forKey: "api_name") ?? "[api_name]"
        apiTextField.placeholder = "api_name"
        apiTextField.delegate = self
        apiTextField.tag = 2
        apiTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        serviceLevelTextField.delegate = self

        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        
        productOption.text = WKYCConstants.PASSIVE_LIVENESS
        productOption.textContainer.maximumNumberOfLines = 1
        productOption.layer.borderWidth = 0.5
        productOption.layer.borderColor = borderColor.cgColor
        productOption.layer.cornerRadius = 5.0
        productOption.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseProduct)))

        serviceLevelTextField.text = WKYCConstants.SL_PASSIVE_LIVENESS_MED
        
        startButton.layer.cornerRadius = 5.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if var keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardFrame = self.view.convert(keyboardFrame, from: nil)

            var contentInset:UIEdgeInsets = scrollView.contentInset
            contentInset.bottom = keyboardFrame.size.height
            scrollView.contentInset = contentInset
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func textFieldDidChange(_ textField:UITextField){
        if textField.tag == 1 {
            UserDefaults.standard.set(textField.text, forKey: "host_url")
        }else if textField.tag == 2 {
            UserDefaults.standard.set(textField.text, forKey: "api_name")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func chooseProduct() {
        self.performSegue(withIdentifier: "GoProduct", sender: self)
    }
    
    @IBAction func startAction(_ sender: Any) {
        loadingShow()
        self.mockInitRequest(completion: { [self] result, error  in
            if result?.count == 0 || result == nil {
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
                                    DispatchQueue.main.async { [self] in
                                        showAlertMessage(vc: self, titleStr: "Warning", messageStr: String(format: "%@", value.message!))
                                    }
                                }
                                else{
                                    /**
                                     * this is how to get processed image from product 00 & 01
                                     * image will be send only onCompleted callback
                                     * String imagePath = response.data.getString("WKYCConstants.PROCESSED_IMAGE_PATH");
                                     * String imageBase64 = getBase64FromPath(imagePath);
                                     */
                                    
                                    let Url = URL(string: String(format: "%@", wkycConfig.gatewayUrl!))

                                    LocalRequest().request(with: Url, bodyDic: value.data, completionHandler: {[self] result, error  in
                                        if result?.count != 0 {
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
                        DispatchQueue.main.async { [self] in
                            showAlertMessage(vc: self, titleStr: "Warning", messageStr: String(format: "%@", e.localizedDescription))
                        }
                    }
                }
            }
        })
    }
    
    func updateLayout(productChoice : String){
        if productOption.text == WKYCConstants.PASSIVE_LIVENESS{
            startButtonTopConstraint.constant = 127.5
            serviceLevelLabel.isHidden = false
            serviceLevelTextField.isHidden = false
            serviceLevelTextField.text = WKYCConstants.SL_PASSIVE_LIVENESS_MED
        }
        else if productOption.text == WKYCConstants.ID_RECOGNIZE{
            startButtonTopConstraint.constant = 127.5
            serviceLevelLabel.isHidden = false
            serviceLevelTextField.isHidden = false
            serviceLevelTextField.text = WKYCConstants.SL_ID_RECOGNIZE_ENT
        }
        else if productOption.text == WKYCConstants.ID_VALIDATION{
            startButtonTopConstraint.constant = 127.5
            serviceLevelLabel.isHidden = false
            serviceLevelTextField.isHidden = false
            serviceLevelTextField.text = WKYCConstants.SL_ID_VALIDATION_UI
        }
        else if productOption.text == WKYCConstants.PASSPORT_RECOGNIZE{
            startButtonTopConstraint.constant = 127.5
            serviceLevelLabel.isHidden = false
            serviceLevelTextField.isHidden = false
            serviceLevelTextField.text = WKYCConstants.SL_PASSPORT_RECOGNIZE_ENT
        }
        else if productOption.text == WKYCConstants.KK_RECOGNIZE{
            startButtonTopConstraint.constant = 127.5
            serviceLevelLabel.isHidden = false
            serviceLevelTextField.isHidden = false
            serviceLevelTextField.text = WKYCConstants.SL_KK_RECOGNIZE_ENT
        }
        else{
            startButtonTopConstraint.constant = 30
            serviceLevelLabel.isHidden = true
            serviceLevelTextField.isHidden = true
        }
        
    }
    
    func checkResultWithId(transactionId : String){
        let Url = URL(string: String(format: "%@%@", hostTextField.text!,  "checkResult"))
        let _paramDicCheckResult = [ WKYCConstants.TRX_ID : transactionId, ] as [String:Any]
        
        print("_paramDicCheckResult:",_paramDicCheckResult)
        
        LocalRequest().request(with: Url, bodyDic: _paramDicCheckResult, completionHandler: { [self] result, error  in
            loadingDismis()
            if result?.count != 0 && result != nil {
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
            }
            else{
                DispatchQueue.main.async { [self] in
                    showAlertMessage(vc: self, titleStr: "Warning", messageStr: error!.localizedDescription)
                }
            }
        })
    }
    
    func mockInitRequest(completion: @escaping (NSDictionary?, NSError?) -> Void) {
        let Url = URL(string: String(format: "%@%@", hostTextField.text!, apiTextField.text!))
        
        let json = JSON(wkyc.getMetaInfo())
        let metaInfo = String(data: try! JSONEncoder().encode(json), encoding: .utf8)
        
        let _paramDic = [ WKYCConstants.META_INFO: metaInfo as Any,
                          WKYCConstants.PRODUCT: productOption.text!,
                          WKYCConstants.SERVICE_LEVEL : serviceLevelTextField.text! ] as [String: AnyObject]
        
        print("params",_paramDic)
        LocalRequest().request(with: Url, bodyDic: _paramDic, completionHandler: {[self] result, error  in
            DispatchQueue.main.async {
                self.loadingDismis()
                if result?.count != 0 && result != nil {
                    completion(result, nil)
                }
                else{
                    completion(nil, error!)
                }
            }
        })
    }

    func ResultDelegate(dictData: NSDictionary) {
        showAlertMessage(vc: self, titleStr: "Warning", messageStr: String(format: "%@", dictData))
    }

    func ProductDelegate(str: String) {
        productOption.text = str
        updateLayout(productChoice: productOption.text!)
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
        let alert = UIAlertController(title: titleStr , message: messageStr, preferredStyle: UIAlertController.Style.alert)
        let alertOk = UIAlertAction(title: "Ok", style: .default, handler: { action in

        })
        alert.addAction(alertOk)
        vc.present(alert, animated: true, completion: nil)
    }
    
    func loadingShow(){
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setBackgroundColor(.gray)
        SVProgressHUD.show()
    }

    func loadingDismis(){
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(.white)
        SVProgressHUD.setBackgroundColor(.gray)
        SVProgressHUD.dismiss()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "GoProduct" :
            let productOptionViewController:ProductOptionViewController = segue.destination as! ProductOptionViewController
            productOptionViewController.delegateProduct = self
            break;
        default:
            break;
        }
    }
}
