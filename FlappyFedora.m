#import <Preferences/Preferences.h>
#import "FindAppContainer.h"

#define APP_NAME @"Flap"
#define APP_ID @"com.dotgears.flap"
#define RESOURCE_DIR @"/var/mobile/Documents/FlappyFedora"
#define ASSETS_DIR @"Assets"
#define BACKUP_DIR @"Backup"

NSFileManager *fileManager;
NSArray *assetFiles;
NSString *appLocation;

@interface FlappyFedoraListController: PSListController

- (void)backup;
- (void)copyAssetsFromDirectory:(NSString *)dir;

@end

@implementation FlappyFedoraListController

- (id)init {
	if((self = [super init])) {
		fileManager = [NSFileManager defaultManager];
		[fileManager changeCurrentDirectoryPath:RESOURCE_DIR];
		assetFiles = [fileManager contentsOfDirectoryAtPath:ASSETS_DIR error:nil];
		
		appLocation = [findAppContainer(APP_NAME, APP_ID) stringByAppendingPathComponent:APP_NAME @".app"];
		if(appLocation) {
			[self backup];
		}
	}
	
	return self;
}

- (id)specifiers {
	if(_specifiers == nil) {
		NSString *plistName = appLocation? @"FlappyFedora": @"FlappyFedoraFail";
		_specifiers = [self loadSpecifiersFromPlistName:plistName target:self];
	}
	return _specifiers;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	[super setPreferenceValue:value specifier:specifier];
	
	if([specifier.properties[@"key"] isEqualToString:@"enabled"]) {
		BOOL enabled = [value boolValue];
		
		system("killall flap");
	
		[self copyAssetsFromDirectory:enabled? ASSETS_DIR: BACKUP_DIR];
	}
}

- (void)backup {
	for(NSString *file in assetFiles) {
		NSString *backupFile = [BACKUP_DIR stringByAppendingPathComponent:file];
		if(![fileManager fileExistsAtPath:backupFile]) {
			NSString *appFile = [appLocation stringByAppendingPathComponent:file];
			[self overwriteAndcopyItemAtPath:appFile toPath:backupFile error:nil];
		}
	}
}

- (void)copyAssetsFromDirectory:(NSString *)dir {
	for(NSString *file in assetFiles) {
		NSString *sourceFile = [dir stringByAppendingPathComponent:file];
		NSString *appFile = [appLocation stringByAppendingPathComponent:file];
		[self overwriteAndcopyItemAtPath:sourceFile toPath:appFile error:nil];
	}
}

- (BOOL)overwriteAndcopyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error {
	if(![fileManager removeItemAtPath:dstPath error:error]) {
		return NO;
	}
	
	if(![fileManager copyItemAtPath:srcPath toPath:dstPath error:error]) {
		return NO;
	}
	
	return YES;
}

@end
