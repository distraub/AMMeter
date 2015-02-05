//
//  AMMeter.m
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

#import "AMMeter.h"
#import <QuartzCore/QuartzCore.h>

@interface AMMeter() <UIGestureRecognizerDelegate>
// meter color bars
@property (nonatomic, strong) UIView *meterGreen;
@property (nonatomic, strong) UIView *meterYellow;
@property (nonatomic, strong) UIView *meterRed;

// meter overlay that displayes DB information and black overlay bars
@property (nonatomic, strong) AMMeterOverlay *meterOverlay;

// gesture recognizers for the slider
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

// holders for the meter label origin.x and slider origin.x
@property (nonatomic, readonly) float meterStart;
@property (nonatomic, readwrite) float sliderStart;

// peak DB text label
@property (nonatomic, strong) UILabel *peakLabel;

// DB regulator that regulates the intervals that the DB text is changed
@property (nonatomic, readwrite) float dbhigh;

// meter gain between 0 adn 1
@property (nonatomic, readwrite) float meterGain;

// meter slider for channel gain
@property (nonatomic, strong) AMMeterSlider *meterSlider;

// property that holds the status of the label side
@property (nonatomic, readwrite) bool labelsOnRight;
// property that holds the DB for the visible start of the meter.
@property (nonatomic, readwrite) float lowestDB;

@end
@implementation AMMeter


- (id)initWithFrame:(CGRect)frame lablesOnRightSide:(bool)labelsRightSide andLowestDB:(float)lowestDB{
    
    _lowestDB = lowestDB;
    self = [super initWithFrame:frame];
    if (self) {
        _labelsOnRight = labelsRightSide;
        _meterOffset = self.frame.size.width/2;
        if (_labelsOnRight) {
            _meterStart = 0;
            _sliderStart = _meterOffset;
        }else{
            _meterStart = _meterOffset;
            _sliderStart = _meterOffset/2;
        }
        [self drawMeters];
    }
    
    return self;
}

-(void)drawMeters{
    float myHeight = self.frame.size.height;
    float myWidth = self.frame.size.width;
    
    _meterOffset = self.frame.size.width/2;
    
    _meterGreen = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0)];
    //_meterGreen.frame = CGRectMake(_meterOffset, myHeight * (2/_lowestDB), _meterOffset, 0);
    
    _meterYellow = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _meterRed = [[UIView alloc]initWithFrame:CGRectMake(_meterStart, 0, _meterOffset, 1)];
    
    _meterGreen.backgroundColor = [UIColor greenColor];
    _meterYellow.backgroundColor = [UIColor yellowColor];
    _meterRed.backgroundColor = [UIColor redColor];
    
    _meterGreen.alpha = 1;
    _meterRed.alpha = 0;
    _meterYellow.alpha = 1;
    
    [self addSubview:_meterGreen];
    [self addSubview:_meterYellow];
    [self addSubview:_meterRed];
    
    _meterOverlay = [[AMMeterOverlay alloc]initWithFrame:CGRectMake(-1, 0, myWidth+1, myHeight) andLabels:_labelsOnRight andLowestDB:_lowestDB];
    _meterOverlay.backgroundColor = [UIColor clearColor];
    _meterOverlay.meterOffset = _meterOffset;
    [self addSubview:_meterOverlay];
    
    UIFont *peakFont = [UIFont systemFontOfSize:_meterOffset/2 -4];
    
    _peakLabel = [[UILabel alloc]initWithFrame:CGRectMake(_meterStart-1, -10, self.frame.size.width, 10)];
    _peakLabel.textColor = [UIColor whiteColor];
    _peakLabel.text = @"";
    [_peakLabel setFont:peakFont];
    [self addSubview:_peakLabel];
    _dbhigh = _lowestDB;
    
    _meterSlider = [[AMMeterSlider alloc]initWithFrame:CGRectMake(_sliderStart, 0, _meterOffset/2.5, _meterOffset/2.5) andLabels:_labelsOnRight];
    _meterSlider.backgroundColor = [UIColor clearColor];
    [self addSubview:_meterSlider];
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panRecognizer.delegate = self;
    [self addGestureRecognizer:self.panRecognizer];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:self.tapRecognizer];
}

-(void)setLabelsOnRight:(bool)labelsOnRight{
    _labelsOnRight = labelsOnRight;
    if (_labelsOnRight) {
        _meterStart = 0;
    }else{
        _meterStart = _meterOffset;
    }
}

// sets the DB from the incoming signal
-(void)setPeakDB:(Float32)peakDB{
    
    if (_labelsOnRight) {
        _meterStart = 0;
    }else{
        _meterStart = _meterOffset;
    }
    
    Float32 meterLevel = -peakDB;
    if (meterLevel > _dbhigh+(_lowestDB/6)) {
        _dbhigh = meterLevel;
    }
    if (meterLevel < (_lowestDB/6)) {
        if (meterLevel < _dbhigh) {
             _dbhigh = meterLevel;
        }
       
        _peakLabel.text = [NSString stringWithFormat:@"%06.2f", -_dbhigh];
    }else{
        if (meterLevel < _dbhigh) {
            _dbhigh = meterLevel;
        }
    _peakLabel.text = [NSString stringWithFormat:@"%06.2f", -_dbhigh];
    }
    
    if (peakDB > -2) {
        float yellowHeight = (-peakDB/_lowestDB)*self.frame.size.height;
        //_meterGreen.backgroundColor = [UIColor yellowColor];
        _meterYellow.frame = CGRectMake(_meterStart, self.frame.size.height/(_lowestDB/2)-yellowHeight, _meterOffset,  yellowHeight);
        _meterGreen.frame = CGRectMake(_meterStart, self.frame.size.height/(_lowestDB/2), _meterOffset, self.frame.size.height-self.frame.size.height/(_lowestDB/2));
        _meterRed.alpha = 0;
        _meterYellow.alpha = 1;
    }else{
        _meterYellow.alpha = 0;
        _meterRed.alpha = 0;
        float greenHeight = (self.frame.size.height-(-peakDB/_lowestDB)*self.frame.size.height);
        //float greenHeight = self.frame.size.height*(peakDB/60);
        int greenHeightInt = greenHeight > 0 ? (int)greenHeight : 0;
        
        _meterGreen.frame = CGRectMake(_meterStart, self.frame.size.height-greenHeightInt, _meterOffset, greenHeightInt);
    }
    if (peakDB >= - .001) {
        //_meterGreen.backgroundColor = [UIColor redColor];
        _meterRed.alpha = 1;
    }
}

// sets the gain of the channel informs delegate of the change
-(void)setMeterGain:(float)meterGain{
    _meterGain = meterGain;
    [_delegate setGain:_meterGain forChannel:_channelID];
}

#pragma mark - Interaction

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self];
    float theLocation = location.y;
    if (location.y < self.frame.size.height*.03) {
        theLocation = 0;
    }
    if (location.y > self.frame.size.height*.97) {
        theLocation = self.frame.size.height;
    }
    if (theLocation >= 0 && theLocation <= self.frame.size.height) {
        _meterSlider.center = CGPointMake(_meterSlider.center.x, theLocation);
        [self setMeterGain:(self.frame.size.height-theLocation)/self.frame.size.height];
    }
    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    
    CGPoint location = [recognizer locationInView:self];
    float theLocation = location.y;
    if (location.y < self.frame.size.height*.03) {
        theLocation = 0;
    }
    if (location.y > self.frame.size.height*.97) {
        theLocation = self.frame.size.height;
    }
    //NSLog(@"location = %f , %f", location.x, location.y);
    if (theLocation >= 0 && theLocation <= self.frame.size.height) {
        _meterSlider.center = CGPointMake(_meterSlider.center.x, theLocation);
        [self setMeterGain:(self.frame.size.height-theLocation)/self.frame.size.height];
    }
}

@end
