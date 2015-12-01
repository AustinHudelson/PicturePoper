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
    
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        gameScene?.setPieceImage(0, image: chosenImage)
        //myImageView.contentMode = .ScaleAspectFit
        //myImageView.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil) //5
    }
}
