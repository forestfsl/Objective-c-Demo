//
//  SLDataManager.m
//  WineMVVMDemo
//
//  Created by songlin on 30/10/2017.
//  Copyright © 2017 songlin. All rights reserved.
//

#import "SLDataManager.h"
#import "SLShoppingManager.h"


///购物车路径
NSString * const kShoppingPath = @"Documents/shoppingCar.plist";

/**
 *用户数据路径
 */
NSString * const kUserPath = @"Documents/user.plist";

@implementation SLDataManager

+ (void)saveUserData
{
    if ([NSKeyedArchiver archiveRootObject:[SLShoppingManager manager] toFile:[NSHomeDirectory() stringByAppendingPathComponent:kShoppingPath]])
    {
        NSLog(@"购物车数据保存成功");
    }
    
    if([NSKeyedArchiver archiveRootObject:[SLUser currentUser] toFile:[NSHomeDirectory() stringByAppendingPathComponent:kUserPath]])
    {
        NSLog(@"用户数据保存成功");
    }
    
}
///删除
+ (void)removeUserData
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:kUserPath];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"没有这个文件");
        return ;
    }else {
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
        
    }
}

///读取数据
+ (void)readUserData
{
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @strongify(self);
        NSString *shopPath = [NSHomeDirectory() stringByAppendingPathComponent:kShoppingPath];
        NSError *shopError;
        NSData *shopData = [NSData dataWithContentsOfFile:shopPath options:NSDataReadingMappedIfSafe error:&shopError];
        if (!shopError)
        {
            SLShoppingManager *manager = [NSKeyedUnarchiver unarchiveObjectWithData:shopData];
            [self setObj:[SLShoppingManager manager] fromObj:manager];
            NSLog(@"读取购物车数据成功");
        }
        
        NSString *userPath = [NSHomeDirectory() stringByAppendingPathComponent:kUserPath];
        NSError *userError;
        NSData *userData = [NSData dataWithContentsOfFile:userPath options:NSDataReadingMappedIfSafe error:&userError];
        if (!userError)
        {
            SLUser *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
            [self setObj:[SLUser currentUser] fromObj:user];
            [[NSNotificationCenter defaultCenter] postNotificationName:kReadUserDataFinish object:nil];
            NSLog(@"读取用户数据成功");
        }
    });
    
}


// obj1所有属性赋值给obj2   利用runtime
+ (void)setObj:(id)toObj
       fromObj:(id)fromObj
{
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([toObj class], &count);
    for (int i = 0; i < count; i++)
    {
        objc_property_t pro = propertyList[i];
        
        const char *name = property_getName(pro);
        NSString *key = [NSString stringWithUTF8String:name];
#warning 不为空的时候赋值，防止以后添加新的类，读取时无法设置默认值
        if ([fromObj valueForKey:key])
        {
            [toObj setValue:[fromObj valueForKey:key] forKey:key];
        }
    }
}

@end
