// TJReadingService
// By Tim Johnsen

@interface TJReadingService : NSObject

+ (NSString *)name;
+ (NSString *)loginLabel;

+ (BOOL)isLoggedIn;
+ (NSString *)username;
+ (void)logout;

+ (void)authorizeWithUsername:(NSString *)username password:(NSString *)password callback:(void (^)(BOOL success))callback;
+ (void)saveURL:(NSString *)url title:(NSString *)title callback:(void (^)(BOOL success))callback;

@end
