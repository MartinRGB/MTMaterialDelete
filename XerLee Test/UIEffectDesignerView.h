//
//  UIEffectDesignerView.h
//
//  @version 0.1
//  @author Marin Todorov, http://www.touch-code-magazine.com
//

// Copyright (c) 2012 Marin Todorov, Underplot ltd.
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// The MIT License in plain English: http://www.touch-code-magazine.com/JSONModel/MITLicense

// *********************************************
// For more information how to use this class to display particle system effects in your iOS or OSX app
// download the UIEffectDesigner app and have a look at the samples on this page:
// http://www.touch-code-magazine.com/uieffectdesigner/
// *********************************************

// This is an ARC only Objective-C class, compatible with iOS5+ and OSX 10.7+

#import "QuartzCore/QuartzCore.h"

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import <UIKit/UIKit.h>
@interface UIEffectDesignerView : UIView

#else

#import <AppKit/AppKit.h>
@interface UIEffectDesignerView : NSView
#endif

@property (strong, nonatomic) CAEmitterLayer* emitter;

-(instancetype)initWithFile:(NSString*)fileName;
+(instancetype)effectWithFile:(NSString*)fileName;

@end
