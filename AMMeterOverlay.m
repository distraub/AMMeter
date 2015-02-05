//
//  AMMeterOverlay.m
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

#import "AMMeterOverlay.h"
@interface AMMeterOverlay()
@property (nonatomic, readonly) float labelStart;
@property (nonatomic, readonly) float labelBackGroundStart;
@property (nonatomic, readonly) float overlayStart;
@property (nonatomic, readwrite) bool labelsOnRight;
@property (nonatomic, readwrite) float lowestDB;
@end

@implementation AMMeterOverlay

// init with Frame Label Location and Lowest Visible DB
- (id)initWithFrame:(CGRect)frame andLabels:(bool)labelsRightSide andLowestDB:(float)lowestDB
{
    _lowestDB = lowestDB;
    NSLog(@"lowest db = %f", _lowestDB);
    self = [super initWithFrame:frame];
    if (self) {
        _labelsOnRight = labelsRightSide;
        if (_labelsOnRight) {
            _labelStart = _meterOffset;
            _overlayStart = 0;
        }else{
            _labelStart = 0;
            _overlayStart = _meterOffset;
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Check the location of the labels.
    if (_labelsOnRight) {
        _labelStart = _meterOffset+(_meterOffset/2);
        _labelBackGroundStart = _meterOffset;
        _overlayStart = 0;
    }else{
        _labelStart = 0;
        _labelBackGroundStart = 0;
        _overlayStart = _meterOffset;
    }
    
    CGContextRef c;
    
    // Drawing code
    
    c = UIGraphicsGetCurrentContext();
    
    float redValue = 0.0f;
    float greenvalue = 0.0f;
    float blueValue = 0.0f;
    
    CGFloat myColor[4] = {redValue, greenvalue, blueValue, 1.0f};
    CGContextSetStrokeColor(c, myColor);
    
    float redValue2 = 1.0f;
    float greenvalue2 = 1.0f;
    float blueValue2 = 1.0f;
    
    CGFloat myWhite[4] = {redValue2, greenvalue2, blueValue2, 1.0f};
    CGContextSetStrokeColor(c, myWhite);
    
    CGContextBeginPath(c);
    
    CGContextSetLineWidth(c, 1);
    
    float lineSpacing = 4;
    
    float counter = 0;
    float counter2 = 0;
    float dbLabel = -_lowestDB;
    
    // Draw Black overlay lines
    for (int currentLine = self.frame.size.height; currentLine > 0; currentLine--){
        counter++;
        counter2++;
        if (counter == lineSpacing) {
            counter = 0;
            CGRect wavRect = CGRectMake(_overlayStart, currentLine, _meterOffset+1, 2);
            CGMutablePathRef rectPath = CGPathCreateMutable();
            CGPathAddRect(rectPath, 0, wavRect);
            CGContextSetFillColor(c, myColor);
            CGContextAddPath(c, rectPath);
            CGContextFillPath(c);
            CGPathRelease(rectPath);
        }
        if (counter2 > self.frame.size.height/_lowestDB) {
            counter2 = 0;
            dbLabel++;
            NSLog(@"label = %f", dbLabel);
        }
        
    }
    
    // Draw DB Ticks
    float tickPosition;
    if (_labelsOnRight) {
        tickPosition = _meterOffset;
    }else{
        tickPosition = _meterOffset/1.5;
    }
    
    int step = 10;
    float currentDB = _lowestDB;
    int theCounter = 0;
    for (int x = 1;x<_lowestDB;x++){
        theCounter++;
        if (x>_lowestDB-10){
            step = 5;
        }
        if (x>_lowestDB-5) {
            step = 2;
        }
        if (theCounter == step){
            theCounter = 0;
            currentDB = currentDB - step;
            
        }
        float modifier;
        if (currentDB == _lowestDB) {
            modifier = self.frame.size.height - 5;
        }else{
            modifier = self.frame.size.height*(currentDB/_lowestDB);
        }
            CGRect wavRect2 = CGRectMake(tickPosition, modifier, _meterOffset/3, 1);
            CGMutablePathRef rectPath2 = CGPathCreateMutable();
            CGPathAddRect(rectPath2, 0, wavRect2);
            CGContextSetFillColor(c, myWhite);
            CGContextAddPath(c, rectPath2);
            CGContextFillPath(c);
            CGPathRelease(rectPath2);
        
    }
    
    
    // Place DB Labels
    UIFont *dbFont = [UIFont systemFontOfSize:_meterOffset/2 -4];
    step = 10;
    for (int d = _lowestDB; d>-1; d=d-step) {
        int modifier = 5;
        if (d == _lowestDB) {
            modifier = 10;
        }
        float dbloc = (self.frame.size.height*((float)d/_lowestDB)- modifier);
        UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(_labelStart, dbloc, _meterOffset, 10)];
        myLabel.textColor = [UIColor whiteColor];
        myLabel.text = [NSString stringWithFormat:@"-%d",d];
        [myLabel setFont:dbFont];
        [self addSubview:myLabel];
        if (d == 10){
            step = 5;
        }
        if (d == 5) {
            step = 2;
        }
    }
    
    CGContextStrokePath(c);
    
}

@end
