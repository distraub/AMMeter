##AMMeter Audio Metering Class

AMMeter is an Objective-C Class that creates reusable audio metering objects.

###Features
- Accepts gain float data and draws a meter
- Fader with delegate callback to audio channels
- Configurable Label Position
- Configurable DB tick step size
- Auto sizes elements to Frame size

### Usage
Import included files into your project, and reference #import 'AMMeter.h' in your header.
Instantiate the meter like you would a UIView

Example
In your view controller :
```objective-c
_meter = [[AMMeter alloc]initWithFrame:CGRectMake(972, _waveFormView.frame.origin.y, 52, 720) lablesOnRightSide:YES andLowestDB:20];
```

In your Audio Engine or View Controller (depnding on how you have your app configured)

in.h
```objective-c
YourClass() <AMMeterDelegate>
```
in .m
```objective-c
_meter.delegate = self;
```
LabelsOnRight is a bool that decides if the labels are on the right side or left.
Lowest DB is a setting that indicates the lowest visible DB in the meter.

Setting the delegate will let you use the slider to set the volume of an audio channel controleld by your audio engine.
