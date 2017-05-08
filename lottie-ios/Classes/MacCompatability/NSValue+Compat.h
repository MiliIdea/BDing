//
// Created by Oleksii Pavlovskyi on 2/2/17.
// Copyright (c) 2017 Airbnb. All rights reserved.
//

#if !TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
#import <Foundation/Foundation.h>

@interface NSValue (Compat)

+ (NSValue *)valueWithCGRect:(Rect)rect;
+ (NSValue *)valueWithCGPoint:(Point)point;

@property (nonatomic, readonly) Rect CGRectValue;
@property(nonatomic, readonly) Point CGPointValue;

@end

#endif
