//
//  NSNumber+NSNumber_extension.h
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 01.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (Functions)

- (NSNumber *) sin;
- (NSNumber *) cos;
- (NSNumber *) tan;
- (NSNumber *) cot;


@end

@implementation NSNumber (FactorialExpression)

- (NSNumber *) sin {
    double baseValue = [self doubleValue];
    double result = sin(baseValue);
    return [NSNumber numberWithDouble:result];
}

- (NSNumber *) cos {
    double baseValue = [self doubleValue];
    double result = cos(baseValue);
    return [NSNumber numberWithDouble:result];
}

- (NSNumber *) tan {
    double baseValue = [self doubleValue];
    double result = tan(baseValue);
    return [NSNumber numberWithDouble:result];
}

- (NSNumber *) cot {
    double baseValue = [self doubleValue];
    double result = 1 / tan(baseValue);
    return [NSNumber numberWithDouble:result];
}

@end

NS_ASSUME_NONNULL_END
