//
//  ProductOptionViewController.swift
//  sdkDemo
//
//  Created by Wide Technologies Indonesia, PT on 24/03/22.
//

import UIKit
import Foundation


class ProductTableViewCell: UITableViewCell{
    @IBOutlet weak var lbProduct: UILabel!
}

public protocol delegateProduct {
    func ProductDelegate (str: String)
}

class ProductOptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var tblProduct: UITableView!
    
    var arrData : [String] = []
    var delegateProduct: delegateProduct?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrData = ["00", "01", "02", "03", "04","05", "06"]
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        tblProduct.delegate = self
        tblProduct.dataSource = self
        tblProduct.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblProduct.dequeueReusableCell(withIdentifier: "cellProduct") as! ProductTableViewCell
        cell.lbProduct.text = arrData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegateProduct?.ProductDelegate(str: arrData[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
