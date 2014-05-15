JSTAPIToolsURLProtocol
======================

`JSTAPIToolsURLProtocol` allows you to easily make your application redirects some of the HTTP(s) requests it makes to your https://www.apitools.com/ account without modifying your existing networking code.

APItools is a web application that stores requests and lets you track, transform and analyze the traffic between your app and the APIs it uses.

### Installation

- Using [Cocoapods](http://cocoapods.org/):

Just add this line to your `Podfile`:

```
pod 'JSTAPIToolsURLProtocol', '~> 1.0.0'
```

- Manually:

Simply add the files `JSTAPIToolsURLProtocol.h` and `JSTAPIToolsURLProtocol.m` to your project.

### Usage

- Sign up for a free account at https://www.apitools.com/.

- Create a service for every API that your application uses.

- Have a class conform to the `JSTAPIToolsURLMapping` protocol:

```objc
@interface MyURLMappingProvider : NSObject <JSTAPIToolsURLMapping>

@end
```

- And implement the only required method providing the APItools host for every host that you expect your app to send requests to. Example:

```objc
@implementation MyURLMappingProvider
- (NSString *)apiToolsHostForOriginalURLHost:(NSString *)originalURLHost {
  static NSDictionary *URLMappingDitionary = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    URLMappingDitionary = @{
                            @"api.twitter.com" : @"tw-ghzbf45ab8cz.my.apitools.com",
                            @"api.facebook.com" : @"fb-cfb59af43bdz.my.apitools.com"
                            };
  });

  return URLMappingDitionary[originalURLHost];
}
@end
```

This will make your application forward all of its Twitter and Facebook API requests to your APItools account so you can track them, transform them and analyze them.

### Compatibility

`JSTAPIToolsURLProtocol` is compatible with iOS and Mac OSX.

### LICENSE

 `JSTAPIToolsURLProtocol` is available under the MIT license. See the LICENSE file for more info.