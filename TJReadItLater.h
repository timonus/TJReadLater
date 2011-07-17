// TJReadItLater
// By Tim Johnsen

@protocol TJReadItLaterDelegate

@optional
-(void)authFinishedWithResult:(BOOL)result;
-(void)saveFinishedWithResult:(BOOL)result;

@end

@interface TJReadItLater : NSObject {
	NSURLConnection *authConnection;
	NSMutableData *authData;
	id authDelegate;
	id authUsername, authPassword;
	
	NSURLConnection *saveConnection;
	NSMutableData *saveData;
	id saveDelegate;
}

+(NSString *)name;
+(NSString *)loginLabel;

+(BOOL)hasAuth;
+(NSString *)username;
+(void)logout;

+(void)authWithUsername:(NSString *)username password:(NSString *)password delegate:(id)delegate;
+(BOOL)saveURL:(NSString *)url title:(NSString *)title delegate:(id)delegate;

@end