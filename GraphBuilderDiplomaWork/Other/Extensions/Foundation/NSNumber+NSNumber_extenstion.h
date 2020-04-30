//
//  NSNumber+NSNumber_extenstion.h
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 30.04.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (FactorialExpression)

- (NSNumber *) factorial;

@end

@implementation NSNumber (FactorialExpression)

- (NSNumber *) factorial {
    double baseValue = [self doubleValue];
    double result = tgamma(baseValue+1);
    return [NSNumber numberWithDouble:result];
}

@end

NS_ASSUME_NONNULL_END
