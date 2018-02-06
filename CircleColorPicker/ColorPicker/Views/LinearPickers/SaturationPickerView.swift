//
//  SaturationPickerView.swift
//  CircleColorPicker
//
//  Created by Laszlo Pinter on 11/17/17.
//  Copyright © 2017 Laszlo Pinter. All rights reserved.
//

import UIKit

open class SaturationPickerView: LinearPickerView {

    open override func handleOrientationChange() {
        (frontLayerView as! SaturationGradient).isVertical = isVertical
    }
    
    open override func createFrontLayerView() -> UIView{
        let frontLayer = SaturationGradient(frame: CGRect.init(origin: CGPoint.zero, size: self.bounds.size))
        frontLayer.isVertical = isVertical
        return frontLayer
    }

    open override func updateFrontLayerView() {
        let saturationGradient = self.frontLayerView as? SaturationGradient
        saturationGradient?.backgroundColor = self.backgroundColor
        saturationGradient?.setNeedsLayout()
    }
    
    class SaturationGradient: UIView {
        public var isVertical = false
        
        func drawScale(context: CGContext){
            var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            self.backgroundColor?.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            
            let startColor = UIColor.init(hue: h, saturation: 0, brightness: b, alpha: 1).cgColor
            let endColor   = UIColor.init(hue: h, saturation: 1, brightness: b, alpha: 1).cgColor
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors = [startColor, endColor] as CFArray
            
            if let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors, locations: nil) {
                var startPoint: CGPoint!
                var endPoint: CGPoint!
                
                if isVertical {
                    startPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
                    endPoint = CGPoint(x: self.bounds.width, y: 0)
                }else {
                    startPoint = CGPoint(x: 0, y: self.bounds.height)
                    endPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
                }
                
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
            }
        }
        
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            drawScale(context: context)
        }
    }
}
