//
//  NavButton.swift
//  GymTracker
//
//  Created by Marcus Lundgren on 2018-06-21.
//  Copyright © 2018 Marcus Lundgren. All rights reserved.
//

import UIKit

class NavButton: UIButton {

    override func draw(_ rect: CGRect) {
        
        // thickness of your line
        let lineThick:CGFloat = 3.0
        
        // length of your line relative to your button
        let lineLength:CGFloat = min(bounds.width, bounds.height) * 0.9
        
        // color of your line
        let lineColor: UIColor = UIColor.black
        
        // this will add small padding from button border to your first line and other lines
        let marginGap: CGFloat = 10.0
        
        // we need three line
        for line in 0...2 {
            // create path
            let linePath = UIBezierPath()
            linePath.lineWidth = lineThick
            
            //start point of line
            linePath.move(to: CGPoint(
                x: bounds.width/2 - lineLength/2,
                y: 10.0 * CGFloat(line) + marginGap
            ))
            
            //end point of line
            linePath.addLine(to: CGPoint(
                x: bounds.width/2 + lineLength/2,
                y: 10.0 * CGFloat(line) + marginGap
            ))
            //set line color
            lineColor.setStroke()
            
            //draw the line
            linePath.stroke()
        }
    }
}
