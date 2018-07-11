//
//  ShareManager.h
//  GCD多线程
//
//  Created by 胡志辉 on 2018/7/10.
//  Copyright © 2018年 胡志辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject
@property (nonatomic , copy) NSString *someProperty;
+(instancetype)shareManager;
+(instancetype)sharedManager;
@end
