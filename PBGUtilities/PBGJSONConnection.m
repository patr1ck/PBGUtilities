//	PBGUtilities
//  PBGJSONConnection.m
//
//	Created by Patrick B. Gibson.
//

#import "PBGJSONConnection.h"

@implementation PBGJSONConnection

#ifdef PBGJSONCONNECTIONLOGGING
static BOOL logging = YES;
#else
static BOOL logging = NO;
#endif

+ (void)getFromURL:(NSURL *)inURL handleJSONResponseWithBlock:(void (^)(id responseObj))inBlock;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:inURL];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
		if (responseData == nil && error) {
			NSLog(@"ERROR: GET connection error: %@", [error localizedDescription]);
			return;
		}
        
        NSError *jsonError = nil;
        id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
        
        if (responseObject == nil && jsonError) {
			NSLog(@"ERROR: GET JSON Reading error: %@", [jsonError localizedDescription]);
			return;
		}
        
        if (logging) {
            NSLog(@"PBGJSONINTERFACELOGGING: Response Object for GET: %@\n\n", responseObject);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            inBlock(responseObject);
        });
    });
}

+ (void)postToURL:(NSURL *)inURL withJSONSerializableObject:(id)inObj handleJSONResponseWithBlock:(void (^)(id responseObj))inBlock;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *jsonError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:inObj options:0 error:&jsonError];
        
        if (jsonData == nil && jsonError) {
			NSLog(@"ERROR: POST JSON Writing error: %@", [jsonError localizedDescription]);
			return;
		}
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:inURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (responseData == nil && error) {
			NSLog(@"ERROR: POST connection error: %@", [error localizedDescription]);
			return;
		}
        
        jsonError = nil;
        id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
        
        if (responseObject == nil && jsonError) {
			NSLog(@"ERROR: POST JSON Reading error: %@", [jsonError localizedDescription]);
			return;
		}
        
        if (logging) {
            NSLog(@"PBGJSONINTERFACELOGGING: Response Object for POST: %@\n\n", responseObject);
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            inBlock(responseObject);
        });
    });
}

@end
