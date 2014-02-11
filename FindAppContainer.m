#import "FindAppContainer.h"

#define APPS_PATH @"/var/mobile/Applications"

NSArray *findAppContainersWithName(NSString *name) {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSMutableArray *containers = [[NSMutableArray alloc] init];
	NSString *app = [name stringByAppendingString:@".app"];
	
	for(NSString *appContainer in [fileManager contentsOfDirectoryAtPath:APPS_PATH error:nil]) {
		NSString *appContainerPath = [APPS_PATH stringByAppendingPathComponent:appContainer];
		if([fileManager fileExistsAtPath:[appContainerPath stringByAppendingPathComponent:app]]) {
			[containers addObject:appContainerPath];
		}
	}
	
	return containers;
}

NSString *findAppContainer(NSString *name, NSString *bundleID) {
	NSArray *appContainers = findAppContainersWithName(name);
	NSString *app = [name stringByAppendingString:@".app"];
	for(NSString *appContainer in appContainers) {
		NSBundle *bundle = [NSBundle bundleWithPath:[appContainer stringByAppendingPathComponent:app]];
		if([[bundle bundleIdentifier] isEqualToString:bundleID]) {
			return appContainer;
		}
	}
	return nil;
}
