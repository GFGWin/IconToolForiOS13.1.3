#line 1 "Tweak.x"
#import "SBIconView.h"
#import "SBIconLegibilityLabelView.h"
#import "SBIconLabelImageParameters.h"
#import "SBApplication.h"

static CGPoint gestureStartPoint;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SBApplication; @class SBIconView; 
static void _logos_method$_ungrouped$SBIconView$handleSwipeFrom(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST, SEL); static UIViewController * _logos_method$_ungrouped$SBIconView$getCurrentVC(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST, SEL); static void (*_logos_orig$_ungrouped$SBIconView$touchesBegan$withEvent$)(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST, SEL, NSSet *, UIEvent *); static void _logos_method$_ungrouped$SBIconView$touchesBegan$withEvent$(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST, SEL, NSSet *, UIEvent *); static void (*_logos_orig$_ungrouped$SBIconView$touchesEnded$withEvent$)(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST, SEL, NSSet *, UIEvent *); static void _logos_method$_ungrouped$SBIconView$touchesEnded$withEvent$(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST, SEL, NSSet *, UIEvent *); static id (*_logos_orig$_ungrouped$SBApplication$displayName)(_LOGOS_SELF_TYPE_NORMAL SBApplication* _LOGOS_SELF_CONST, SEL); static id _logos_method$_ungrouped$SBApplication$displayName(_LOGOS_SELF_TYPE_NORMAL SBApplication* _LOGOS_SELF_CONST, SEL); 

#line 8 "Tweak.x"
static NSString * NewIconName;
#define kSettingsFilePath "/var/mobile/Library/Preferences/com.GFGWin.iconrenamer.plist"





static void _logos_method$_ungrouped$SBIconView$handleSwipeFrom(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
	NSString * bundleID = [[self icon] applicationBundleID];
    
    
    id app1 = [[self icon] application];
	NSLog(@"gfggfgaaaaa--%@",bundleID);
    NSLog(@"gfggfgbbbbb--%@",app1);
	if (bundleID)
	{
		UIViewController *currentVC = [self getCurrentVC];
		
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
        		
                NewIconName = [ReNameAlertVC.textFields firstObject].text;
                
                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:@kSettingsFilePath];
                if (dic.allKeys>0)
                {
                    [dic setObject:NewIconName forKey:bundleID];
                    [dic writeToFile:@kSettingsFilePath atomically:YES];
                }else
                {
                    NSMutableDictionary * dic1 = [[NSMutableDictionary alloc]init];
                    [dic1 setObject:NewIconName forKey:bundleID];
                    [dic1 writeToFile:@kSettingsFilePath atomically:YES];
                }
                
                

                
                
                
                
                
                

                
                
                
                
                
                
                        
                

                


                
    		}];
            
    		UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        		
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




static UIViewController * _logos_method$_ungrouped$SBIconView$getCurrentVC(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    
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


static void _logos_method$_ungrouped$SBIconView$touchesBegan$withEvent$(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSSet * touches, UIEvent * event)  {
    _logos_orig$_ungrouped$SBIconView$touchesBegan$withEvent$(self, _cmd, touches, event);
    UITouch *touch = [touches anyObject];
    gestureStartPoint= [touch locationInView:[(UIView *)self superview]];
}


static void _logos_method$_ungrouped$SBIconView$touchesEnded$withEvent$(_LOGOS_SELF_TYPE_NORMAL SBIconView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSSet * touches, UIEvent * event){
    _logos_orig$_ungrouped$SBIconView$touchesEnded$withEvent$(self, _cmd, touches, event);
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPosition = [touch locationInView:[(UIView *)self superview]];
    
    CGFloat deltaX = (gestureStartPoint.x - currentPosition.x);
    
    CGFloat deltaY = gestureStartPoint.y - currentPosition.y;
    
    float MINDISTANCE = sqrt(deltaX * deltaX + deltaY * deltaY)/2;
    
    
    if(fabs(deltaY) > fabs(deltaX))
    {
        
        if (deltaY > MINDISTANCE)   
        {
            
            [self handleSwipeFrom];
        }
        
        
        
            
        
        
        
        
        
    }
    
    
    
    
        
    
    
    
            
    
    
    
    
    
    
    
    
    
}




static id _logos_method$_ungrouped$SBApplication$displayName(_LOGOS_SELF_TYPE_NORMAL SBApplication* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd){
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:@kSettingsFilePath];
    if (dic.allKeys>0)
    {
       for (int i = 0; i < dic.allKeys.count; i++)
       {
           if ([self.bundleIdentifier isEqualToString:dic.allKeys[i]])
           {
               return [dic objectForKey:dic.allKeys[i]];
           }
       }
    }
    return _logos_orig$_ungrouped$SBApplication$displayName(self, _cmd);
}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBIconView = objc_getClass("SBIconView"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconView, @selector(handleSwipeFrom), (IMP)&_logos_method$_ungrouped$SBIconView$handleSwipeFrom, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(UIViewController *), strlen(@encode(UIViewController *))); i += strlen(@encode(UIViewController *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconView, @selector(getCurrentVC), (IMP)&_logos_method$_ungrouped$SBIconView$getCurrentVC, _typeEncoding); }MSHookMessageEx(_logos_class$_ungrouped$SBIconView, @selector(touchesBegan:withEvent:), (IMP)&_logos_method$_ungrouped$SBIconView$touchesBegan$withEvent$, (IMP*)&_logos_orig$_ungrouped$SBIconView$touchesBegan$withEvent$);MSHookMessageEx(_logos_class$_ungrouped$SBIconView, @selector(touchesEnded:withEvent:), (IMP)&_logos_method$_ungrouped$SBIconView$touchesEnded$withEvent$, (IMP*)&_logos_orig$_ungrouped$SBIconView$touchesEnded$withEvent$);Class _logos_class$_ungrouped$SBApplication = objc_getClass("SBApplication"); MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(displayName), (IMP)&_logos_method$_ungrouped$SBApplication$displayName, (IMP*)&_logos_orig$_ungrouped$SBApplication$displayName);} }
#line 201 "Tweak.x"
