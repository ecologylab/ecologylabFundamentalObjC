#import <Foundation/Foundation.h>
#import "ServiceMessage.h"
#import "Scope.h"

@interface UpdateMessage : ServiceMessage
{
}

-(void) processUpdate:(Scope *) scope;

@end

