//
//  ShareManager.m
//  GCD多线程
//
//  Created by 胡志辉 on 2018/7/10.
//  Copyright © 2018年 胡志辉. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager

static ShareManager * shareManager = nil;

//GCD实现
+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}


//非ARC下，非GCD，实现单例
+(instancetype)sharedManager{
    @synchronized(self){
        if (!shareManager) {
            shareManager = [[self alloc] init];
        }
    }
    return shareManager;
}



@end
