// TJDelicious
// By Tim Johnsen

#import "TJDelicious.h"
#import "NSData+Base64.h"

@implementation TJDelicious

#pragma mark -
#pragma mark Strings

+ (NSString *)name {
	return @"delicious";
}

+ (NSString *)signUpURL {
	return @"http://delicious.com/register";
}

#pragma mark -
#pragma mark Authorization

+ (void)authorizeWithUsername:(NSString *)username password:(NSString *)password callback:(void (^)(BOOL success))callback {
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.del.icio.us/v1/posts/recent"]]];
		
		[request setValue:[NSString stringWithFormat:@"Basic %@", [[[NSString stringWithFormat:@"%@:%@", username, password] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString]] forHTTPHeaderField:@"Authorization"];
		
		[request setHTTPMethod:@"POST"];
		
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		BOOL success = !error && [(NSHTTPURLResponse *)response statusCode] == 200;
		
		if (success) {
			[[NSUserDefaults standardUserDefaults] setObject:username forKey:[NSString stringWithFormat:@"%@Username", NSStringFromClass(self)]];
			[[NSUserDefaults standardUserDefaults] setObject:password forKey:[NSString stringWithFormat:@"%@Password", NSStringFromClass(self)]];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		
		if (callback) {
			dispatch_async(dispatch_get_main_queue(), ^{
				callback(success);
			});
		}
	});
}

#pragma mark -
#pragma mark URL Saving

+ (void)saveURL:(NSString *)url title:(NSString *)title callback:(void (^)(BOOL success))callback {
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		
		NSString *requestString = [NSString stringWithFormat:@"https://api.del.icio.us/v1/posts/add?url=%@&description=%@", url, title ? title : url];
		if (!title) {
			NSLog(@"[TJReadLater] ERROR: delicious API does not support bookmarking without titles, adding URL as the title");
		}
		
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request setValue:[NSString stringWithFormat:@"Basic %@", [[[NSString stringWithFormat:@"%@:%@", [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", NSStringFromClass(self)]], [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", NSStringFromClass(self)]]] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString]] forHTTPHeaderField:@"Authorization"];
		[request setHTTPMethod:@"POST"];
		
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		BOOL success = !error && [(NSHTTPURLResponse *)response statusCode] == 200;
		
		if (callback) {
			dispatch_async(dispatch_get_main_queue(), ^{
				callback(success);
			});
		}
	});
}

@end
