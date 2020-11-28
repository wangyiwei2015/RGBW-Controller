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
            let w = lightComp[0] > 0.05 ? lightComp[0] : 0.05
            let r = lightComp[1]
            let g = lightComp[2]
            let b = lightComp[3]
            let lumMax = w + (r+g+b) / 3
            let lum = sqrt(CGFloat(1)-(2-lumMax)*(2-lumMax)*0.25)
//            let l2 = lumMax * lumMax
//            let l3 = l2 * lumMax
//            let l4 = l3 * lumMax
//            let lum = l4/16-l3/2+l2+0.25
            let pMax = lightComp.dropFirst().max()! + w/3
            let rp = (w/3 + r) / pMax * lum
            let gp = (w/3 + g) / pMax * lum
            let bp = (w/3 + b) / pMax * lum
            addedLight.backgroundColor = UIColor(
                red: rp, green: gp, blue: bp,
                alpha: 1)
        }
    }
    var lastComp: [CGFloat] = [0,0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlField.delegate = self
        leds = [whiteLED,redLED,greenLED,blueLED]
        labels = [txtw,txtr,txtg,txtb]
        for label in labels {
            label.text = "0"
        }
        for led in leds {
            led.layer.cornerRadius = led.bounds.height / 2.3
        }
        addedLight.layer.cornerRadius = addedLight.bounds.height/2.33
        addedLight.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        addedLight.backgroundColor = .black
        hyperView.transform = CGAffineTransform(rotationAngle: .pi / 4)
        lightComp = [0,0,0,0]
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        leds[sender.tag].alpha = CGFloat(sender.value/255*0.8+0.2)
        lightComp[sender.tag] = CGFloat(sender.value/255)
        labels[sender.tag].text = "\(Int(sender.value))"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlRoot = validateURL(textField.text ?? "http://192.168.1.1/")
        textField.resignFirstResponder()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[self]_ in
            if lastComp != lightComp {
                lastComp = lightComp
                setLED(UInt8(lightComp[0] * 255),
                       UInt8(lightComp[1] * 255),
                       UInt8(lightComp[2] * 255),
                       UInt8(lightComp[3] * 255))
            }
        })
        return true
    }
    
    func validateURL(_ input: String) -> URL {
        URL(string: input)!
    }
    
    func setLED(_ w: UInt8, _ r: UInt8, _ g: UInt8, _ b: UInt8) {
        invoke("set?\(r)_\(g)_\(b)_\(w)")
    }
    
    func invoke(_ cmd: String) {
        URLSession.shared.dataTask(with: URL(string: "\(urlRoot.absoluteString)\(cmd)")!).resume()
    }
}

