//
//  ImageSaver.swift
//  imageFilter2
//
//  Created by Sree on 08/12/21.
//

import UIKit


class ImageSaver: NSObject {
    var successHandler:  (()->Void)?
    var errorHandler:  ((Error)->Void)?

    
    func writeToPhotoAlbum(image: UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage,didfinishSavingWithError error: Error?,contextInfo: UnsafeRawPointer){
        print("Save finished")
        if let error = error {
            errorHandler?(error)
        } else {
          successHandler?()
        }
    }
    
}

