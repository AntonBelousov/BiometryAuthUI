//
//  BiometryUIModule.h
//  
//
//  Created by Anton Belousov on 03/05/2018.
//  Copyright © 2018 kp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BiometryUIModule : NSObject
@property (nonatomic, copy) NSString *localizationTable;
+ (instancetype)shared;
@end
