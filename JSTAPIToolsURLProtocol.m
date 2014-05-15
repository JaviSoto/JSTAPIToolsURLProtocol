//
//  JSTAPIToolsURLProtocol.m
//  JSTAPIToolsURLProtocol
//
//  Created by Javier Soto on 5/15/14.
//  Copyright (c) 2014 Javier Soto. All rights reserved.
//

#import "JSTAPIToolsURLProtocol.h"

@interface JSTAPIToolsURLProtocol () <NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *URLConnection;

@end

static id<JSTAPIToolsURLMapping> s_URLMapping;

@implementation JSTAPIToolsURLProtocol

+ (void)registerURLProtocolWithURLMapping:(id<JSTAPIToolsURLMapping>)URLMapping {
  NSAssert(!s_URLMapping, @"You can only invoke -%@ once.", NSStringFromSelector(_cmd));

  s_URLMapping = URLMapping;

  [NSURLProtocol registerClass:self];
}

- (NSURLRequest *)modifiedRequestWithOriginalRequest:(NSURLRequest *)request {
  NSURL *requestURL = request.URL;

  NSString *newHost = [s_URLMapping apiToolsHostForOriginalURLHost:requestURL.host];

  if (!newHost) {
    return request;
  }

  NSMutableURLRequest *modifiedRequest = request.mutableCopy;
  modifiedRequest.URL = [NSURL URLWithString:[requestURL.absoluteString stringByReplacingOccurrencesOfString:requestURL.host
                                                                                                  withString:newHost]];

  return modifiedRequest;
}

#pragma mark - NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
  NSString *protocol = request.URL.scheme;

  if (![@[@"http", @"https"] containsObject:protocol]) {
    return NO;
  }

  NSString *requestedURLHost = request.URL.host;
  const BOOL mappingForwardsHost = ([s_URLMapping apiToolsHostForOriginalURLHost:requestedURLHost] != nil);

  return mappingForwardsHost;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
  return request;
}

- (void)startLoading {
  self.URLConnection = [NSURLConnection connectionWithRequest:[self modifiedRequestWithOriginalRequest:self.request] delegate:self];
}

- (void)stopLoading {
  [self.URLConnection cancel];
  self.URLConnection = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
  [self.client URLProtocol:self didFailWithError:error];
}

@end
