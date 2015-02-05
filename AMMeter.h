//
//  AMMeter.h
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


#import <UIKit/UIKit.h>
#import "AMMeterOverlay.h"
#import "AMMeterSlider.h"

// Delegate protocol to set the gain for the audio channel
@protocol AMMeterDelegate
-(void)setGain:(float)gain forChannel:(int)channel;
@end

// AMMeter inherits from UIView
@interface AMMeter : UIView
@property (nonatomic, weak) id<AMMeterDelegate> delegate;
@property (nonatomic, readwrite) Float32 peakDB;

// set the offset for the meter
@property (nonatomic, readwrite) float meterOffset;

// set the ID of the channel
@property (nonatomic, readwrite) int channelID;

// instatiation method, if bool labelsRightSide is YES then the labels will show ont he left side, otherwise they will show on the right.
// Use the lowestDB property to set the lowest DB displayed (I would recommend between -20 and -30)
- (id)initWithFrame:(CGRect)frame lablesOnRightSide:(bool)labelsRightSide andLowestDB:(float)lowestDB;
- (void)setPeakDB:(Float32)peakDB;

@end
