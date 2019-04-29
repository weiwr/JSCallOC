//
//  UIWebViewController.h
//  JSCallOC
//
//  Created by hmw on 2019/4/29.
//  Copyright © 2019 hmw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JSObjcWebViewDelegate <JSExport>

- (void)callme:(NSString *)string;

- (void)share:(NSString *)shareUrl;

- (NSString *)testggggg:(NSString *)shareUrl;

@end


@interface UIWebViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
