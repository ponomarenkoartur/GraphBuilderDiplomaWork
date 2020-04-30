//
//  Eval.h
//  GraphBuilderDiplomaWork
//
//  Created by Artur on 01.05.2020.
//  Copyright © 2020 Artur. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Eval : NSObject

+ (NSNumber *) eval: (NSString *) expressionString withException: (NSException *_Nullable*_Nullable) exceptionPtr;

@end

NS_ASSUME_NONNULL_END
