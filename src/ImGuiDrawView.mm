#import "ImGuiDrawView.h"
#import <MetalKit/MetalKit.h>

@implementation ImGuiDrawView

+ (void)startRuntimeInitialization {
    NSLog(@"[ImGuiDrawView] Khởi chạy runtime ImGui.");
}

+ (id)renderDiagnostics {
    return @"Diagnostics OK";
}

+ (id)runtimeMessage {
    return @"Running Metal ImGui Overlay";
}

+ (long long)runtimeState {
    return 1;
}

+ (BOOL)menuIsVisible {
    return YES;
}

+ (void)showChange:(BOOL)visible {
    NSLog(@"[ImGuiDrawView] Trạng thái menu hiển thị: %d", visible);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.device = MTLCreateSystemDefaultDevice();
    if (!self.device) {
        NSLog(@"[ImGuiDrawView] Không hỗ trợ Metal trên thiết bị này!");
        return;
    }
    
    self.commandQueue = [self.device newCommandQueue];
    
    MTKView *mtkView = [[MTKView alloc] initWithFrame:self.view.bounds device:self.device];
    mtkView.delegate = self;
    mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    mtkView.backgroundColor = [UIColor clearColor];
    mtkView.userInteractionEnabled = NO; // Cho phép chạm xuyên qua màn hình overlay khi không mở menu
    
    [self.view addSubview:mtkView];
    self.mtkView = mtkView;
}

- (void)drawInMTKView:(MTKView *)view {
    // Vòng lặp render ImGui sẽ thực hiện ở đây
}

- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    // Xử lý khi kích thước màn hình thay đổi (xoay ngang/dọc)
}

@end
