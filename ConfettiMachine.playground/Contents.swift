import PlaygroundSupport

import UIKit
import Foundation
import CoreGraphics

import ConfettiKit

class ConfettiMachineView: UIView {
    
    let emitter = CAEmitterLayer()
    let circleImage = ConfettiMachineView.createCircleImage()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    var isRunning: Bool = false {
        didSet {
            if isRunning {
                emitter.emitterCells!.forEach { $0.yAcceleration = 10 }
                emitter.lifetime = 100
                emitter.birthRate = 3
                emitter.beginTime = CACurrentMediaTime()
            } else {
                emitter.emitterCells!.forEach { $0.yAcceleration = 3000 }
                emitter.lifetime = 3
                emitter.birthRate = 0
            }
        }
    }
    
    public func start() {
        isRunning = true
    }
    
    public func stop() {
        isRunning = false
    }
    
    public func toggle() {
        isRunning = !isRunning
    }
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.renderMode = kCAEmitterLayerUnordered
        emitter.birthRate = 0
        emitter.emitterCells = Colors.accents.map { createConfettiPiece(color: $0) }
        
        layer.addSublayer(emitter)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emitter.position = CGPoint(x: bounds.width / 2, y: CGFloat(-10.0))
        emitter.emitterSize = CGSize(width: bounds.width, height: CGFloat(1))
    }
    
    func createConfettiPiece(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.contents = circleImage
        cell.contentsScale = UIScreen.main.scale
        cell.birthRate = 2
        cell.lifetimeRange = 2
        cell.lifetime = 0
        cell.velocity = 100
        cell.velocityRange = 20
        cell.emissionRange = CGFloat.pi / 4
        cell.emissionLongitude = CGFloat.pi
        cell.color = color.cgColor
        return cell
    }
    
    static let confettiSize = 10
    static func createCircleImage() -> CGImage {
        let frame = CGRect(x: 0, y: 0, width: confettiSize, height: confettiSize)
        
        let circleLayer = CAShapeLayer()
        circleLayer.frame = frame
        circleLayer.path = UIBezierPath(ovalIn: frame).cgPath
        circleLayer.fillColor = UIColor.white.cgColor
        circleLayer.shouldRasterize = true
        circleLayer.rasterizationScale = 2 * UIScreen.main.scale
        circleLayer.contentsScale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        circleLayer.render(in: UIGraphicsGetCurrentContext()!)
        let circleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return circleImage!.cgImage!
    }
}


let confetti = ConfettiMachineView(frame: CGRect(x: 0, y: 0, width: 340, height: 500))
confetti.backgroundColor = UIColor.white
confetti.start()

PlaygroundPage.current.liveView = confetti


