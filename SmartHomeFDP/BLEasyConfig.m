//
//  BLEasyConfig.m
//  SmartHomeFDP
//
//  Created by eddie on 14-11-21.
//  Copyright (c) 2014年 eddie. All rights reserved.
//

#import "BLEasyConfig.h"
#import "JSONKit.h"

@implementation BLEasyConfig

//-(void)initEasyConfig
//{
//    netWork = [[BLNetwork alloc]init];
//}
//
//-(void)startConfig:(NSString *)wifi password:(NSString *)password
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//                [dic setObject:[NSNumber numberWithInt:10000] forKey:@"api_id"];
//                [dic setObject:@"easyconfig" forKey:@"command"];
//                [dic setObject:wifi forKey:@"ssid"];
//                [dic setObject:password forKey:@"password"];
//        #warning If your device is v1, this field set 0.
//                [dic setObject:[NSNumber numberWithInt:1] forKey:@"broadlinkv2"];
//        #warning This filed is your route's gateway address.
//                [dic setObject:@"192.168.1.1" forKey:@"dst"];
//        
//                NSData *requestData = [dic JSONData];
//        
//                NSData *responseData = [netWork requestDispatch:requestData];
//                NSLog(@"%@", [responseData objectFromJSONData]);
//        
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[responseData objectFromJSONData] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                        [alertView show];
//        });
//    });
//}
//
//-(void)cancelConfig
//{
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//        [dic setObject:[NSNumber numberWithInt:10001] forKey:@"api_id"];
//        [dic setObject:@"cancel_easyconfig" forKey:@"command"];
//    
//        NSData *requestData = [dic JSONData];
//    
//        NSData *responseData = [netWork requestDispatch:requestData];
//        NSLog(@"%@", [responseData objectFromJSONData]);
//    
//        dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[[responseData objectFromJSONData] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alertView show];
//            });
//        });
//}

@end
