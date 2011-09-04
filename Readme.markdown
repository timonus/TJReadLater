# TJReadLater

Stupidly easy support for the [Read It Later](http://www.readitlater.com), [Instapaper](http://www.instapaper.com), and [Delicious](http://www.delicious.com) bookmarking services on the iOS.

## TJReadingService

Each of the `TJReadItLater`, `TJInstapaper`, and `TJDelicious` objects inherit from the `TJReadingService` which exposes a common inerface for two simple bookmarking actions: **authorization**, and **saving a bookmark**. These are implemented as simple class methods with callbacks in the form of blocks.

## Authorization

In order to authenticate a user with a service, simply call `+ (void)authorizeWithUsername:(NSString *)username password:(NSString *)password callback:(void (^)(BOOL success))callback`, once the authorization is complete, `callback` will be invoked on the main thread (if not `nil`) and `success` will indicate whether or not the authorization was successful. When successful auth occurs, the username/password combo is stored automatically. You can call `+ (BOOL)isLoggedIn` to determine whether or not a user is logged in in the future, and `+ (void)logout` to log out from the service.

Additionally, the `+ (NSString *)name` and `+ (NSString *)loginLabel` methods are in place to get the name of a given service and what should appear in the login label (i.e. "Username", "Email", or "Username/Email"). TJReadLater doesn't currently provide view controllers for auth because the ones used in [tijo](http://www.tijoinc.com) apps are pretty customized.

## Saving a Bookmark

Bookmark saving is done via the `+ (void)saveURL:(NSString *)url title:(NSString *)title callback:(void (^)(BOOL success))callback` method. `url` is the deisred URL to be saved, `title` is the (optional) title of the link to be saved, and callback is invoked on the main thread (if not `nil`) at the completion of the save just like with auth. `success` indicates whether or not the operation was successful, just like with auth.

### TBD

- Provide easy-to-use view controllers for authorization
- Make `saveURL:title:callback:` take `id` for URL and use either `NSURL` or `NSString`
- Provide more descriptive error messages in the callbacks
- Upgrade `TJDelicious` to use the del.icio.us v2 API