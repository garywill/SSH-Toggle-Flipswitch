#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"

static NSString *filePath = @"/var/tmp/sshstate";
static BOOL sshEnabled;

@interface SSHToggleSwitch : NSObject <FSSwitchDataSource>
@end

@implementation SSHToggleSwitch

- (id)init
{
	if ((self = [super init])) {
        NSFileManager *manager = [NSFileManager defaultManager];
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
        NSData *data = [fileHandle readDataToEndOfFile];
        NSString *str = [[NSString alloc]initWithData:data
                                             encoding:NSUTF8StringEncoding];
        if ([str hasPrefix:@"1"]) {
            sshEnabled = YES;
        } else if (![manager fileExistsAtPath:filePath]) {
            sshEnabled = YES;
        } else {
            sshEnabled = NO;
        }
        [fileHandle closeFile];
	}
	return self;
}

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	return sshEnabled;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
    
    sshEnabled = newState;
    
    system("/Library/Switches/SSHToggle.bundle/sshtogglesw");
}

@end