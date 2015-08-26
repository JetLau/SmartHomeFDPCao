//
//  OEMSAPIs.m
//  OfficeEMS
//
//  Created by kevin on 12-11-25.
//  Copyright (c) 2012年 cis. All rights reserved.
//

#import "SmartHomeAPIs.h"
#import "JSONKit.h"
#import "AFHTTPRequestOperationManager.h"
//#define ipAddr @"218.193.130.166"
//#define ipAddr @"192.168.0.7:8080"

@implementation SmartHomeAPIs

+ (void)setIpAddr:(NSString *)setting
{
    ipAddr = setting;
}

+ (NSDictionary *)toDictionary:(NSData *)data
{
    NSError *error;
//    if ([data isEqual:nil]) {
//        return nil;
//    }
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return json;
}

+(NSString *)GetIPAddress
{
    return ipAddr;
}

//1.1
+ (NSDictionary *)MobileLogin:(NSString *)username password:(NSString *)password
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/login.action?username=%@&&password=%@",ipAddr,username,password];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"error = %@",error);

    if (data)
    {
        NSLog(@"login in success %@",[self toDictionary:data]);
        return [self toDictionary:data];
    }
    else
    {
        NSLog(@"login in fail");
        return nil;
    }
    
    
    //__block NSDictionary *resultDic;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    AFHTTPRequestOperation *operation = [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@",responseObject);
//        //NSLog(@"is : %@",[[responseObject valueForKey:@"jsonMap"] valueForKey:@"result"]);
//        //resultDic = responseObject;
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    NSLog(@"dic: %@",operation.responseObject);
//    return nil;
}
//1.2
+ (NSDictionary *)MobileLogout
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/MyHomes/MobileLogout?sessionType=3", ipAddr];
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if (data)
        return [SmartHomeAPIs toDictionary:data];
    else
        return nil;
    
//    __block NSDictionary *resultDic;
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@",responseObject);
//        resultDic = [SmartHomeAPIs toDictionary:responseObject];
//        NSLog(@"dic: %@",resultDic);
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
//    
//    return resultDic;
}
//1.3
+ (NSDictionary *)MobileRegister:(NSMutableDictionary*)dic
{
    return nil;
}

//Remote
//2.1 添加遥控
+ (NSString *)AddRemote:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/updateRemote?updateRemoteRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];

    NSLog(@"error = %@",error);

    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);
            return @"success";
        }
    }
    return @"fail";
    
}

//2.2 删除遥控
+ (NSString *)DeleteRemote:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/updateRemote.action?updateRemoteRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
    return @"fail";
}

//2.3 遥控的按键学习
+ (NSString *)Rm2StudyData:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/studyMode.action?studyRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
    return @"fail";
}

//2.4 保存按钮的语音字段
+ (NSString *)SaveButtonVoice:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/saveVoice.action?saveVoiceRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
    NSLog(@"result: %@",data);

    return @"fail";
}

//2.5 修改按钮名称
+ (NSString *)ChangeBtnName:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/updateBtn.action?updateBtnRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
  //  NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

    return @"fail";
}

//2.6 修改遥控名称
+ (NSString *)ChangeRemoteName:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/updateRemote.action?updateRemoteRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
   // NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

    return @"fail";
}

//2.7 发送遥控命令
+ (NSString *)Rm2SendData:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/controlRemoteMode.action?ctlRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
    //NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

    return @"fail";
}

//2.8 删除按钮
+ (NSString *)deleteBtn:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/updateBtn.action?updateBtnRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
    //NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

    return @"fail";
}
//2.9 获取遥控列表
+ (NSDictionary *)GetRemoteList:(NSString *)username
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/refreshRemote?username=%@",ipAddr,username];
    NSLog(@"获取遥控列表url %@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"GetRemoteList error = %@", error);
    if(data)
    {
        //NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);
        
        return [SmartHomeAPIs toDictionary:data];
        
    }
    else
    {
        return nil;
    }

}


//3.1 获取TCP设备列表
+ (NSDictionary *)GetTCPDeviceList:(NSString *)username
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/getOneUserDevices.action?username=%@",ipAddr,username];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"GetTCPDeviceList error = %@", error);
    if(data)
    {
        NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);

        return [SmartHomeAPIs toDictionary:data];

    }
    else
    {
        return nil;
    }
}
//3.2 开操作（TCP灯、插座）
+ (NSString *)OpenTCPDevice:(NSString *)mac type:(NSString *)type
{
    NSDictionary *dic;
    if([type isEqualToString:@"light"])
    {
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:42],@"api_id",@"sp1_control",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:1],@"status",[[NSNumber alloc]initWithInt:0],@"op_method", nil];
    }
    else if([type isEqualToString:@"socket"])
    {
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:52],@"api_id",@"sp2_control",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:1],@"status",[[NSNumber alloc]initWithInt:0],@"op_method",  nil];
    }
    
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/controlMode.action?remoteCtlRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    NSLog(@"error = %@",error);

    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
        else
        {
            
            return [[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"message"];
        }
    }
    return @"fail";
}
//3.3 关操作（TCP灯、插座）
+ (NSString *)CloseTCPDevice:(NSString *)mac type:(NSString *)type
{
    NSDictionary *dic;
    if([type isEqualToString:@"light"])
    {
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:42],@"api_id",@"sp1_control",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:0],@"status",[[NSNumber alloc]initWithInt:0],@"op_method",  nil];
    }
    else if([type isEqualToString:@"socket"])
    {
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:52],@"api_id",@"sp2_control",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:0],@"status",[[NSNumber alloc]initWithInt:0],@"op_method",  nil];
    }
    
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/controlMode.action?remoteCtlRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);

    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
        else
        {
            
            return [[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"message"];
        }
    }
    return @"fail";
}
//3.4 设备解锁
+ (NSString *)AuthTCPDevice:(NSString *)mac type:(NSString *)type;
{
    NSDictionary *dic;
    if([type isEqualToString:@"light"])
    {
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:41],@"api_id",@"sp1_auth",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:1028000492],@"password", nil];
    }
    else if([type isEqualToString:@"socket"])
    {
        dic=[[NSDictionary alloc]initWithObjectsAndKeys:[[NSNumber alloc]initWithInt:51],@"api_id",@"sp2_auth",@"command",mac,@"mac",[[NSNumber alloc]initWithInt:1028000492],@"password", nil];
    }
    
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/controlMode.action?remoteCtlRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }
    }
    return @"fail";
}

//4.1 执行语音命令
+ (NSString *)OperateVoiceCommand:(NSString *)urlString
{
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

    if (data)
    {
        if ([[[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"result"] isEqualToString:@"success"])
        {
            NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);

            return @"success";
        }else
        {
            return [[[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"] objectForKey:@"message"];
        }
    }
    return @"Fail";
}

//5曹浩哲设备
//进入学习状态，获取code，发送code，由dic中内容决定
+ (NSDictionary *)CaoDevice:(NSMutableDictionary*)dic
{
    NSData *requestData = [dic JSONData];
    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    //NSLog(@"jsonString: %@",str);
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/controlMode_cao?remoteCtlRequest=%@",ipAddr,josnString];
    NSLog(@"%@",urlString);
    
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (data)
    {
        return [[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"];
    }
    //NSLog(@"result: %@",[SmartHomeAPIs toDictionary:data]);
    
    return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",@"未得到服务器返回",@"message",nil];
}
//5.1 进入学习状态
+ (NSString *)CaoEnterStudyWithMac:(NSString *)mac btnId:(int)btnId remoteName:(NSString*)remoteName
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:102] forKey:@"api_id"];
    [dic setObject:@"rm1_study" forKey:@"command"];
    [dic setObject:mac forKey:@"mac"];
    [dic setObject:[NSNumber numberWithInt:btnId] forKey:@"buttonId"];
    [dic setObject:remoteName forKey:@"remoteName"];

    NSDictionary * resultDic = [SmartHomeAPIs CaoDevice:dic];
    if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"])
    {
        NSLog(@"result: %@",resultDic);
        
        return @"success";
    }
    
    return [resultDic objectForKey:@"message"];
}

//5.2 获取控制码
+ (NSDictionary *)CaoGetCodeWithMac:(NSString *)mac btnId:(int)btnId remoteName:(NSString*)remoteName
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:103] forKey:@"api_id"];
    [dic setObject:@"rm1_code" forKey:@"command"];
    [dic setObject:mac forKey:@"mac"];
    [dic setObject:[NSNumber numberWithInt:btnId] forKey:@"buttonId"];
    [dic setObject:remoteName forKey:@"remoteName"];
    
    NSDictionary * resultDic = [SmartHomeAPIs CaoDevice:dic];
    return resultDic;
//    NSLog(@"message: %@",resultDic);
//    if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"])
//    {
//        NSLog(@"result: %@",resultDic);
//        
//        return [resultDic objectForKey:@"code"];
//    }
//    
//    return @"fail";

}

//5.3 发送控制码
+ (NSString *)CaoSendCodeWithMac:(NSString *)mac btnId:(int)btnId remoteName:(NSString*)remoteName data:(NSString*)data
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[NSNumber numberWithInt:104] forKey:@"api_id"];
    [dic setObject:@"rm1_send" forKey:@"command"];
    [dic setObject:mac forKey:@"mac"];
    [dic setObject:[NSNumber numberWithInt:btnId] forKey:@"buttonId"];
    [dic setObject:remoteName forKey:@"remoteName"];
    [dic setObject:data forKey:@"data"];
    
    NSDictionary * resultDic = [SmartHomeAPIs CaoDevice:dic];
    if ([[resultDic objectForKey:@"result"] isEqualToString:@"success"])
    {
        NSLog(@"result: %@",resultDic);
        
        return @"success";
    }
    
    return [resultDic objectForKey:@"message"];
    
}

//6获取gps数据
+ (NSDictionary *)GetGPSData:(int)num
{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
//    [dic setObject:[NSNumber numberWithInt:num] forKey:@"gpsDataNum"];
//    [dic setObject:@"860719021423573" forKey:@"IEME"];
//    NSData *requestData = [dic JSONData];
//    NSString *josnString = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
//    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/webUnable/getGPSData.action?IMEI=%@&gpsDataNum=%d",ipAddr,@"860719021423573",num];
    NSLog(@"获取遥控列表url %@",urlString);
    NSURL *url=[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    NSLog(@"GetGPSData error = %@", error);
    if(data)
    {
        //NSLog(@"data = %@", [SmartHomeAPIs toDictionary:data]);
        
        return [[SmartHomeAPIs toDictionary:data] objectForKey:@"jsonMap"];
        
    }
    else
    {
        return [[NSDictionary alloc]initWithObjectsAndKeys:@"fail",@"result",nil];
    }

}

@end
