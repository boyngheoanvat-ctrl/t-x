#import "PubgLoad.h"
#import "ImGuiDrawView.h"

@implementation PubgLoad

+ (void)setMenuVisible:(BOOL)visible {
}

+ (void)load {
    static PubgLoad *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PubgLoad alloc] init];
        [sharedInstance bootstrapOverlay];
    });
}

- (void)bootstrapOverlay {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.vna = [[ImGuiDrawView alloc] init];
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        if (keyWindow && keyWindow.rootViewController) {
            [keyWindow.rootViewController addChildViewController:self.vna];
            [keyWindow.rootViewController.view addSubview:self.vna.view];
            [self.vna didMoveToParentViewController:keyWindow.rootViewController];
        }
        [self.vna viewDidLoad];
        [self setupGestures];
    });
}

- (void)setupGestures {
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (window.isKeyWindow) {
            keyWindow = window;
            break;
        }
    }
    if (!keyWindow) {
        keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    
    if (keyWindow) {
        // 1. Chạm 3 ngón tay để MỞ menu
        UITapGestureRecognizer *threeFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleThreeFingerTap:)];
        threeFingerTap.numberOfTouchesRequired = 3;
        [keyWindow addGestureRecognizer:threeFingerTap];
        
        // 2. Chạm 2 ngón tay để TẮT menu
        UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTwoFingerTap:)];
        twoFingerTap.numberOfTouchesRequired = 2;
        [keyWindow addGestureRecognizer:twoFingerTap];
        
        NSLog(@"[SicBoMod] Đã cài đặt cử chỉ: 3 ngón mở menu, 2 ngón tắt menu.");
    }
}

- (void)handleThreeFingerTap:(UITapGestureRecognizer *)gesture {
    self.menuVisible = YES;
    [ImGuiDrawView showChange:self.menuVisible];
    NSLog(@"[SicBoMod] Đã mở menu qua cử chỉ 3 ngón.");
}

- (void)handleTwoFingerTap:(UITapGestureRecognizer *)gesture {
    self.menuVisible = NO;
    [ImGuiDrawView showChange:self.menuVisible];
    NSLog(@"[SicBoMod] Đã tắt menu qua cử chỉ 2 ngón.");
}

@end
