#import "TryCatchFinally.h"

@implementation TryCatchFinally

+ (void)handleTryBlock:(void (^)())tryBlock
        withCatchBlock:(void (^)(NSException *))catchBlock {
    
    [self handleTryBlock:tryBlock withCatchBlock:catchBlock withFinallyBlock:nil];
}

+ (void)handleTryBlock:(void (^)())tryBlock
        withCatchBlock:(void (^)(NSException * exception))catchBlock
      withFinallyBlock:(void (^)())finallyBlock {

    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        catchBlock(exception);
    }
    @finally {
        if (finallyBlock) {
            finallyBlock();
        }
    }
    
}

@end
