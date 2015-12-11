//
//  RootViewController.m
//  lcFrameworkTest
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "RootViewController.h"

static NSString * const frameworkName       = @"lcFramework.framework";
static NSString * const frameworkFunction   = @"LCEntranceFramework";

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:@"进入" forState:UIControlStateNormal];
  button.frame = CGRectMake(100, 100, 80, 35);
  button.backgroundColor = [UIColor grayColor];
  [button addTarget:self action:@selector(nextButtonOnTapped) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:button];
}

- (void)nextButtonOnTapped {
  [self pushFramework];
}

- (void)pushFramework {
  
  NSString *destLibPath = [self documentDirectoryWithFileName:frameworkName];
  
  if (![self fileIsExist:destLibPath]) {
    return;
  }
  
  NSBundle *frameworkBundle = [NSBundle bundleWithPath:destLibPath];
  if (frameworkBundle && [frameworkBundle load]) {
    NSLog(@"bundle load framework success.");
  }else {
    NSLog(@"bundle load framework fail");
    return;
  }
  
  /*
   *通过NSClassFromString方式读取类
   *PacteraFramework　为动态库中入口类
   */
  Class pacteraClass = NSClassFromString(frameworkFunction);
  if (!pacteraClass) {
    NSLog(@"Unable to get TestDylib class");
    return;
  }
  
  NSObject *pacteraObject = [pacteraClass new];
  [pacteraObject performSelector:@selector(enterFramework:withBundle:) withObject:self withObject:frameworkBundle];
  
}

- (NSString *)documentDirectoryWithFileName:(NSString *)fileName {
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
  NSString *documentDirectory = nil;
  if ([paths count] != 0)
    documentDirectory = [paths objectAtIndex:0];
  return [documentDirectory stringByAppendingPathComponent:frameworkName];
}

- (BOOL)fileIsExist:(NSString *)filePath {
  NSFileManager *manager = [NSFileManager defaultManager];
  if (![manager fileExistsAtPath:filePath]) {
    NSLog(@"There isn't have the file");
    return NO;
  }
  return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
