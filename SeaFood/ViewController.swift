//
//  ViewController.swift
//  SeaFood
//
//  Created by MilyMozz on 04/10/2018.
//  Copyright © 2018 mozzDev. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePikcer = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imagePikcer.delegate = self
        imagePikcer.sourceType = .camera
//        imagePikcer.sourceType = .photoLibrary
        imagePikcer.allowsEditing = false
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            
            detect(image: ciimage)
            
        }
        
        imagePikcer.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            
            print(result)
            
            if let firstResult = result.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                } else {
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePikcer, animated: true, completion: nil)
        
    }
    
    

}

