//
//  StartViewController.m
//  game
//
//  Created by pepinot on 16/3/23.
//  Copyright © 2016年 CMC. All rights reserved.
//

#import "StartViewController.h"
#import "NavigationControllerDelegate.h"


@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
}

@end