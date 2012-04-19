# TJReadLater

Stupidly easy support for the [Instapaper](http://www.instapaper.com), [Pocket](http://getpocket.com/), [Readability](http://www.readability.com/), [Pinboard](http://pinboard.in/), [Kippt](http://kippt.com/), and [Delicious](http://www.delicious.com) bookmarking services on the iOS. Just `#import "TJReadLater.h"` and let 'er rip!

## TJReadingService

Each of the `TJInstapaper`, `TJPocket`, `TJReadability`, `TJPinboard`, `TJKippt`, and `TJDelicious` objects inherit from the `TJReadingService` object which exposes a common inerface for two simple bookmarking actions: **authorization**, and **saving a bookmark**. These are implemented as simple class methods with callbacks in the form of blocks, there is optional **authorization UI** added for convenience. You can access all of the available reading services by calling `+ (NSArray *)readingServices` on `TJReadingService`.

## Authorization

In order to authenticate a user with a service, simply call `+ (void)authorizeWithUsername:(NSString *)username password:(NSString *)password callback:(void (^)(BOOL success))callback`, once the authorization is complete, `callback` will be invoked on the main thread (if not `nil`) and `success` will indicate whether or not the authorization was successful. When successful auth occurs, the username/password combo is stored automatically. You can call `+ (BOOL)isLoggedIn` to determine whether or not a user is logged into the service, `+ (NSString *)username` to get the currently logged in user's username, and `+ (void)logout` to log out from the service.

Additionally, the `+ (NSString *)name` and `+ (NSString *)loginLabel` methods are in place to get the name of a given service and what should appear in the login label (i.e. "Username", "Email", or "Username/Email").

## Authorization UI

If manual authorization isn't your cup of tea, TJReadLater provides convenience view controllers for authorization of each service. Calling `+ (UIViewController *)authorizationViewController` on a `TJReadingService` provides a view controller that can automatically handle authorization, this view controller should be presented modally. The same `+ (BOOL)isLoggedIn`, `+ (void)logout`, and `+ (NSString *)username` methods work when using these view controllers.

## Saving a Bookmark

Bookmark saving is done via the `+ (void)saveURL:(NSString *)url title:(NSString *)title callback:(void (^)(BOOL success))callback` method. `url` is the deisred URL to be saved, `title` is the (optional) title of the link to be saved, and callback is invoked on the main thread (if not `nil`) at the completion of the save just like with auth. `success` indicates whether or not the operation was successful, just like with auth.

## Notes

- The Pocket API requires an [API Key](http://readitlaterlist.com/api/signup/). In order to use the TJReadItLater object, you must fill in `kTJReadItLaterAPIKey` and `kTJReadItLaterAppName` in TJReadLaterConfig.h. There is a `#warning` highlighting this.
- The Readability API requires [OAuth keys](http://www.readability.com/publishers/api). In order to use the TJReadability object, you must fill in `kTJReadLaterReadabilityOAuthConsumerKey` and `kTJReadLaterReadabilityOAuthConsumerSecret` in TJReadLaterConfig.h. There is a `#warning` highlighting this.
- Using TJReadLater? Please email about it, I'd love to hear about it! [tijoinc@gmail.com](mailto:tijoinc@gmail.com)

## TBD

- Make `saveURL:title:callback:` take `id` for URL and use either `NSURL` or `NSString`
- Provide more descriptive error messages in the callbacks
- Use newer, secure API endpoints that Instapaper and Pocket provide for storing tokens rather than passwords.
- Upgrade `TJDelicious` to use the del.icio.us v2 API
