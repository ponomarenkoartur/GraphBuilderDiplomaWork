//
//  Eval.m
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 01.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

#import "Eval.h"
#import "NSNumber+NSNumber_extension.h"

@implementation Eval

+ (NSNumber *) eval: (NSString *) expressionString withException: (NSException **) exceptionPtr {
    @try {
        NSExpression *expression = [NSExpression expressionWithFormat:expressionString];
        NSNumber *result = [expression expressionValueWithObject:nil context:nil];
        return result;
    } @catch (NSException* e) {
        *exceptionPtr = e;
        return 0;
    }
}


@end
