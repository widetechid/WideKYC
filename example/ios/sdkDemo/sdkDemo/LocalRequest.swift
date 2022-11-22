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
        let dataTask = session.dataTask(with: request! as URLRequest) { datas, response, error in
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 200 {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: datas!, options: []) as? NSDictionary
                    {
                        completionHandler(jsonResult, nil)
                     }
                   } catch let error as NSError {
                       completionHandler(nil, error)
                }
            }
            else{
                let error = NSError(domain: "Warning", code: 400, userInfo: [NSLocalizedDescriptionKey: "Network Error"])
                completionHandler(nil,error)
            }
        }
        dataTask.resume()
    }
}


//{
//  "general": {
//    "color": {
//      "title_bar_color": "#000000",
//      "title_text_color": "#5582ad",
//      "title_button_color": "#5582ad",
//      "liveness_instruction_color": "#5582ad",
//      "id_recognize_instruction_color": "#ffffff",
//      "id_validation_label_color": "#000000",
//      "id_validation_button_color": "#000000",
//      "id_validation_button_text_color": "#ffffff",
//      "kk_recognize_instruction_color": "#ffffff",
//      "passport_recognize_instruction_color": "#ffffff",
//      "error_popup_text_color": "#000000",
//      "error_popup_button_text_color": "#000000"
//    },
//    "image": {
//      "title_bar_back": "img_back.png",
//      "title_bar_flash_active": "img_flash_active.png",
//      "title_bar_flash_inactive": "img_flash_inactive.png"
//    }
//  },
//  "lang": {
//    "en": {
//      "liveness_title": "Liveness Detection",
//      "liveness_instruction": "Position your face in the middle",
//      "liveness_instruction_cont": "Stay still",
//      "liveness_anti_spoof_error_msg" : "Image cannot be processed.\nMake sure your face is lit evenly and try again.",
//      "liveness_brightness_error_msg": "Face cannot be seen clearly.\nMake sure you have enough light and try again.",
//      "liveness_error_msg": "Face cannot be seen clearly.\nMake sure you have enough light and please try again.",
//      "id_recognize_title": "ID Recognize",
//      "id_recognize_instruction": "Position your ID Card in the frame provided, \n and make sure the contents is clearly visible.",
//      "id_recognize_error_msg": "It is not a proper E-KTP image,\nplease try again.",
//      "id_recognize_error_copied_msg": "Copied E-KTP is not acceptable,\nplease try again.",
//      "id_validation_title": "ID Validation",
//      "id_validation_nik": "NIK",
//      "id_validation_name": "Name",
//      "id_validation_birthdate": "Birthdate",
//      "id_validation_birthplace": "Birthplace",
//      "id_validation_address": "Address",
//      "id_validation_selfie": "Selfie",
//      "id_validation_button_selfie": "Take",
//      "id_validation_button_send_data": "Send Data",
//      "passport_recognize_title" : "Passport Recognize",
//      "passport_recognize_instruction" : "Position your Passport in the frame provided, \n and make sure the contents is clearly visible.",
//      "passport_recognize_error_msg" : "It is not a proper Passport image,\n please try again.",
//      "kk_recognize_title" : "Family Card Recognize",
//      "kk_recognize_instruction" : "Position your Family Card in the frame provided, \n and make sure the contents is clearly visible."
//    },
//    "id": {
//      "liveness_title": "Deteksi Keaktifan",
//      "liveness_instruction": "Posisikan wajah Anda di tengah layar",
//      "liveness_instruction_cont": "Tetap diam",
//      "liveness_anti_spoof_error_msg" : "Gambar tidak dapat diproses.\nPastikan wajah Anda tersinari secara merata dan coba lagi.",
//      "liveness_brightness_error_msg": "Wajah tidak dapat terlihat dengan jelas.\nPastikan Anda memiliki cukup cahaya dan coba lagi.",
//      "liveness_error_msg": "Wajah tidak dapat terlihat dengan jelas.\nPastikan Anda memiliki cukup cahaya dan silakan coba lagi.",
//      "id_recognize_title": "Mengenali Identitas",
//      "id_recognize_instruction": "Posisikan KTP Anda di bingkai yang tersedia, \n dan pastikan datanya terlihat jelas.",
//      "id_recognize_error_msg": "Ini bukan gambar E-KTP yang baik,\nsilakan coba lagi.",
//      "id_recognize_error_copied_msg": "Salinan E-KTP tidak dapat diterima,\nsilakan coba lagi.",
//      "id_validation_title": "Validasi Identitas",
//      "id_validation_nik": "NIK",
//      "id_validation_name": "Nama",
//      "id_validation_birthdate": "Tanggal lahir",
//      "id_validation_birthplace": "Tempat lahir",
//      "id_validation_address": "Alamat",
//      "id_validation_selfie": "Selfie",
//      "id_validation_button_selfie": "Ambil",
//      "id_validation_button_send_data": "Kirim Data",
//      "passport_recognize_title" : "Mengenali Paspor",
//      "passport_recognize_instruction" : "Posisikan Paspor Anda di bingkai yang tersedia, \n dan pastikan datanya terlihat jelas.",
//      "passport_recognize_error_msg" : "Ini bukan gambar Paspor yang baik,\nsilakan coba lagi.",
//      "kk_recognize_title" : "Mengenali Kartu Keluarga",
//      "kk_recognize_instruction" : "Posisikan Kartu Keluarga Anda di bingkai yang tersedia, \n dan pastikan datanya terlihat jelas."
//    }
//  }
//}
