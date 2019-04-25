//
//  ViewController.swift
//  DrawErase
//
//  Created by Daniel Kerbel on 4/25/19.
//  Copyright © 2019 DannysTesting. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var startingPoint: CGPoint!
    var touchPoint: CGPoint!
    
    var currentPhoto: UIImage?
    
    var mainImageView: UIImageView = {
        let image = UIImage(named: "boat.jpg")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var tempImageView: UIImageView = {
        let image = UIImage(named: "boat.jpg")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let undoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = UIColor.white
        button.setTitle("Undo", for: .normal)
        button.backgroundColor = UIColor.blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        undoButton.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        
        setupView()
    }

    func setupView() {
        view.addSubview(mainImageView)
        view.addSubview(tempImageView)
        view.addSubview(undoButton)
        
        mainImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        mainImageView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        tempImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tempImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tempImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tempImageView.heightAnchor.constraint(equalToConstant: 276).isActive = true
        
        undoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        undoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
        undoButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        undoButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    
    // Touches
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainImageView.isHidden = true
        tempImageView.isHidden = false
        let touch = touches.first
        startingPoint = touch?.location(in: self.tempImageView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        touchPoint = touch?.location(in: self.tempImageView)
        if touchPoint.y <= -0 || touchPoint.y >= (tempImageView.frame.height) {
            return
        }

        UIGraphicsBeginImageContextWithOptions(tempImageView.bounds.size, false, 0)
        tempImageView.image?.draw(in: tempImageView.bounds)
       
        if let context = UIGraphicsGetCurrentContext() {
            context.setBlendMode(CGBlendMode.clear)
            context.setLineCap(CGLineCap.round)
            context.setLineWidth(15)
            context.beginPath()
            context.setBlendMode(CGBlendMode.clear)
            context.move(to: startingPoint)
            context.addLine(to: touchPoint)
            context.strokePath()
            
            tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            currentPhoto = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            startingPoint = touchPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainImageView.isHidden = false
        tempImageView.isHidden = true
        
        setNewImage(newImage: currentPhoto)
    }
    
    
    // Undo Register
    
    
    func setNewImage(newImage: UIImage?) {
        undoManager?.registerUndo(withTarget: self, handler: { (targetSelf) in
            self.mainImageView.image = newImage
        })
        mainImageView.image = newImage
    }
    
    
    // Undo Button Action
    
    
    @objc func undoButtonTapped() {
        undoManager?.undo()
    }

}
