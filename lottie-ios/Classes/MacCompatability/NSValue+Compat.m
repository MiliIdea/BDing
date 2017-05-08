//
// Created by Oleksii Pavlovskyi on 2/2/17.
// Copyright (c) 2017 Airbnb. All rights reserved.
//

#if !TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
#import "NSValue+Compat.h"

@implementation NSValue (Compat)

+ (NSValue *)valueWithCGRect:(Rect)rect {
    return [self valueWithCGRect:rect];
}

+ (NSValue *)valueWithCGPoint:(Point)point {
    return [self valueWithCGPoint:point];
}

- (Rect)CGRectValue {
    return self.CGRectValue;
}

- (Point)CGPointValue {
    return self.CGPointValue;
}

@end

#endif
