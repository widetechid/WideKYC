//
//  LocalRequest.swift
//  sdkDemo
//
//  Created by Wide Technologies Indonesia, PT on 24/03/22.
//

import UIKit
import Foundation

class LocalRequest : NSObject{
    
    public func request(with url: URL?, bodyDic Parameters: [String: Any]?, completionHandler: @escaping (_ data: NSDictionary?, _ error: NSError?)  -> Void) {
        var request: NSMutableURLRequest? = nil
        if let url = url {
            request = NSMutableURLRequest(url: url)
        }

        let jsonBody = try? JSONSerialization.data(withJSONObject: Parameters as Any, options: .prettyPrinted)
        request?.httpMethod = "POST"
        request?.httpBody = jsonBody
        request?.setValue("application/json", forHTTPHeaderField: "Content-type")

       let session = URLSession.shared
        
        
        let dataTask = session.dataTask(with: request! as URLRequest) { [self] datas, response, error in
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 200 {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: datas!, options: []) as? NSDictionary
                    {
                        completionHandler(jsonResult, nil)
                     }
                   } catch let error as NSError {
                       DispatchQueue.main.async {
                           let alert = UIAlertController(title: "Warning", message: String(format: "%@", error.localizedDescription), preferredStyle: UIAlertController.Style.alert)
                           let alertOk = UIAlertAction(title: "ok", style: .default, handler: { action in

                           })
                           alert.addAction(alertOk)
                           UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true)
                       }
                }
            }
            else{
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Warning", message: "Network Error", preferredStyle: UIAlertController.Style.alert)
                    let alertOk = UIAlertAction(title: "ok", style: .default, handler: { action in

                    })
                    alert.addAction(alertOk)
                    UIApplication.shared.windows.last?.rootViewController?.present(alert, animated: true)
                }
            }
        }
        dataTask.resume()
    }
}
