//
//  UdpServer.m
//  serverForSocketCommunication
//
//  Created by 许明洋 on 2020/11/26.
//

#import "UdpServer.h"
#import "GCDAsyncUdpSocket.h"

@interface UdpServer()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *listenSocket;

@end

@implementation UdpServer

- (void)startUdpServer {
    self.listenSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];//队列传递nil，会自动创建一个队列，这里如果自定义队列，一定不能是并发队列
    NSError *error = nil;
    [self.listenSocket bindToPort:5557 error:&error];
    if (error) {
        NSLog(@"开启udp服务失败，失败的原因是%@",error);
    } else {
        NSLog(@"开启udp服务成功");
        NSError *err = nil;
//        [self.listenSocket receiveOnce:&err];//只接受一次数据
        [self.listenSocket beginReceiving:&err];
        if (err) {
            NSLog(@"接收数据失败");
        } else {
            NSLog(@"接收数据成功");
        }
    }
}

#pragma mark - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
    NSLog(@"执行了这个方法，address结果为%@",address);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
                                             fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext {
    NSLog(@"接受数据的ip地址为%@",address);
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"从客户端传来的数据为%@",result);
}
@end
