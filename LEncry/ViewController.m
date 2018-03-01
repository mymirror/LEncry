//
//  ViewController.m
//  LEncry
//
//  Created by ponted on 2018/3/1.
//  Copyright © 2018年 Shenzhen Blood Link Medical Technology Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "LEncry.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *arr = [[LEncry shareInstance] generateRSAKeyPair:1024];
    @autoreleasepool
    {
        while (![arr count])
        {
            arr = [[LEncry shareInstance] generateRSAKeyPair:1024];
            
            if ([arr count])
            {
                
                break;
            }
        }
    }
    NSString *str1 = [[LEncry shareInstance] encryRSA:@"123" publicKeyBase64:arr[0]];
    NSLog(@"str1 : %@",str1);
    NSString *str2 = [[LEncry shareInstance] decryRSA:str1 privateKeyBase64:arr[1]];
    NSLog(@"str2 : %@",str2);
    
    NSString *str3 = [[LEncry shareInstance] encryptAES:@"789" key:@"11112222"];
    NSLog(@"str3 : %@",str3);
    NSString *str4 = [[LEncry shareInstance] decryptAES:str3 key:@"11112222"];
    NSLog(@"str4 : %@",str4);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
