//
//  SixtemiaCameraManager.swift
//  SixtemiaTest
//
//  Created by Kevin Costa on 11/02/2020.
//  Copyright © 2020 Sixtemia Mobile Studio. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices
import Zip

class SixtemiaCameraManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //-----------------------
    // MARK: Variables
    // MARK: ============
    //-----------------------
    
    private var imagePicker: UIImagePickerController?
    var delegate: SixtemiaCameraDelegate?
    var controller: UIViewController?
    
    public static var shared = SixtemiaCameraManager()
    
    //-----------------------
    // MARK: Constants
    // MARK: ============
    //-----------------------
    
    private let MAX_SIZE_IMAGE : CGFloat = 1024.0
    
    //-----------------------
    // MARK: - LIVE APP
    //-----------------------
    
    private override init() {
        super.init()
        imagePicker = UIImagePickerController()
        imagePicker?.modalPresentationStyle = .fullScreen
        imagePicker?.delegate = self
    }
    
    //-----------------------
    // MARK: - METHODS
    //-----------------------
    
    /**
     Funció per mostrar l'alert per escoliir d'on vols agafar les imatges.
     Es comproven els permisos del carret i de la camara
     */
    func addImage() {
        let alert = UIAlertController(
            title: "chooseImageTitle".localized(),
            message: "chooImageDescription".localized(),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "BKO".localized(), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "btnGallery".localized(), style: .default, handler: { _ in
            self.checkPhotoLibraryPermission()
        }))
        alert.addAction(UIAlertAction(title: "btnCamera".localized(), style: .default, handler: { _ in
            self.checkCameraPermission()
        }))
        
        controller?.present(alert, animated: true, completion: nil)
    }
    
    /**
     A partir de l'array d'Strings crear un zip de dades i despres els retorna
     
     - Parameter arrayImg: Array d'Strings amb els noms de les imatges
     */
    func createImgs(arrayImg: [String]) -> AnyObject? {
        var dataReturn: Data?
        
        var tempArray = arrayImg
        tempArray.removeAll(where: { $0 == "" })
        
        if !tempArray.isEmpty {
            dataReturn = Data()
            var urlPaths = [URL]()
            for strUrl in tempArray  {
                
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let photoURL          = NSURL(fileURLWithPath: documentDirectory)
                let localPath         = photoURL.appendingPathComponent(strUrl)
                
                urlPaths.append(localPath!)
                
                // Es redimensionen les imatges
                if FileManager.default.fileExists(atPath: (localPath?.path)!) {
                    let img = UIImage(contentsOfFile: (localPath?.path)!)!
                    var imgResized = img
                    
                    if (img.size.width > img.size.height) {
                        if (img.size.width > MAX_SIZE_IMAGE) {
                            imgResized = self.resizeImage(image: img, newWidth: MAX_SIZE_IMAGE)
                        }
                    } else {
                        if (img.size.height > MAX_SIZE_IMAGE) {
                            imgResized = self.resizeImage(image: img, newHeight: MAX_SIZE_IMAGE)
                        }
                    }
                    if let data = imgResized.jpegData(compressionQuality: 1.0) {
                        try? data.write(to: localPath!)
                    }
                }
            }
            
            var urlZip : URL?
            do {
                urlZip = try Zip.quickZipFiles(urlPaths, fileName: "Images")
            } catch {
                print("ERROR")
            }
            
            if let url = urlZip {
                dataReturn = try! Data(contentsOf: url)
            } else {
                print("Could not parse the file")
            }
        }
        
        return dataReturn == nil ? nil : dataReturn as AnyObject
    }
    
    private func checkPhotoLibraryPermission() {
        DispatchQueue.main.async {
            let status = PHPhotoLibrary.authorizationStatus()
            
            switch status {
            case .authorized:
                self.imagePicker!.allowsEditing = false
                self.imagePicker!.sourceType = .savedPhotosAlbum
                self.imagePicker!.mediaTypes = [kUTTypeImage as String]
                self.imagePicker!.navigationBar.barTintColor = PRIMARY_COLOR
                self.imagePicker!.navigationBar.tintColor = PRIMARY_COLOR
                self.controller?.present(self.imagePicker!, animated: true, completion: nil)
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization() { _ in
                    self.checkPhotoLibraryPermission()
                }
            default:
                self.alertToEncourageAccessInitially(msg: "assetsDeniedPermissionLibrary".localized())
            }
        }
    }
    
    private func checkCameraPermission() {
        DispatchQueue.main.async {
            let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            
            switch authStatus {
            case .authorized:
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker!.allowsEditing = false
                    self.imagePicker!.sourceType = .camera
                    self.imagePicker!.cameraCaptureMode = .photo
                    self.controller?.present(self.imagePicker!, animated: true, completion: nil)
                } else {
                    self.noCamera()
                }
            case .notDetermined:
                if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                    AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                        self.checkCameraPermission()
                    }
                }
            default:
                self.alertToEncourageAccessInitially(msg: "assetsDeniedPermissionCamera".localized())
            }
        }
    }
    
    private func alertToEncourageAccessInitially(msg: String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "BKO".localized(), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "BSETTINGS".localized(), style: .cancel, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        
        controller?.present(alert, animated: true, completion: nil)
    }
    
    private func noCamera(){
        let alertVC = UIAlertController(title: "", message: "msgNoCamera".localized(), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "BOK".localized(), style:.default, handler: nil)
        alertVC.addAction(okAction)
        controller?.present(alertVC, animated: true, completion: nil)
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    private func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //----------------------------------------
    // MARK: - UIImagePickerControllerDelegate
    //----------------------------------------
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image                = info[.originalImage] as! UIImage
        let imageName            = "\(Date().ticks).jpg"
        let documentDirectory    = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let photoURL            = NSURL(fileURLWithPath: documentDirectory)
        let localPath            = photoURL.appendingPathComponent(imageName)
        
        if !FileManager.default.fileExists(atPath: localPath!.path) {
            do {
                try image.jpegData(compressionQuality: 0.75)?.write(to: localPath!)
            } catch {
                print("error saving file")
            }
        } else {
            print("file already exists")
        }
        
        var imgResized = image
        if (image.size.width > image.size.height) {
            if (image.size.width > MAX_SIZE_IMAGE) {
                imgResized = resizeImage(image: image, newWidth: MAX_SIZE_IMAGE)
            }
        } else {
            if (image.size.height > MAX_SIZE_IMAGE) {
                imgResized = resizeImage(image: image, newHeight: MAX_SIZE_IMAGE)
            }
        }
        
        delegate?.didFinishPickingMediaWithInfo(strImgName: imageName)
        delegate?.didFinishPickingMediaWithInfo(uiImage: imgResized)
        
        controller?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        controller?.dismiss(animated: true, completion: nil)
    }
    
}

protocol SixtemiaCameraDelegate {
    
    /**
     Funció del delegate quan s'acaba de seleccionar una imatge i retorna el nom de la imatge seleccionada
     
     - Parameter strImgName: Nom de la imatge que s'ha seleccionat
     */
    func didFinishPickingMediaWithInfo(strImgName: String)
    
    /**
     Funció del delegate quan s'acaba de seleccionar una imatge i retorna el nom de la imatge seleccionada
     
     - Parameter uiImage: Retorna la imatge que s'ha seleccionat
     */
    func didFinishPickingMediaWithInfo(uiImage: UIImage)
    
}
