//
//  WideLoading.swift
//  sdkDemo
//
//  Created by Wide Technologies Indonesia, PT on 11/08/23.
//

import Foundation
import UIKit

class WideLoading: UIView {
    //MARK: Private
    private var loadingIndicator: LoadingIndicatorView!
    
    //MARK: Public
    var color: UIColor!
    var lineWidth: CGFloat!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        loadingIndicator = LoadingIndicatorView(color: color, lineWidth: lineWidth)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.isAnimating = false
        self.addSubview(loadingIndicator)
        
        loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loadingIndicator.widthAnchor.constraint(equalToConstant: 60).isActive = true
        loadingIndicator.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setAnimating(animating: Bool) {
        self.isHidden = !animating
        loadingIndicator.isAnimating = animating
    }
}

class LoadingIndicatorView: UIView {
    
    // MARK: - Properties
    var color: UIColor!
    var lineWidth: CGFloat!
    var shapeLayer: LoadingIndicatorShapeLayer!
    
    // MARK: - Initialization
    init(frame: CGRect, color: UIColor, lineWidth: CGFloat) {
        super.init(frame: frame)

        self.color = color
        self.lineWidth = lineWidth
        shapeLayer = LoadingIndicatorShapeLayer(strokeColor: color, lineWidth: lineWidth)
        self.backgroundColor = .clear
        
    }
    
    convenience init(color: UIColor, lineWidth: CGFloat) {
        self.init(frame: .zero, color: color, lineWidth: lineWidth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.width / 2
        
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.width))

        shapeLayer.path = path.cgPath
    }
    
    // MARK: - Animations
    func animateStroke() {
        let startAnimation = StrokeAnimation(
            type: .start,
            beginTime: 0.25,
            fromValue: 0.0,
            toValue: 1.0,
            duration: 0.75
        )
        
        let endAnimation = StrokeAnimation(
            type: .end,
            fromValue: 0.0,
            toValue: 1.0,
            duration: 0.75
        )
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = 1
        strokeAnimationGroup.repeatDuration = .infinity
        strokeAnimationGroup.animations = [startAnimation, endAnimation]
        
        shapeLayer.add(strokeAnimationGroup, forKey: nil)

        self.layer.addSublayer(shapeLayer)
    }
    
    func animateRotation() {
        let rotationAnimation = RotationAnimation(
            direction: .z,
            fromValue: 0,
            toValue: CGFloat.pi * 2,
            duration: 2,
            repeatCount: .greatestFiniteMagnitude
        )
        
        self.layer.add(rotationAnimation, forKey: nil)
    }
    
    var isAnimating: Bool = false {
        didSet {
            if isAnimating {
                self.animateStroke()
                self.animateRotation()
            } else {
                self.shapeLayer.removeFromSuperlayer()
                self.layer.removeAllAnimations()
            }
        }
    }
}

class LoadingIndicatorShapeLayer: CAShapeLayer {
    
    init(strokeColor: UIColor, lineWidth: CGFloat) {
        super.init()
        
        self.strokeColor = strokeColor.cgColor
        self.lineWidth = lineWidth
        self.fillColor = UIColor.clear.cgColor
        self.lineCap = .round
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StrokeAnimation: CABasicAnimation {
    
    enum StrokeType {
        case start
        case end
    }
    
    override init() {
        super.init()
    }
    
    init(type: StrokeType, beginTime: Double = 0.0, fromValue: CGFloat, toValue: CGFloat, duration: Double) {
        super.init()
        
        self.keyPath = type == .start ? "strokeStart" : "strokeEnd"
        self.beginTime = beginTime
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.timingFunction = .init(name: .easeInEaseOut)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RotationAnimation: CABasicAnimation {
    
    enum Direction: String {
        case x, y, z
    }
    
    override init() {
        super.init()
    }
    
    init(direction: Direction, fromValue: CGFloat, toValue: CGFloat, duration: Double, repeatCount: Float) {
        super.init()
        
        self.keyPath = "transform.rotation.\(direction.rawValue)"
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.repeatCount = repeatCount
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
