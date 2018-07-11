//
//  ViewController.m
//  GCD多线程
//
//  Created by 胡志辉 on 2018/7/9.
//  Copyright © 2018年 胡志辉. All rights reserved.
//

#import "ViewController.h"
#import "ShareManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    ShareManager * shareManager = [ShareManager sharedManager];
//    获取主线程
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    NSLog(@"start");
    
//  主线程下面同步执行操作会产生死锁,block里面的语句执行不到
//    dispatch_sync(mainQueue, ^{
//        NSLog(@"mainQueue");
//    });
//    主线程异步执行操作不会产生死锁，程序照常运行
    dispatch_async(mainQueue, ^{
        NSLog(@"mainQueue");
    });
    
/*
//    子线程回到主线程更新UI
//    获取子线程，这个子线程是系统就有的，直接获取就好了
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
//       子线程异步执行下载操作，防止死锁
        NSURL * url = [NSURL URLWithString:@"https://www.baidu.com"];
        NSError * error;
        NSString * string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
        if (string != nil) {
//            异步返回主线程更新UI
            dispatch_async(mainQueue, ^{
                NSLog(@"更新UI界面");
            });
        }else{
            NSLog(@"error is %@:",error);
        }
    });
 */
    
//    全局并发队列同步执行任务会造成界面卡帧
//    [self globalQueue];
//    [self globalQueue2];
    
/**
* 自定义串行队列*
 */
//   异步任务嵌套异步任务，代码都能被执行到
//    [self customQueue4];
//    异步任务嵌套同步任务，同步任务不会被执行到，会产生死锁
//    [self customQueue3];
//    同步执行任务
//    [self customQueue];
//    同步任务嵌套同步任务，会产生死锁
//    [self customQueue2];
    
/**
 *自定义并发队列*
 */
//    同步任务
//    [self conCurrentQueue];
//    异步任务
//    [self conCurrentQueue2];
//    同步任务嵌套同步任务，正常运行
//    [self conCurrentQueue3];
//    同步任务嵌套异步任务
//    [self conCurrentQueue4];
//    异步任务嵌套异步任务
//    [self conCurrentQueue5];
    
    
 /**
  *队列数组*
  */
//   队列组示例
//    [self groupQueue];
//    串行队列阻塞线程，会在阻塞完成后执行后面的代码
//    [self groupQueue2];
//    并发队列阻塞线程，阻塞的同时，还是会执行其他的任务
//    [self groupQueue3];
    
    
/**
 *barrier*
 */
//    dispath_barrier_async
    [self barrier];
}


/****************************全局并发队列****************************/
-(void)globalQueue{
//    获取子线程
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"start task");
//    子线程同步处理数据，会造成界面卡帧
    dispatch_sync(globalQueue, ^{
        sleep(2.0);
        NSLog(@"sleep 2.0");
    });
    NSLog(@"finish task");
}

//全局队列异步执行任务，会开辟子线程去处理，不会造成界面卡帧
-(void)globalQueue2{
//    获取子线程
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"start task");
//    子线程异步处理任务
    dispatch_async(globalQueue, ^{
        sleep(2.0);
        NSLog(@"sleep 2.0");
    });
    NSLog(@"finish task");
}

//多个全局并发队列异步执行任务
-(void)globalQueue3{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"start");
    dispatch_async(globalQueue, ^{
        NSLog(@"first ----");
    });
    dispatch_async(globalQueue, ^{
        NSLog(@"second ----");
    });
    NSLog(@"finish");
}


/**********************************自定义队列************************/

///自定义串行队列同步执行任务
-(void)customQueue{
    //获取自定义串行队列
    dispatch_queue_t customQueue = dispatch_queue_create("com.hzh.custom", DISPATCH_QUEUE_SERIAL);
    NSLog(@"start");
//    自定义串行队列同步执行任务
    dispatch_sync(customQueue, ^{
        NSLog(@"first");
    });
    dispatch_sync(customQueue, ^{
        NSLog(@"second");
    });
    NSLog(@"finish");
}

///自定义串行队列同步任务嵌套同步任务，会产生死锁
-(void)customQueue2{
    dispatch_queue_t customQueue = dispatch_queue_create("com.hzh.custom", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(customQueue, ^{
        NSLog(@"会执行代码");
        dispatch_sync(customQueue, ^{//该代码段后面的代码都不会执行，程序被锁定在这里
            NSLog(@"不会执行代码");
        });
    });
}

///自定义串行队列异步任务嵌套同步任务，同步任务不会被执行，其他任务照常执行，会产生死锁
-(void)customQueue3{
    dispatch_queue_t custonQueue = dispatch_queue_create("com.hzh.custom", DISPATCH_QUEUE_SERIAL);
    dispatch_async(custonQueue, ^{
        NSLog(@"会执行代码");
        dispatch_sync(custonQueue, ^{//改代码后面的代码不会执行，程序被锁定在这里
            NSLog(@"不会执行代码");
        });
    });
}

///自定义串行队列异步任务嵌套异步任务,代码都能被执行
-(void)customQueue4{
    dispatch_queue_t custonQueue = dispatch_queue_create("com.hzh.custom", DISPATCH_QUEUE_SERIAL);
    dispatch_async(custonQueue, ^{
        NSLog(@"会执行代码");
        dispatch_async(custonQueue, ^{
            NSLog(@"会执行代码");
        });
    });
}

/**************************自定义并发队列***********************/
///自定义并发队列同步进行任务
-(void)conCurrentQueue{
//    创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.hzh.conCurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"concurrent ----");
//    同步任务
    dispatch_sync(queue, ^{
        NSLog(@"同步代码1");
    });
    dispatch_sync(queue, ^{
        NSLog(@"同步代码2");
    });
    NSLog(@"conCurrent ----");
}

///自定义并发队列异步执行任务
-(void)conCurrentQueue2{
//    创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.hzh.conCurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"conCurrent ----");
//    异步执行任务
    dispatch_async(queue, ^{
        NSLog(@"异步任务1");
    });
    dispatch_async(queue, ^{
        NSLog(@"异步任务2");
    });
    NSLog(@"conCurrent ----");
}
///自定义并发队列，同步任务里面嵌套同步任务,程序正常运行
-(void)conCurrentQueue3{
    dispatch_queue_t queue = dispatch_queue_create("com.hzh.conCurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"conCurrent ----");
//    同步任务
    dispatch_sync(queue, ^{
        NSLog(@"执行代码");
        dispatch_sync(queue, ^{
            NSLog(@"执行代码");
        });
    });
    NSLog(@"conCurrent ----");
}

///自定义队列，同步任务嵌套异步任务
-(void)conCurrentQueue4{
//    创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.hzh.conCurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"conCurrent ---");
    //同步任务
    dispatch_sync(queue, ^{
        NSLog(@"执行代码");
        //异步任务
        dispatch_async(queue, ^{
            NSLog(@"执行代码");
        });
    });
    NSLog(@"conCurrent ---");
    
}
///自定义队列，异步任务嵌套异步任务
-(void)conCurrentQueue5{
//    创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.hzh.conCurrent", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"conCurrent ---");
//    异步任务
    dispatch_async(queue, ^{
        NSLog(@"执行代码");
        //异步任务
        dispatch_async(queue, ^{
            NSLog(@"执行代码");
        });
    });
    NSLog(@"conCurrent ---");
}

/*****************************队列组**************************/
/*
 使用场景： 同时下载多个图片，所有图片下载完成之后去更新UI（需要回到主线程）或者去处理其他任务（可以是其他线程队列）。
 原理：使用函数dispatch_group_create创建dispatch group,然后使用函数dispatch_group_async来将要执行的block任务提交到一个dispatch queue。同时将他们添加到一个组，等要执行的block任务全部执行完成之后，使用dispatch_group_notify函数接收完成时的消息。
 */

///队列组示例
-(void)groupQueue{
//    获取子线程globalqueue
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    获取主线程
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    获取队列组
    dispatch_group_t groupQueue = dispatch_group_create();
    
    NSLog(@"groupQueue ---");
    dispatch_group_async(groupQueue, globalQueue, ^{
        NSLog(@"并行任务1");
    });
    dispatch_group_async(groupQueue, globalQueue, ^{
        NSLog(@"并行任务2");
    });
    dispatch_group_notify(groupQueue, mainQueue, ^{
        NSLog(@"group队列中的任务全部执行完成后，就回到主线程更新UI");
    });
    NSLog(@"groupQueue ----");
}

///在当前线程阻塞的同步等待dispatch_group_wait,串行队列
-(void)groupQueue2{
//    创建队列组
    dispatch_group_t groupQueue = dispatch_group_create();
//    延时时间
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC);
//    创建一个队列
    dispatch_queue_t globalQueue = dispatch_queue_create("com.hzh.group", DISPATCH_QUEUE_SERIAL);
    dispatch_group_async(groupQueue, globalQueue, ^{
        long isExcuteOver = dispatch_group_wait(groupQueue, delayTime);
        if (isExcuteOver) {
            NSLog(@"wait over");
        }else{
            NSLog(@"not over");
        }
    });
    dispatch_group_async(groupQueue, globalQueue, ^{
        NSLog(@"串行任务2");
    });
}

///在当前线程阻塞的同步等待dispatch_group_wait,并发队列
-(void)groupQueue3{
//    创建队列组
    dispatch_group_t groupQueue = dispatch_group_create();
//    创建并发对垒
    dispatch_queue_t conCurrentQueue = dispatch_queue_create("com.hzh.conCurrent", DISPATCH_QUEUE_CONCURRENT);
//    延时时间
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    
    dispatch_group_async(groupQueue, conCurrentQueue, ^{
        long isExcuteOver = dispatch_group_wait(groupQueue, delayTime);
        if (isExcuteOver) {
            NSLog(@"wait over");
        }else{
            NSLog(@"not over");
        }
    });
    dispatch_group_async(groupQueue, conCurrentQueue, ^{
        NSLog(@"并发任务2");
    });
}

#pragma mark dispatch_barrier_async
/*
 功能：是在并行队列中，等待在dispatch_barrier_async之前加入的队列全部执行完成之后（这些任务是并发执行的）再执行dispatch_barrier_async中的任务，dispatch_barrier_async中的任务执行完成之后，再去执行在dispatch_barrier_async之后加入到队列中的任务（这些任务是并发执行的）
 */

///dispatch_barrier_async示例
-(void)barrier{
//    创建并发队列
    dispatch_queue_t conCurrentQueue = dispatch_queue_create("com.hzh.conCuurent", DISPATCH_QUEUE_CONCURRENT);
//    异步任务
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"任务1");
    });
    dispatch_async(conCurrentQueue, ^{
        sleep(2.0);
        NSLog(@"任务2");
    });
    dispatch_barrier_sync(conCurrentQueue, ^{
        sleep(2.0);
        NSLog(@"任务3");
    });
    dispatch_async(conCurrentQueue, ^{
        NSLog(@"任务4");
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
