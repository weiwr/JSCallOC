//
//  UIWebViewController.m
//  JSCallOC
//
//  Created by hmw on 2019/4/29.
//  Copyright © 2019 hmw. All rights reserved.
//

#import "UIWebViewController.h"
#import "ELLiveJSModel.h"

#define kScreenWidth                [UIScreen mainScreen].bounds.size.width
#define kScreenHeight               [UIScreen mainScreen].bounds.size.height

@interface UIWebViewController ()<UIWebViewDelegate,JSObjcWebViewDelegate>
@property (nonatomic, strong) UIWebView *webV;
@property (nonatomic, strong) JSContext *JSContext;
@end

@implementation UIWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"UIWebView";
    
    self.webV =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, kScreenHeight)];
    self.webV.backgroundColor = [UIColor whiteColor];
    //关闭水平滑动条
    self.webV.scrollView.showsHorizontalScrollIndicator = NO;
    //关闭垂直滑动条
    self.webV.scrollView.showsVerticalScrollIndicator = NO;
    self.webV.delegate = self;
    self.webV.scalesPageToFit = YES;
    [self.view addSubview:self.webV];

    //测试执行完成的进行回调的js
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"JavaScriptCore" ofType:@"html"];
    
    //测试js调oc方法的js
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    
    //测试js与oc模型传值
    NSString *path = [[NSBundle mainBundle] pathForResource:@"indexModel" ofType:@"html"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [self.webV loadRequest:request];
}

#pragma mark - WebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    __weak typeof(self) weakSelf = self;
    __strong typeof(self) strongSelf = weakSelf;
    
    _JSContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 打印异常
    _JSContext.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
    };
    
    //当web端是用XX.方法的时候,需要先实现代理方法
    self.JSContext[@"Native"] = self;
    
    //当web端直接调方法的时候
    self.JSContext[@"deliverValue"] = ^(NSString *str)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"this is a message" message:@"oc调用alert" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertControl addAction:cancelAction];
            [strongSelf.navigationController presentViewController:alertControl animated:YES completion:nil];
        });
    };
    
    self.JSContext[@"finishActivity"] = ^(NSString *str)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"this is a message" message:@"打开相册" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertControl addAction:cancelAction];
            [strongSelf.navigationController presentViewController:alertControl animated:YES completion:nil];
        });
    };
    
    self.JSContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        
    };
    
    return YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //设置标题
    self.navigationController.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    
    // model 的方法JS与OC交互
    ELLiveJSModel *jsModel = [ELLiveJSModel new];
    self.JSContext[@"testobject"] = jsModel;
    
    // 注意：jsModel 是在OC的对象名字，testobject 是在JS中的对象名字
    
    // 模拟JS调用方法
    NSString *jsCallOCModelFunction = @"testobject.description()";
    JSValue *valu = [self.JSContext evaluateScript:jsCallOCModelFunction];
    NSLog(@"vali----:%@",[valu toString]);  // 返回值
    
    NSLog(@"尚未赋值X的log:%f",jsModel.x);
    
    // 模拟JS调用方法 给testobject.x赋值
    NSString *jsCallOCModelFunction1 = @"testobject.x=30";
    [self.JSContext evaluateScript:jsCallOCModelFunction1];
    NSLog(@"jsCallOCFunction1----%f",jsModel.x);
    
    // JS双参数调用的例子
    NSString *jsCallOCModelFunction2 = @"testobject.makePointXPointY('20','50')";
    [self.JSContext evaluateScript:jsCallOCModelFunction2];
    NSLog(@"jsCallOCFunction2----%f",jsModel.x);
    
    [webView stringByEvaluatingJavaScriptFromString:@"appShare(title,desc,imgUrl)"];
}

//加载失败时调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if([error code] == NSURLErrorCancelled){
        return;
    }
}

#pragma mark - JSExport Methods JavaScriptCore的方法 主要是为了表现回调
- (void)callme:(NSString *)string
{
    NSLog(@"%@",string);
}

- (void)share:(NSString *)shareUrl
{
    NSLog(@"分享的url=%@",shareUrl);
    JSValue *shareCallBack = self.JSContext[@"shareCallBack"];
    [shareCallBack callWithArguments:nil];
}

#pragma mark - JSExport Methods index方法
- (NSString *)testggggg:(NSString *)shareUrl
{
    NSLog(@"testggggg-:%@",shareUrl);
    return @"分享成功";
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
