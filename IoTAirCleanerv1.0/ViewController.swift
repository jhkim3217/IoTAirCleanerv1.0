//
//  ViewController.swift
//  IoTAirCleanerv1.0
//
//  Created by amadeus on 2018. 2. 21..
//  Copyright © 2018년 DIT Apps. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var relayOnOff: UISwitch!
    @IBOutlet weak var Tem_Hum: WKWebView!
    @IBOutlet weak var Dust: WKWebView!
    
    var val = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 430 * 280
        Tem_Hum.loadHTMLString("<iframe width=\"430\" height=\"280\" frameborder=\"0\" src=\"https://app.ubidots.com/ubi/getchart/Rnbk17XEMu1Pa78dpi8bDRkaeoM\"></iframe>", baseURL: nil)
        
        Dust.loadHTMLString("<iframe width=\"430\" height=\"280\" frameborder=\"0\" src=\"https://app.ubidots.com/ubi/getchart/5CJcuFrTL4V7hNpFDAvPyhSrkfk\"></iframe>", baseURL: nil)
        
            relayOnOff.isOn = false
        }
    
    
    @IBAction func tapOnSwitch(_ sender: Any) {
        if relayOnOff.isOn {
            operateRealy(val: 1.00)
            
        } else {
            operateRealy(val: 0.00)
        }
    }
    
    
    func operateRealy(val: Double) {
        let parameters = ["value":val]
        
        guard let url = URL(string: "http://things.ubidots.com/api/v1.6/devices/my-data-source/relay/values?token=A1E-TaakPEaDbBeDZAVT8zNoXqvPQfGcAeSpM41PG9n764pPPHjmc9SDA1OM") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }

}

