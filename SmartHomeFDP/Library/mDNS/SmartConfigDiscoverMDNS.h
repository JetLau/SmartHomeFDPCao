//
//  Copyright (c) 2014 Texas Instruments. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <netinet/in.h>
#include <arpa/inet.h>


@interface SmartConfigDiscoverMDNS : NSObject <NSNetServiceBrowserDelegate>
@property (nonatomic) NSNetServiceBrowser *netServiceBrowser;
@property (retain) NSMutableArray *netServices;
@property (nonatomic, retain) NSString *deviceName;
+(SmartConfigDiscoverMDNS *)getInstance;


- (void) startMDNSDiscovery:(NSString*)deviceName;
-(void) stopMDNSDiscovery;
@end
