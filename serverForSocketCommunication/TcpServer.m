//
//  TcpServer.m
//  serverForSocketCommunication
//
//  Created by 许明洋 on 2020/11/26.
//

#import "TcpServer.h"
#import "GCDAsyncSocket.h" //for tcp

@interface TcpServer()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *listenSocket;//监听socket
@property (nonatomic, strong) NSMutableArray *clientSocketArray;

@end

@implementation TcpServer

- (NSMutableArray *)clientSocketArray {
    if (_clientSocketArray) {
        return _clientSocketArray;
    }
    _clientSocketArray = [NSMutableArray array];
    return _clientSocketArray;
}

- (void)startTcpServer {
    self.listenSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    if (![self.listenSocket acceptOnPort:5556 error:&error]) {
        NSLog(@"tcp服务开启失败，失败的原因为%@",error);
    } else {
        NSLog(@"tcp服务开启成功");
    }
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    [self.clientSocketArray addObject:newSocket];
    NSLog(@"执行了这个方法");
    [newSocket readDataWithTimeout:-1 tag:self.clientSocketArray.count];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"当前的data为%@",data);
    NSLog(@"当前的tag为%ld",tag);
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"客户端传来的字符为:%@",result);
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"当前服务器的IP地址为%@",host);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"服务器断开了连接，错误为%@",err);
}
@end
