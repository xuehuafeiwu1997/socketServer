//
//  main.m
//  serverForSocketCommunication
//
//  Created by 许明洋 on 2020/11/25.
//

#import <Cocoa/Cocoa.h>
#import "TcpServer.h"
#import "UdpServer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        TcpServer *tcpServer = [[TcpServer alloc] init];
        [tcpServer startTcpServer];
        
        UdpServer *udpServer = [[UdpServer alloc] init];
        [udpServer startUdpServer];
        //开启主运行循环
        [[NSRunLoop mainRunLoop] run];
    }
    return NSApplicationMain(argc, argv);
}
