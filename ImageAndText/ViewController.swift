//
//  ViewController.swift
//  ImageAndText
//
//  Created by Furkan on 19.06.2020.
//  Copyright © 2020 x-swift. All rights reserved.
//

import UIKit
import YPImagePicker

var myImage = UIImage()
class ViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func addButton(_ sender: Any) {
        
        var config = YPImagePickerConfiguration()
        
        config.library.onlySquare = false
        config.onlySquareImagesFromCamera = false
        config.library.isSquareByDefault = true
        config.shouldSaveNewPicturesToAlbum = false
        config.screens = [.library]
        config.showsPhotoFilters = false
        config.maxCameraZoomFactor = 0.0
        let picker = YPImagePicker(configuration: config)
        
        
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                myImage = photo.image
                
                self.imageView.image = myImage
                
                
                
            }
            picker.dismiss(animated: true, completion: nil)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondID")
            
            self.show(vc!, sender: self)
        }
        present(picker, animated: true, completion: nil)
    }
    
    
    
    
}



