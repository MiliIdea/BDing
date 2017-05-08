//
//  UIColor.m
//  Lottie
//
//  Created by Oleksii Pavlovskyi on 2/2/17.
//  Copyright © 2017 Airbnb. All rights reserved.
//

#if !TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
#import "UIColor.h"
#import <UIKit/UIKit.h>

#define StaticColor(staticColor) \
static UIColor *color = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
    color = UIColor.staticColor.UIColor; \
}); \
return color; \

@interface UIColor ()

@property (nonatomic, strong) UIColor *color;

- (instancetype)initWithNSColor:(UIColor *)color;

@end

@interface UIColor (UIColor)

@property (nonatomic, readonly) UIColor *UIColor;

@end

@implementation UIColor

- (instancetype)initWithNSColor:(UIColor *)color {
    self = [super init];
    if (self) {
        self.color = color;
    }
    return self;
}

+ (UIColor *)colorWithNSColor:(UIColor *)color {
    return [[self alloc] initWithNSColor:color];
}

+ (UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha {
    return [[UIColor colorWithWhite:white alpha:alpha] UIColor];
}

+ (UIColor *)colorWithHue:(CGFloat)hue
               saturation:(CGFloat)saturation
               brightness:(CGFloat)brightness
                    alpha:(CGFloat)alpha {
    return [[UIColor colorWithHue:hue
                       saturation:saturation
                       brightness:brightness
                            alpha:alpha] UIColor];
}

+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [[UIColor colorWithRed:red
                            green:green
                             blue:blue
                            alpha:alpha] UIColor];
}

+ (UIColor *)colorWithCGColor:(CGColorRef)cgColor {
    return [[UIColor colorWithCGColor:cgColor] UIColor];
}

+ (UIColor *)blackColor {
    StaticColor(blackColor)
}

+ (UIColor *)darkGrayColor {
    StaticColor(darkGrayColor)
}

+ (UIColor *)lightGrayColor {
    StaticColor(lightGrayColor)
}

+ (UIColor *)whiteColor {
    StaticColor(whiteColor)
}

+ (UIColor *)grayColor {
    StaticColor(grayColor)
}

+ (UIColor *)redColor {
    StaticColor(redColor)
}

+ (UIColor *)greenColor {
    StaticColor(greenColor)
}

+ (UIColor *)blueColor {
    StaticColor(blueColor)
}

+ (UIColor *)cyanColor {
    StaticColor(cyanColor)
}

+ (UIColor *)yellowColor {
    StaticColor(yellowColor)
}

+ (UIColor *)magentaColor {
    StaticColor(magentaColor)
}

+ (UIColor *)orangeColor {
    StaticColor(orangeColor)
}

+ (UIColor *)purpleColor {
    StaticColor(purpleColor)
}

+ (UIColor *)brownColor {
    StaticColor(brownColor)
}

+ (UIColor *)clearColor {
    StaticColor(clearColor)
}

- (CGColorRef)CGColor {
    return self.color.CGColor;
}

- (UIColor *)colorWithAlphaComponent:(CGFloat)alpha {
    return [self.color colorWithAlphaComponent:alpha].UIColor;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self.color copyWithZone:zone] UIColor];
}

@end

@implementation UIColor (UIColor)

- (UIColor *)UIColor {
    return [UIColor colorWithNSColor:self];
}

@end

#endif
