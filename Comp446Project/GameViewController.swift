//
//  GameViewController.swift
//  Comp446Project
//
//  Created by Austin Hudelson on 11/28/15.
//  Copyright (c) 2015 Austin Hudelson. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var gameScene: PicturePoperGameScene?
    
    
    
//    var pictures: [NSData] {
//        get {
//            if let values = userDataStorage.objectForKey(searchKey) as? [NSData] {
//                return values
//            } else {
//                let r: [String:UIImage] = [String:UIImage]()
//                return r
//            }
//        }
//        set {
//            userDataStorage.setObject(newValue, forKey: searchKey)
//        }
//    }
    
    //MARK user Data Storage for images
    private let userDataStorage = NSUserDefaults.standardUserDefaults()
    private let dataKey = "PicturePoper.Images."    //Image id should be added after
    private func storeImageForPieceID(ID: String, image: UIImage){
        let finalUserDataStorageKey = "\(dataKey)\(ID)"
        let imageData: NSData? = UIImageJPEGRepresentation(image, 0.1)
        if imageData != nil {
            userDataStorage.setObject(imageData!, forKey: finalUserDataStorageKey)
        } else {
            print("ERROR STORING IMAGE DATA")
        }
    }
    
    private func fetchImageForPieceID(ID: String) -> UIImage? {
        let finalFetchKey: String = "\(dataKey)\(ID)"
        if let fetchedData = userDataStorage.objectForKey(finalFetchKey) as? NSData {
            if let fetchedImage: UIImage = UIImage(data: fetchedData) {
                return fetchedImage
            } else {
                print("ERROR CONVERTING STORED DATA TO IMAGE")
            }
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        let scene = PicturePoperGameScene(size: self.view.frame.size)
        self.gameScene = scene
        
        if 1==1 {
            // Configure the view.
            let skView = self.view as! SKView
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = SKSceneScaleMode.ResizeFill
            
            scene.backgroundColor = UIColor.blackColor()
            
            skView.presentScene(scene)
        }
        
        //Load stored images in to the scene
        for index in 0...Piece.typesOfPieces-1 {
            if let storedImage = fetchImageForPieceID(String(index)) {
                gameScene!.setPieceImage(index, image: storedImage)
            }
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    //MARK : imagePicking
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func chooseImage(sender: UIButton) {
        imagePicker.allowsEditing = true //Allow an edited photo
        imagePicker.sourceType = .PhotoLibrary //location of images
        presentViewController(imagePicker, animated: true, completion: nil)//Present the picker
    }
    
    //TODO add buttons for each piece, dont just rotate using setImageNumber
    var setImageNumber = 0
    
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        //Save the image in to the remembered image dictionary
        for index in 0...Piece.typesOfPieces-1 {
            if let storedImage = fetchImageForPieceID(String(index)) {
                gameScene!.setPieceImage(index, image: storedImage)
            }
        }
        storeImageForPieceID(String(setImageNumber), image: chosenImage)
        
        //Attempt to use stored image, but default to picked image if needed
        if let storedImage = fetchImageForPieceID(String(index)) {
            gameScene?.setPieceImage(setImageNumber, image: storedImage)
        } else {
            gameScene?.setPieceImage(setImageNumber, image: chosenImage)
        }
        
        setImageNumber = (setImageNumber+1)%Piece.typesOfPieces
        //myImageView.contentMode = .ScaleAspectFit
        //myImageView.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil) //5
    }
}
