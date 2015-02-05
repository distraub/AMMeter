//
//  AMMeterSlider.m
//
//  Audio Metering Class with Faders
//  This class plugs in nicely with The Amazing Audio Engine
//
//    License
//
//    Copyright (c) 2015 matheusound.net. All rights reserved.
//
//    This software is provided 'as-is', without any express or implied
//    warranty.  In no event will the authors be held liable for any damages
//    arising from the use of this software.
//
//    Permission is granted to anyone to use this software for any purpose,
//    including commercial applications, and to alter it and redistribute it
//    freely, subject to the following restrictions:
//
//    1. The origin of this software must not be misrepresented; you must not
//    claim that you wrote the original software. If you use this software
//    in a product, an acknowledgment in the product documentation would be
//    appreciated but is not required.
//
//    2. Altered source versions must be plainly marked as such, and must not be
//    misrepresented as being the original software.
//
//    3. This notice may not be removed or altered from any source distribution.

#import "AMMeterSlider.h"
@interface AMMeterSlider()
@property (nonatomic, readwrite) bool labelsOnRight;
@end

@implementation AMMeterSlider

- (id)initWithFrame:(CGRect)frame andLabels:(bool)labelsRightSide
{
    self = [super initWithFrame:frame];
    if (self) {
        _labelsOnRight = labelsRightSide;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context;
    
    // Drawing code
    
    context = UIGraphicsGetCurrentContext();
    
    // Draw triangle for slider on opposite side of labels
    float trianglePoint = _labelsOnRight ? 0 : self.frame.size.width;
    float triangleEdge = _labelsOnRight ? self.frame.size.width : 0;
    
    float redValue = 0.3f;
    float greenvalue = 0.3f;
    float blueValue = 0.3f;
   
    CGFloat myColor[4] = {redValue, greenvalue, blueValue, .8f};
    CGContextSetFillColor(context, myColor);
    
    float redValue2 = 1.0f;
    float greenvalue2 = 1.0f;
    float blueValue2 = 1.0f;
    
    CGFloat myWhite[4] = {redValue2, greenvalue2, blueValue2, 1.0f};
    CGContextSetStrokeColor(context, myWhite);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CGPathMoveToPoint(pathRef, NULL, triangleEdge, 0);
    CGPathAddLineToPoint(pathRef, NULL, triangleEdge, self.frame.size.height);
    CGPathAddLineToPoint(pathRef, NULL, trianglePoint, self.frame.size.height/2);
    CGPathAddLineToPoint(pathRef, NULL, triangleEdge, 0);
    
    CGPathCloseSubpath(pathRef);
    
    CGContextAddPath(context, pathRef);
    CGContextFillPath(context);
    
    CGContextAddPath(context, pathRef);
    CGContextStrokePath(context);
    
    CGPathRelease(pathRef);
    
}


@end
