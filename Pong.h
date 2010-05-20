#import <Foundation/Foundation.h>
#import "ResponseMessage.h"

@interface Pong : ResponseMessage
{

}

+(Pong*) getSharedInstance;

@end