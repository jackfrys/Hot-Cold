import UIKit

import Foundation
import CoreLocation
import SwiftyBeaver

class ColorViewController: UIViewController, HotColdDelegate {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var warmerOrColder: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var exitButton: UIButton!
    
    let log = SwiftyBeaver.self
    
    override func viewWillAppear(_ animated: Bool) {
        colorView.backgroundColor = UIColor(red: 0.1, green: 0.3, blue: 0.9, alpha: 1.0)
        exitButton.layer.cornerRadius = 10
        
        if ProcessInfo.processInfo.arguments.contains("-UITesting") {
            warmerOrColder.text = "Colder"
        }
        
        if !ProcessInfo.processInfo.arguments.contains("-ColorTweaking") {
            slider.removeFromSuperview()
        }
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        updateUIPrivate(model: HotColdModel())
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showWebpage(url: URL) {
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: {(b) in self.dismiss(animated: true, completion: nil)})
    }
    
    func locationChanged(model: HotColdModel) {
        updateUI(model: model)
    }
    
    private func updateUI(model: HotColdModel) {
        performSelector(onMainThread: #selector(self.updateUIPrivate), with: model, waitUntilDone: false)
    }
    
    private func backgroundColor(rgb: (CGFloat, CGFloat, CGFloat)) -> UIColor {
        return UIColor(red: rgb.0, green: rgb.1, blue: rgb.2, alpha: 1.0)
    }
    
    func gameFinished(model: HotColdModel) {
        let alert = UIAlertController(title: "You Have Arrived!", message: "This is " + model.destinationName(), preferredStyle: UIAlertController.Style.alert)
        log.debug("name: \(model.destinationName())")
        log.debug("link: \(String(describing: model.destinationUrl()))")
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: {(action) in self.dismiss(animated: true, completion: nil)}))
        if let destUrl = model.destinationUrl() {
            alert.addAction(UIAlertAction(title: "View", style: UIAlertAction.Style.default, handler: {(action) in self.showWebpage(url: destUrl)}))
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    func gameFailedToStart(model: HotColdModel) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gameStarted(model: HotColdModel) {
        updateUI(model: model)
        log.debug("Game started.")
    }
    
    @objc private func updateUIPrivate(model: HotColdModel) {
        log.debug("Updating UI.")
        if let text = model.directiveText() {
            log.debug("Directive text exists: " + text)
            warmerOrColder.text = text
        } else {
            warmerOrColder.text = "loading..."
        }
        
        var f : CGFloat?
        if ProcessInfo.processInfo.arguments.contains("-ColorTweaking") {
            f = CGFloat(slider.value)
        }
        if let color = model.backgroundColor(progress: f) {
            colorView.backgroundColor = backgroundColor(rgb: color)
            exitButton.backgroundColor = UIColor(red: 1-color.0, green: 0, blue: 1-color.2, alpha: 1.0)
        }
    }
    
    func noResults(model: HotColdModel) {
        let alert = UIAlertController(title: "No Results", message: "Please adjust your search terms and try again.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: {(action) in self.dismiss(animated: true, completion: nil)}))
        present(alert, animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
