//
//  UserService.m
//  BmobIMDemo
//
//  Created by Bmob on 16/1/19.
//  Copyright © 2016年 bmob. All rights reserved.
//

#import "UserService.h"

@implementation UserService



/**
 *  加载所有用户信息，除了自己
 *
 *  @param date  当前时间
 *  @param block 用户的数组
 */
+(void)loadUsersWithDate:(NSDate *)date completion:(BmobObjectArrayResultBlock)block{
    BmobQuery *query = [BmobQuery queryForUser];
    
    NSMutableArray *idArray = [NSMutableArray array];
    [idArray addObject:[BmobUser getCurrentUser].objectId];
    
    [query whereKey:@"objectId" notContainedIn:idArray];
    query.limit = 20;
//    [query whereKey:@"createdAt" lessThanOrEqualTo:date];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array1, NSError *error) {
        if (error) {
            if (block) {
                block(nil,error);
            }
        }else{
            NSMutableArray *array = [NSMutableArray array];
            for (BmobUser *user in array1) {
                BmobIMUserInfo *info  = [BmobIMUserInfo userInfoWithBmobUser:user];
                [array addObject:info];
            }
            if (block) {
                block(array,nil);
            }
        }
    }];
}

+(void)loadUsersWithDate:(NSDate *)date keyword:(NSString *)keyword completion:(BmobObjectArrayResultBlock)block{
    BmobQuery *query = [BmobQuery queryForUser];
    [query whereKey:@"objectId" notEqualTo:[BmobUser getCurrentUser].objectId];
    [query whereKey:@"createdAt" lessThanOrEqualTo:date];
    [query whereKey:@"username" matchesWithRegex:keyword];
    query.limit = 20;
    [query findObjectsInBackgroundWithBlock:^(NSArray *array1, NSError *error) {
        if (error) {
            if (block) {
                block(nil,error);
            }
        }else{
            NSMutableArray *array = [NSMutableArray array];
            for (BmobUser *user in array1) {
                BmobIMUserInfo *info  = [BmobIMUserInfo userInfoWithBmobUser:user];
                [array addObject:info];
            }
            if (block) {
                block(array,nil);
            }
        }
    }];
}

+(void)loadUserWithUserId:(NSString *)objectId
               completion:(void(^)(BmobIMUserInfo *result ,NSError *error))block{
    BmobQuery *query = [BmobQuery queryForUser];
    [query getObjectInBackgroundWithId:objectId
                                 block:^(BmobObject *object, NSError *error) {
                                     if (error) {
                                         if (block) {
                                             block(nil,error);
                                         }
                                     }else{
                                         BmobUser *user = (BmobUser *)object;
                                         BmobIMUserInfo *info  = [BmobIMUserInfo userInfoWithBmobUser:user];
                                         if (block) {
                                             block(info,nil);
                                         }
                                     }
                                 }];
}

/**
 *  添加好友
 *
 *  @param userId 用户的objectId
 *  @param block  回调的结果
 */
+(void)addFriendNoticeWithUserId:(NSString *)userId completion:(BmobBooleanResultBlock)block{
    [self addFriendNoticeWithUserId:userId
                      content:@"请求添加您为好友"
                         type:SystemMessageContactAdd
                   completion:block];
}


/**
 *  同意添加好友
 *
 *  @param objectId 消息的objectid
 *  @param block    回调的结果
 */
+(void)agreeFriendWithObejctId:(NSString *)objectId userId:(NSString*)userId completion:(BmobBooleanResultBlock)block{
    BmobObject *obj = [BmobObject objectWithoutDatatWithClassName:kInviteMessageTable objectId:objectId];
    [obj setObject:[NSNumber numberWithInt:SystemMessageContactAgree] forKey:@"type"];
    [obj setObject:@"同意加您为好友" forKey:@"content"];
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            [self addFriendNoticeWithUserId:userId
                                    content:@"已经是好友"
                                       type:SystemMessageContactAgree completion:block];
            
            
        }else{
            if (block) {
                block(NO,error);
            }
        }
    }];
    
}

+(void)addFriendNoticeWithUserId:(NSString *)userId
                   content:(NSString *)content
                      type:(SystemMessageContact)type
                completion:(BmobBooleanResultBlock)block{
    BmobUser *fromUser = [BmobUser getCurrentUser];
    BmobUser *toUser   = [BmobUser objectWithoutDatatWithClassName:nil objectId:userId];
    
    BmobObject *obj = [[BmobObject alloc] initWithClassName:kInviteMessageTable];
    [obj setObject:fromUser forKey:@"fromUser"];
    [obj setObject:toUser forKey:@"toUser"];
    [obj setObject:content forKey:@"content"];
    [obj setObject:[NSNumber numberWithInt:type] forKey:@"type"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (block) {
            block(isSuccessful,error);
        }
    }];
}


/**
 *  拒绝添加好友
 *
 *  @param objectId 消息的objectId
 *  @param block    回调的结果
 */
+(void)refuseFriendWithObejctId:(NSString *)objectId completion:(BmobBooleanResultBlock)block{

}


/**
 *  同意后互为好友
 *
 *  @param user       用户
 *  @param friendUser 好友
 *  @param block      <#block description#>
 */
+(void)addFriendWithUser:(BmobUser *)user
                  friend:(BmobUser *)friendUser
              completion:(BmobBooleanResultBlock)block{
    BmobObject *obj = [[BmobObject alloc] initWithClassName:kFriendTable];
    [obj setObject:user forKey:@"user"];
    [obj setObject:friendUser forKey:@"friendUser"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (block) {
            block(isSuccessful,error);
        }
    }];
}


/**
 *  某人的好友数组
 *
 *  @param block 好友
 */
+(void)friendsWithCompletion:(BmobObjectArrayResultBlock)block{
    
    
    BmobUser *user = [BmobUser getCurrentUser];
    if (!user) {
        return;
    }
    BmobQuery *query = [BmobQuery queryWithClassName:kFriendTable];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user,friendUser"];
    NSDictionary *condiction1 = @{@"user":@{@"__type":@"Pointer",@"className":@"_User",@"objectId":user.objectId}};
    //假设用户b的objecId为bbbb
    NSDictionary *condiction2= @{@"friendUser":@{@"__type":@"Pointer",@"className":@"_User",@"objectId":user.objectId}};
    [query addTheConstraintByOrOperationWithArray:@[condiction1,condiction2]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (block) {
            block(array,error);
        }
    }];
}


+(void)loadUsersWithUserIds:(NSArray *)array
                 completion:(BmobObjectArrayResultBlock)block{
    NSArray *objectIds = [[BmobIM sharedBmobIM] allConversationUsersIds];
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"objectId" containedIn:objectIds];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array1, NSError *error) {
        if (!error) {
            NSMutableArray *array = [NSMutableArray array];
            for (BmobUser *user in array1) {
                BmobIMUserInfo *info  = [BmobIMUserInfo userInfoWithBmobUser:user];
                [array addObject:info];
            }
            if (block) {
                block(array,nil);
            }
        }else{
            if (block) {
                block(nil,error);
            }
        }
    }];
}


@end
