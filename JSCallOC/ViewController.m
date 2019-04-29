//
//  ViewController.m
//  JSCallOC
//
//  Created by hmw on 2019/4/29.
//  Copyright © 2019 hmw. All rights reserved.
//

#import "ViewController.h"
#import "WKWebViewController.h"
#import "UIWebViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 100, 200, 30);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"WKWebView交互" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(wKWebViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.frame = CGRectMake(50, 150, 200, 30);
    secondButton.backgroundColor = [UIColor magentaColor];
    [secondButton setTitle:@"UIWebView交互" forState:UIControlStateNormal];
    [secondButton addTarget:self action:@selector(uIWebViewButtonButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondButton];
}

- (void)wKWebViewButtonAction:(id)sender
{
    WKWebViewController *jSCallOCViewController = [[WKWebViewController alloc] init];
    [self.navigationController pushViewController:jSCallOCViewController animated:YES];
}

- (void)uIWebViewButtonButtonAction:(id)sender
{
    UIWebViewController *oCCallJSViewController = [[UIWebViewController alloc] init];
    [self.navigationController pushViewController:oCCallJSViewController animated:YES];
}



@end
