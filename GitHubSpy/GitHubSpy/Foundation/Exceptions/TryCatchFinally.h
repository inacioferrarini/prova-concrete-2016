#import <Foundation/Foundation.h>

@interface TryCatchFinally : NSObject

+ (void)handleTryBlock:(void(^)())tryBlock
        withCatchBlock:(void(^)(NSException * exception))catchBlock;

+ (void)handleTryBlock:(void(^)())tryBlock
        withCatchBlock:(void(^)(NSException * exception))catchBlock
      withFinallyBlock:(void(^)())finallyBlock;

@end
