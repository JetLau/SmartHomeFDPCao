//
//  CaoConfig.m
//  SmartHomeFDP
//
//  Created by cisl on 15/8/25.
//  Copyright (c) 2015年 eddie. All rights reserved.
//

#import "CaoConfig.h"
int const MDNSRestartTime = 15;

@implementation CaoConfig
/*
 This method start the transmitting the data to connected
 AP. Nerwork validation is also done here. All exceptions from
 library is handled.
 */
-(void)startConfig:(NSString *)wifi password:(NSString *)password{
    self.wifiSSID = [NSString stringWithString:wifi];
    self.password = [NSString stringWithString:password];
    // init mdns service，this must be involved
    self.mdnsService = [SmartConfigDiscoverMDNS getInstance];
    
    @try {
        [self connectLibrary];
        if (self.firstTimeConfig == nil) {
            return;
        }
        [self sendAction];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s exception == %@",__FUNCTION__,[exception description]);
        [self performSelectorOnMainThread:@selector(alertWithMessage:) withObject:[exception description] waitUntilDone:NO];
        
    }
    @finally {
    }

}



// check for internet and initiate the libary object for further transmit.
-(void) connectLibrary
{
    
    
    @try {
        [self disconnectFromLibrary];
        
        //self.passwordKey = [self.password length] ? self.tfPasd.text : nil;
        
        NSData *encryptionData = Nil;
        
        self.freeData = [NSData alloc];
        
        self.freeData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSString *ipAddress = [FirstTimeConfig getGatewayAddress];
        self.firstTimeConfig = [[FirstTimeConfig alloc] initWithData:ipAddress withSSID:self.wifiSSID withKey:self.password withFreeData:self.freeData withEncryptionKey:encryptionData numberOfSetups:4 numberOfSyncs:10 syncLength1:3 syncLength2:23 delayInMicroSeconds:1000];
        
        [self mDnsDiscoverStart];
        // set timer to fire mDNS after 15 seconds
        self.mdnsTimer = [NSTimer scheduledTimerWithTimeInterval:MDNSRestartTime target:self selector:@selector(mDnsDiscoverStart) userInfo:nil repeats:NO];
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"%s exception == %@",__FUNCTION__,[exception description]);
        [self performSelectorOnMainThread:@selector(alertWithMessage:) withObject:[exception description] waitUntilDone:NO];
    }
    
}
/*
 This method begins configuration transmit
 In case of a failure the method throws an OSFailureException.
 */
-(void) sendAction{
    @try {
        NSLog(@"%s begin", __PRETTY_FUNCTION__);
        [self.firstTimeConfig transmitSettings];
        NSLog(@"%s end", __PRETTY_FUNCTION__);
    }
    @catch (NSException *exception) {
        NSLog(@"exception === %@",[exception description]);
        [self performSelectorOnMainThread:@selector(alertWithMessage:) withObject:[exception description] waitUntilDone:NO];
    }
    @finally {
        
    }
}


- (void) mDnsDiscoverStart {
    [self.mdnsService startMDNSDiscovery:@""];
}

- (void) mDnsDiscoverStop {
    NSLog(@"ViewContorller---------------->mDnsDiscoverStop");
    [self.mdnsService stopMDNSDiscovery];
    
}

-(void) stopDiscovery {
    [self.mdnsTimer invalidate];
    [self.firstTimeConfig stopTransmitting];
    [self mDnsDiscoverStop];
    self.wifiSSID = nil;
    self.password = nil;
    self.mdnsService = nil;

    
}


// disconnect libary method involves to release the existing object and assign nil.
-(void) disconnectFromLibrary
{
    
    //    if (updateTimer) {
    //        if([updateTimer isValid]) {
    //            [updateTimer invalidate];
    //            updateTimer= nil;
    //        }
    //    }
    self.firstTimeConfig = nil;
}

-(void) alertWithMessage :( NSString *) message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SimpleLink Notification" message:message delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

@end
