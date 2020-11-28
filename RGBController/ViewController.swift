//
//  ViewController.swift
//  RGBController
//
//  Created by Wangyiwei on 2020/11/27.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var hyperView: UIView!
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
    @IBOutlet weak var addedLight: UIView!
    
    var urlRoot: URL!
    var timer: Timer?
    var lightComp: [CGFloat] = [0,0,0,0] {
        didSet {
            addedLight.backgroundColor = UIColor(
                red: lightComp[1]*0.8 + lightComp[0]*0.2,
                green: lightComp[2]*0.8 + lightComp[0]*0.2,
                blue: lightComp[3]*0.8 + lightComp[0]*0.2,
                alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlField.delegate = self
        leds = [whiteLED,redLED,greenLED,blueLED]
        labels = [txtw,txtr,txtg,txtb]
        for label in labels {
            label.text = "0"
        }
        for led in leds {
            led.layer.cornerRadius = led.bounds.height / 5
        }
        addedLight.layer.cornerRadius = addedLight.bounds.height/2.3
        //addedLight.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        addedLight.backgroundColor = .black
        hyperView.transform = CGAffineTransform(rotationAngle: .pi / 4)
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        leds[sender.tag].alpha = CGFloat(sender.value/255*0.8+0.2)
        lightComp[sender.tag] = CGFloat(sender.value/255)
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

