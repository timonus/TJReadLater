// TJInstapaper
// By Tim Johnsen

#import "TJInstapaper.h"


@implementation TJInstapaper

#pragma mark -
#pragma mark Strings

+ (NSString *)name {
	return @"Instapaper";
}

+ (NSString *)loginLabel {
	return @"Username/Email";
}

#pragma mark -
#pragma mark Authorization

+ (void)authorizeWithUsername:(NSString *)username password:(NSString *)password callback:(void (^)(BOOL success))callback {
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.instapaper.com/api/authenticate?username=%@&password=%@", username, password]]];
		
		[request setHTTPMethod:@"POST"];
		
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		BOOL success = !error && [(NSHTTPURLResponse *)response statusCode] == 200;
		
		if (success) {
			[[NSUserDefaults standardUserDefaults] setObject:username forKey:[NSString stringWithFormat:@"%@Username", [[self class] description]]];
			[[NSUserDefaults standardUserDefaults] setObject:password forKey:[NSString stringWithFormat:@"%@Password", [[self class] description]]];
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
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[@"https://www.instapaper.com/api/add" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
		[request setHTTPMethod:@"POST"];
		
		NSString *requestString = [NSString stringWithFormat:@"username=%@&password=%@&url=%@", [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Username", [[self class] description]]], [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@Password", [[self class] description]]], url];
		if (title) {
			requestString = [requestString stringByAppendingFormat:@"&title=%@", [title stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
		}
		NSData *requestData = [NSData dataWithBytes:[requestString UTF8String] length:[requestString length]];
		[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
		[request setHTTPBody:requestData];
		
		NSURLResponse *response = nil;
		NSError *error = nil;
		
		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		BOOL success = !error && [(NSHTTPURLResponse *)response statusCode] == 201;
		
		if (callback) {
			dispatch_async(dispatch_get_main_queue(), ^{
				callback(success);
			});
		}
	});
}

@end