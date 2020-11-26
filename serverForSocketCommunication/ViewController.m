//
//  ViewController.m
//  serverForSocketCommunication
//
//  Created by 许明洋 on 2020/11/25.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h" //for tcp
#import "GCDAsyncUdpSocket.h" //for udp

@interface ViewController()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *listenSocket;//监听socket
@property (nonatomic, strong) NSMutableArray *clientSocketArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    self.listenSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    if (![self.listenSocket acceptOnPort:5556 error:&error]) {
        NSLog(@"监听出错,错误的原因为%@",error);
    } else {
        NSLog(@"连接成功");
    }
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (NSMutableArray *)clientSocketArray {
    if (_clientSocketArray) {
        return _clientSocketArray;
    }
    _clientSocketArray = [NSMutableArray array];
    return _clientSocketArray;
}

#pragma mark - delegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    [self.clientSocketArray addObject:newSocket];
    NSLog(@"执行了这个方法");
    [newSocket readDataWithTimeout:-1 tag:self.clientSocketArray.count];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"当前的data为%@",data);
    NSLog(@"当前的tag为%ld",tag);
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"客户端传过来的字符为:%@",result);
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"当前服务器的IP地址为%@",host);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    NSLog(@"服务器断开了连接，错误为%@",err);
}

@end
