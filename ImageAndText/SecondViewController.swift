//
//  SecondViewController.swift
//  ImageAndText
//
//  Created by Furkan on 19.06.2020.
//  Copyright © 2020 x-swift. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var textData = ""
    
    @IBOutlet weak var showImage: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Size of image
        let imageView: UIImageView = UIImageView(image: myImage)

        let imageViewHeight: CGFloat = imageView.frame.height

        let imageViewWidth: CGFloat = imageView.frame.width
        
        let height = imageViewHeight
        let width = imageViewWidth
        
        print("Height: \(height) \nWidth: \(width)")
        
        showImage.image = myImage
        
        label.isHidden = true
        label.isUserInteractionEnabled = true
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        label.addGestureRecognizer(dragGesture)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        label.isHidden = true
        let newImage = mergeTextAndImage(image: myImage, withLabel: label, outputSize: myImage.size)
        showImage.image = newImage
        UIImageWriteToSavedPhotosAlbum(newImage!, nil, nil, nil)
    }
    
    @IBAction func addButton(_ sender: Any) {
        
        let randomAlert = UIAlertController(title: "Add Text", message: "", preferredStyle: .alert)
        
        randomAlert.addTextField()
        
        let addRandom = UIAlertAction(title: "Add", style: .default) { (action) in
            var randomText = randomAlert.textFields![0]
            
            if randomText.text == "" {
                let alertEror = UIAlertController(title: "Warning", message: "Empty expression cannot be entered", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertEror.addAction(cancel)
            }else{
                self.textData = randomText.text!
                self.label.text = self.textData
                self.label.isHidden = false
            }
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        randomAlert.addAction(addRandom)
        randomAlert.addAction(cancelButton)
        
        present(randomAlert, animated: true, completion: nil)
    }
    
    
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        
        let translation = recognizer.translation(in: self.view)
        
        recognizer.view!.center = CGPoint(x: recognizer.view!.center.x + translation.x, y: recognizer.view!.center.y + translation.y)
        
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
    }
    
    
    
    func mergeTextAndImage(image:UIImage, withLabel label: UILabel, outputSize:CGSize) -> UIImage? {
        let inputSize:CGSize = image.size
        let scale = max(outputSize.width / inputSize.width, outputSize.height / inputSize.height)
        let scaledSize = CGSize(width: inputSize.width * scale, height: inputSize.height * scale)
        let center = CGPoint(x: outputSize.width / 2, y: outputSize.height / 2)
        let outputRect = CGRect(x: center.x - scaledSize.width/2, y: center.y - scaledSize.height/2, width: scaledSize.width, height: scaledSize.height)

        UIGraphicsBeginImageContextWithOptions(outputSize, true, 0.0)

        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.interpolationQuality = CGInterpolationQuality.high
        image.draw(in: outputRect)

        if let text = label.text {
            if text.count > 0 {
               
                var range:NSRange? = NSMakeRange(0, text.count)
                let drawPoint = CGPoint(
                    x: label.frame.origin.x / label.superview!.frame.width * outputSize.width,
                    y: label.frame.origin.y / label.superview!.frame.height * outputSize.height)
                let originalFont = label.font
                print(drawPoint.y)
                label.font = UIFont(name: label.font!.fontName, size: label.font!.pointSize / label.superview!.frame.width * outputSize.width)
                let attributes = label.attributedText?.attributes(at: 0, effectiveRange: &range!)

                let angle = atan2(label.transform.b, label.transform.a)

                context.translateBy(x: drawPoint.x, y: drawPoint.y)
                context.rotate(by: angle)

                text.draw(in: outputRect, withAttributes: attributes)

                label.font = originalFont
            }
        }

        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage
    }
    
        
       

}

