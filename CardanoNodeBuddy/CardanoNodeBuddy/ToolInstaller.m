//
//  ToolInstaller.m
//  CardanoNodeBuddy
//
//  Created by Jon Bauer on 12/3/22.
//

#import <Foundation/Foundation.h>

@implementation ToolInstaller : NSObject

+(BOOL)install {
    NSString * const kInstallerName = @"install.sh";
    NSString * const kToolName = @"cardano-node-buddy";
    NSString * const kToolInstallPath = [NSString stringWithFormat:@"/usr/local/bin/%@", kToolName];
    
    AuthorizationRef authorization;
    OSStatus status = AuthorizationCreate(NULL, NULL, kAuthorizationFlagDefaults, &authorization);
    if (status == errAuthorizationSuccess) {
        AuthorizationItem items = {kAuthorizationRightExecute, 0, NULL, 0};
        AuthorizationRights rights = {1, &items};
        status = AuthorizationCopyRights(authorization, &rights, NULL, kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagExtendRights | kAuthorizationFlagPreAuthorize, NULL);
        if (status == errAuthorizationSuccess) {
            NSString *sharedSupportPath = NSBundle.mainBundle.sharedSupportPath;
            NSString *installerPath = [sharedSupportPath stringByAppendingPathComponent:kInstallerName];
            NSString *toolPath = [sharedSupportPath stringByAppendingPathComponent:kToolName];
            char *arguments[] = {(char *)toolPath.fileSystemRepresentation,
                (char *)kToolInstallPath.fileSystemRepresentation, NULL};
                FILE *communicationPipe = NULL;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            
            status = AuthorizationExecuteWithPrivileges(authorization, installerPath.fileSystemRepresentation, kAuthorizationFlagDefaults, arguments, &communicationPipe);
#pragma clang diagnostic pop
            if (status == errAuthorizationSuccess) {
                char buffer[128];
                ssize_t count = read(fileno(communicationPipe), buffer, sizeof(buffer));
                NSData *data = [[NSData alloc] initWithBytes:buffer length:count];
                NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                if (![result isEqualToString:@"OK"]) {
                    status = -1; // Code doesn't matter
                }
            }
        }
        AuthorizationFree(authorization, kAuthorizationFlagDefaults);
    }
    return status == errAuthorizationSuccess;
}

@end
