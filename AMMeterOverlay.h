//
//  AMMeterOverlay.h
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

#import <UIKit/UIKit.h>

@interface AMMeterOverlay : UIView
// set the offset of the meter in pixels
@property (nonatomic, readwrite) float meterOffset;
// set the step increment for when db is above 10
@property (nonatomic, readwrite) int dbStep;

- (id)initWithFrame:(CGRect)frame andLabels:(bool)labelsRightSide andLowestDB:(float)lowestDB;

@end
