#import "SBIconView.h"
#import "SBIconLegibilityLabelView.h"
#import "SBIconLabelImageParameters.h"
//判断手势的全局变量
static CGPoint gestureStartPoint;
//图标的新名字
static NSString * NewIconName;
%hook SBIconView

%new
//判断手势是向上滑动执行的方法
-(void)handleSwipeFrom
{
	NSString * bundleID = [[self icon] applicationBundleID];
	//NSLog(@"gfggfgaaaaa--%@",bundleID);
	if (bundleID)
	{
		UIViewController * currentVC = [self getCurrentVC];
		//NSLog(@"gfggfgcurrentVC--%@",currentVC);
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:bundleID message:nil preferredStyle: UIAlertControllerStyleActionSheet];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        	
    	}];
		UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"复制BundleID" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        	UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
			pastboard.string = bundleID;
    	}];
    	UIAlertAction *ReNameIcon = [UIAlertAction actionWithTitle:@"图标重命名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    		SBIconLegibilityLabelView * labelView = [self labelView];
    		SBIconLabelImageParameters * Parameters = [labelView imageParameters];
    		NSString *title = [NSString stringWithFormat:@"%@ 图标重命名",Parameters.text];
        	UIAlertController *ReNameAlertVC = [UIAlertController alertControllerWithTitle:title message:@"请输入新的名称" preferredStyle:UIAlertControllerStyleAlert];
        	UIAlertAction* actionDefault = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        		//NSLog(@"titleOne is pressed--%@",[ReNameAlertVC.textFields firstObject].text);
    		}];
    
    		UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        		//NSLog(@"titleThree is pressed");
    		}];
    		[ReNameAlertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {

    		}];
    		[ReNameAlertVC addAction:actionDefault];
    		[ReNameAlertVC addAction:actionCancel];
    		[currentVC presentViewController:ReNameAlertVC animated:YES completion:nil];
    	}];

		[alertController addAction:cancelAction];
		[alertController addAction:archiveAction];
		[alertController addAction:ReNameIcon];
		[currentVC presentViewController:alertController animated:YES completion:nil];
	}
}


%new
//获取当前的VC
- (UIViewController *)getCurrentVC {
    
    UIViewController* result = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (1) {
        
        if ([result isKindOfClass:[UITabBarController class]]) {
            result = ((UITabBarController*)result).selectedViewController;
        }
        if ([result isKindOfClass:[UINavigationController class]]) {
            result = ((UINavigationController*)result).visibleViewController;
        }
        if (result.presentedViewController) {
            result = result.presentedViewController;
        }else{
            break;
        }
    }
    
    return result;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    %orig;
    UITouch *touch = [touches anyObject];
    gestureStartPoint= [touch locationInView:[(UIView *)self superview]];//开始触摸
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    %orig;
    //NSLog(@"gfggfgtouchesEnded");
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPosition = [touch locationInView:[(UIView *)self superview]];
    
    CGFloat deltaX = (gestureStartPoint.x - currentPosition.x);
    
    CGFloat deltaY = gestureStartPoint.y - currentPosition.y;
    
    float MINDISTANCE = sqrt(deltaX * deltaX + deltaY * deltaY)/2;
    //上下滑动
    
    if(fabs(deltaY) > fabs(deltaX))
    {
        //向上滑动
        if (deltaY > MINDISTANCE)   //有效滑动距离 MINDISTANCE
        {
            // NSLog(@"gfggfgtouchesUP");
            [self handleSwipeFrom];
        }
        
        //向下滑动
        // else if (deltaY < -MINDISTANCE)
            
        // {
        //     NSLog(@"gfggfgtouchesDown");
        //     [self handleSwipeFrom];
        // } 
        
    }
    
    //左右滑动
    
    // else if(fabs(deltaX) > fabs(deltaY))
        
    // {
    //     //向左滑动
    //     if (deltaX > MINDISTANCE)
            
    //     {
    //         NSLog(@"gfggfgtouchesleft");
    //     }
    //     //向右滑动
    //     else if (deltaX < -MINDISTANCE)
    //     {
    //         NSLog(@"gfggfgtouchesright");
    //     }
    // }
}

%end

// %hook SBIconLegibilityLabelView
// - (void)updateIconLabelWithSettings:(id)arg1 imageParameters:(id)arg2{
// 	NSLog(@"gfggfg----%@----%@",arg1,arg2);
// 	%orig(arg1,arg2);
// }
// %end
