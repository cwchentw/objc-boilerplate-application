#import <Foundation/Foundation.h>

int main(void)
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    if (!pool)
        return 1;

    /* Implement your code here. */

    [pool drain];

    return 0;
}