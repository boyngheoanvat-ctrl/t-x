#import "PubgLoad.h"
#import "ImGuiDrawView.h"
#import "LTGalaxyNotices.h"

@implementation PubgLoad

+ (void)setMenuVisible:(BOOL)visible {
    // Xử lý trạng thái hiển thị menu
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
        [self setupMenuButton];
    });
}

- (void)setupMenuButton {
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame = CGRectMake(40, 100, 45, 45);
    self.menuButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.5 blue:0.9 alpha:0.8];
    self.menuButton.layer.cornerRadius = 22.5;
    self.menuButton.layer.borderWidth = 1.5;
    self.menuButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.menuButton setTitle:@"MOD" forState:UIControlStateNormal];
    [self.menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.menuButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    
    [self.menuButton addTarget:self action:@selector(handleMenuButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (keyWindow) {
        [keyWindow addSubview:self.menuButton];
        [keyWindow bringSubviewToFront:self.menuButton];
    }
}

- (void)handleMenuButtonTap:(id)sender {
    self.menuVisible = !self.menuVisible;
    [ImGuiDrawView showChange:self.menuVisible];
}

@end
