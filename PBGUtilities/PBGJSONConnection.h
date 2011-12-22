// 	PBGUtilities
//  PBGJSONConnection.h
//
//  Created by Patrick B. Gibson.
//

#import <Foundation/Foundation.h>

// PBGJsonInterface is designed to let you communicate with JSON endpoints very quickly and easily. 
// It's not designed to be full featured, client-side connection manager. It just lets you GET and POST things
// with an easy, block-based call. Note that the block you pass will be called on the main thread.

// If you build this with PBGJSONCONNECTIONLOGGING definited, you can get more logging detail.

// This class requires iOS 5.0 or greater.

@interface PBGJSONConnection : NSObject

+ (void)getFromURL:(NSURL *)inURL handleJSONResponseWithBlock:(void (^)(id responseObj))inBlock;
+ (void)postToURL:(NSURL *)inURL withJSONSerializableObject:(id)inObj handleJSONResponseWithBlock:(void (^)(id))inBlock;

@end
