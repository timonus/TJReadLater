// TJReadingService
// By Tim Johnsen

#import "TJReadingService.h"
#import "TJReadLater.h"

@implementation TJReadingService

#pragma mark -
#pragma mark Strings

+ (NSString *)name {
	return nil;
}

+ (NSString *)loginLabel {
	return @"Username";
}

#pragma mark -
#pragma mark Authorization

+ (BOOL)isLoggedIn {
	return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", [[self class] description]]] != nil && [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", [[self class] description]]] != nil;
}

+ (NSString *)username {
	return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", [[self class] description]]];
}

+ (void)logout {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@Username", [[self class] description]]];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@Password", [[self class] description]]];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)authorizeWithUsername:(NSString *)username password:(NSString *)password callback:(void (^)(BOOL success))callback {
}

#pragma mark -
#pragma mark URL Saving

+ (void)saveURL:(NSString *)url title:(NSString *)title callback:(void (^)(BOOL success))callback {
}

#pragma mark -
#pragma mark Authorization View Controllers

+ (UIViewController *)authorizationViewController {
	return [[[UINavigationController alloc] initWithRootViewController:[[[TJReadingServiceViewController alloc] initWithService:self] autorelease]] autorelease];
}

#pragma mark -
#pragma mark All Services

+ (NSArray *)readingServices {
	return [NSArray arrayWithObjects:[TJInstapaper class], [TJReadItLater class], [TJDelicious class], nil];
}

@end
