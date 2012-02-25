//
//  NSString+URLEncoding.m
//  Ragefac
//
//  Created by Kida Marcus on 28.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding
{
	return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                        NULL,
                                                                        (__bridge CFStringRef)self,
                                                                        NULL,
                                                                        (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                        CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end