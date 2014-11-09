//
//  ZCAppDelegate.m
//  NSThreadDemo_1418
//
//  Created by zhangcheng on 14-9-16.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "ZCAppDelegate.h"

@implementation ZCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self createTheard];
    [self.window makeKeyAndVisible];
    return YES;
}
//多线程
-(void)createTheard{
    //多线程有三种创建方式
    //第一种， 自动创建
    [NSThread detachNewThreadSelector:@selector(newTread) toTarget:self withObject:nil];
    
    NSLog(@"主线程");
    //我们通过以上例子，可以知道开辟一条线程，用于数据的处理，不会阻碍当前主线程的运行，常用于大数据的处理，里面的内容处理完成后，线程运行完成，线程会自动销毁
    
    //第二种，使用手动创建
    //有时候我们创建完线程并不需要马上运行，需要在适当的时候运行，所以需要手动创建，并且可以获得线程的指针，随时在主线程，给分线程发送消息
    NSThread*thread=[[NSThread alloc]initWithTarget:self selector:@selector(threadClick) object:nil];
    
    //开始运行该线程
    [thread start];
    
    //2秒以后执行一个方法 给线程中发送取消线程运行的指令
    [self performSelector:@selector(threadCancel:) withObject:thread afterDelay:5];
    
    //通过以上例子我们可以发现cancel他是给线程发一条消息，告诉线程你要进行取消操作，线程中进行判断，执行取消

    //第三种，系统开启一条线程进行后台处理
    
    [self performSelectorInBackground:@selector(systemThread) withObject:nil];
    
    
    //队列下载任务
    NSOperationQueue*queue=[NSOperationQueue currentQueue];
    //设置队列同时开始任务数
    queue.maxConcurrentOperationCount=2;
    
    //向队列中添加任务，添加任务有2种方式
    NSInvocationOperation*inv=[[NSInvocationOperation alloc]initWithTarget:self selector:@selector(invClick) object:nil];
    [queue addOperation:inv];
    
    NSBlockOperation*block=[NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"队列任务2");
    }];
    [queue addOperation:block];
    
}
-(void)invClick{
    NSLog(@"队列任务1");

}

//开启的是系统后台的线程
-(void)systemThread{

//进行一些数据运算，当数据运算完成后，我们需要回到主线程，有2种方式可以回到主线程
    //使用GCD回到主线程
    dispatch_async(dispatch_get_main_queue(), ^{
       //回到主线程
        NSLog(@"回到主线程");
        
    });
    
    NSLog(@"还在运行");
    
    //回到系统主线程
    [self performSelectorOnMainThread:@selector(MainClick) withObject:nil waitUntilDone:YES];
    

}
-(void)MainClick{
    NSLog(@"回到系统主线程中");

}
//取消线程
-(void)threadCancel:(NSThread*)thread{
    [thread cancel];

}
-(void)threadClick{
    NSLog(@"第二种方式创建");
    
    while (1) {
        //获得当前线程的指针，注意此函数内并不是在主线程中运行的，而是分线程中运行的
        NSThread*thread=[NSThread currentThread];
        //判断外部是否取消了该线程的运行
        if ([thread isCancelled]) {
            NSLog(@"取消该线程");
            return;
        }
        NSLog(@"22222222");
        
    }
    
}
-(void)newTread{
//当前函数为在分线程中
    while (1) {
       // NSLog(@"1111111");
    }
    NSLog(@"分线程");
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
