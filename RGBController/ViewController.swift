//
//  ViewController.swift
//  RGBController
//
//  Created by Wangyiwei on 2020/11/27.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var whiteLED: UIView!
    @IBOutlet weak var redLED: UIView!
    @IBOutlet weak var greenLED: UIView!
    @IBOutlet weak var blueLED: UIView!
    var leds: [UIView] = []
    @IBOutlet weak var txtw: UILabel!
    @IBOutlet weak var txtr: UILabel!
    @IBOutlet weak var txtg: UILabel!
    @IBOutlet weak var txtb: UILabel!
    var labels: [UILabel] = []
    
    var urlRoot: URL!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlField.delegate = self
        leds = [whiteLED,redLED,greenLED,blueLED]
        for led in leds {
            led.layer.cornerRadius = led.bounds.height / 2.5
        }
        labels = [txtw,txtr,txtg,txtb]
        for label in labels {
            label.text = "0"
        }
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        leds[sender.tag].alpha = CGFloat(sender.value/10002*0.8+0.2)
        labels[sender.tag].text = "\(Int(sender.value))"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlRoot = validateURL(textField.text ?? "http://192.168.1.1")
        textField.resignFirstResponder()
        return true
    }
    
    func validateURL(_ input: String) -> URL {
        URL(string: input)!
    }
    
    func invoke(_ cmd: String) {
        URLSession.shared.dataTask(with: urlRoot.appendingPathComponent(cmd)).resume()
    }
}

