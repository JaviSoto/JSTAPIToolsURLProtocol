//
//  JSTAPIToolsURLProtocol.h
//  JSTAPIToolsURLProtocol
//
//  Created by Javier Soto on 5/15/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JSTAPIToolsURLMapping <NSObject>

/**
 Whenever `JSTAPIToolsURLProtocol` receives an http or https request, it will call this method to query for the APItools host to use instead.
 E.g. If a request is sent to https://api.twitter.com/2/users/xxxx it will call this method with @"api.twitter.com".
 - To no forward the request to APItools, this method must return nil.
 - To formward the request to APItools, return your appropiate apitools hostname associated with the api.twitter.com host, like @"tw-ghzbf45ab8cz.my.apitools.com".
 @note The implementation of this methd must be thread-safe since it will be invoked from arbitrary background threads.
 This method is called once per request, so consider storing the mapping in an NSDictionary.
 */
- (NSString *)apiToolsHostForOriginalURLHost:(NSString *)originalURLHost;

@end

/**
 This class allows you to easily make your application redirects some of the HTTP(s) requests it makes to your https://www.apitools.com/ account.
 APItools is a web application that stores requests and lets you track, transform and analyze the traffic between your app and the APIs it uses.
 */
@interface JSTAPIToolsURLProtocol : NSURLProtocol

/**
 Your application should call this method whenever it wants to enable the request forwarding towards APItools.
 It's recommended to enable it as early as possible in the application lifecycle, for example in the `+load` method of another class.
 You may choose to only call this method on debug builds (#if DEBUG).
 @note You can only call this method once during your application lifecycle.
 */
+ (void)registerURLProtocolWithURLMapping:(id<JSTAPIToolsURLMapping>)URLMapping;

@end
