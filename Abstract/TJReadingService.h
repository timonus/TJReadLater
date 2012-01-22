// TJReadingService
// By Tim Johnsen

@interface TJReadingService : NSObject

+ (NSString *)name;
+ (NSString *)loginLabel;
+ (NSString *)signUpURL;

+ (BOOL)isLoggedIn;
+ (NSString *)username;
+ (void)logout;
+ (void)saveUsername:(NSString *)username password:(NSString *)password;

+ (void)authorizeWithUsername:(NSString *)username password:(NSString *)password callback:(void (^)(BOOL success))callback;
+ (void)saveURL:(NSString *)url title:(NSString *)title callback:(void (^)(BOOL success))callback;

+ (UIViewController *)authorizationViewController;

+ (NSArray *)readingServices;

@end
