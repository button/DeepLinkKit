#import <Foundation/Foundation.h>

extern NSString * const BTNDeepLinkPayloadKey;
extern NSString * const BTNDeepLinkTargetURLKey;
extern NSString * const BTNDeepLinkReferrerURLKey;
extern NSString * const BTNDeepLinkReferrerAppNameKey;
extern NSString * const BTNDeepLinkExtrasKey;
extern NSString * const BTNDeepLinkAppLinksVersionKey;
extern NSString * const BTNDeepLinkDLCVersionKey;
extern NSString * const BTNDeepLinkUserAgentKey;

@class BTNDeepLink;

typedef void(^BTNDeepLinkResolveCompletion)(BTNDeepLink *deepLink, NSError *error);


@interface BTNDeepLink : NSObject

/// The URL representing an action or some content.
@property (nonatomic, copy, readonly) NSURL *targetURL;

/// Query parameters from the target URL parsed into an NSDictionary.
@property (nonatomic, strong, readonly) NSDictionary *targetQueryParameters;

/// The use case as specified in the target URL.
@property (nonatomic, copy, readonly) NSString *useCase;

/// The action as specified in the target URL.
@property (nonatomic, copy, readonly) NSString *action;

/// The object id as specified in the target URL.
@property (nonatomic, copy, readonly) NSString *objectId;

/// A deep link to the referring app.
@property (nonatomic, strong, readonly) BTNDeepLink *deepLinkReferrer;

/// The incoming deep link received by the application.
@property (nonatomic, copy, readonly) NSURL *incomingURL;

/// The query parameters of the incoming deep link.
@property (nonatomic, strong, readonly) NSDictionary *incomingQueryParameters;

/// The payload form the deep link URL parsed into an NSDictionary.
@property (nonatomic, strong, readonly) NSDictionary *payload;


/**
 Resolves a deep link into a deep link action.
 @param url A url conforming to the DLC standard.
 @param completionHandler A block executed when the link has been resolved.
 @see BTNDeepLinkResolveCompletion
 */
+ (void)resolveURL:(NSURL *)url completionHandler:(BTNDeepLinkResolveCompletion)completionHandler;

@end
