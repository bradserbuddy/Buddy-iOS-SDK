//
//  UserListIntegrationTests.m
//  BuddySDK
//
//  Created by Nick Ambrose on 5/24/14.
//
//

#import "Buddy.h"
#import "BuddyIntegrationHelper.h"

#import <Kiwi/Kiwi.h>

#ifdef kKW_DEFAULT_PROBE_TIMEOUT
#undef kKW_DEFAULT_PROBE_TIMEOUT
#endif
#define kKW_DEFAULT_PROBE_TIMEOUT 60.0

SPEC_BEGIN(BuddyUserListsSpec)

describe(@"BuddyUserListsSpec", ^{
    context(@"When a user is logged in", ^{
        
        __block BPUserList *tempUserList;
        
        beforeAll(^{
            __block BOOL fin = NO;
            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        it(@"Should allow you create a User List.", ^{
            
            __block BOOL fin = NO;
            
            tempUserList = [BPUserList new];
            NSString *userListName =[NSString stringWithFormat:@"userList_%@",[BuddyIntegrationHelper randomString:10] ] ;
            tempUserList.name =userListName;
        
            [[Buddy userLists] addUserList:tempUserList callback:^(NSError *error) {
                
                [error shouldBeNil];
                [[tempUserList.id shouldNot] beNil];
                [[tempUserList.name should] equal: userListName];
                
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
            
        });
        
        
        it(@"Should allow you to retrieve a UserList.", ^{
            __block BPUserList *retrievedUserList;
            __block BOOL fin = NO;
            
            [[Buddy userLists] getUserList:tempUserList.id callback:^(id newBuddyObject, NSError *error) {
                [[error should] beNil];
                
                if (error) {
                    fin = YES;
                    return;
                }
                
                retrievedUserList = newBuddyObject;
                
                [[retrievedUserList shouldNot] beNil];
                [[retrievedUserList.id should] equal:tempUserList.id];
                
                [[retrievedUserList.name should] equal:tempUserList.name];
                
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        
         
        it(@"Should allow you to modify a userList.", ^{
            
            __block BPUserList *secondUserList;
            __block BOOL fin = NO;
            
            __block NSString *secondUserListName =[NSString stringWithFormat:@"userList_%@",[BuddyIntegrationHelper randomString:10] ] ;
            tempUserList.name = secondUserListName;
            
            [tempUserList save:^(NSError *error) {
                [[error should] beNil];
                [[Buddy userLists] getUserList:tempUserList.id callback:^(id newBuddyObject, NSError *error) {
                    [[error should] beNil];
                    secondUserList = newBuddyObject;
                    [[secondUserList shouldNot] beNil];
                    [[secondUserList.name should] equal:secondUserListName];
                    fin = YES;
                }];
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        
            it(@"Should allow you to add users to the User List",^{
            __block BOOL fin = NO;
                
                [tempUserList addUser:Buddy.user callback:^(BOOL result, NSError *error) {
                [[error should] beNil];
                [[theValue(result) shouldNot] equal: NO];
                    
                fin=YES;
            }];
            
        });
        
    });
    
    context(@"When a user is logged in", ^{
        
        
        
        beforeAll(^{
            __block BOOL fin = NO;
            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        
        it(@"Should allow you to delete a user from a User List.", ^{
            __block BOOL fin = NO;
            __block BPUserList *tempUserList2;
            tempUserList2 = [BPUserList new];
            __block NSString *userListName2 =[NSString stringWithFormat:@"userList_%@",[BuddyIntegrationHelper randomString:10] ] ;
            tempUserList2.name =userListName2;
            __weak BPUserList *tempUserList3 = tempUserList2;
            [[Buddy userLists] addUserList:tempUserList2 callback:^(NSError *error) {
                
                [error shouldBeNil];
                [[tempUserList2.id shouldNot] beNil];
                [[tempUserList2.name should] equal: userListName2];
                
                [tempUserList2 addUser:Buddy.user callback:^(BOOL result, NSError *error) {
                    [[error should] beNil];
                    [[theValue(result) shouldNot] equal: NO];
                    
                    
                    
                    
                    [tempUserList3 deleteUser:Buddy.user callback:^(BOOL result, NSError *error) {
                        [[error should] beNil];
                        [[theValue(result) shouldNot] equal: NO];
                        fin=YES;
                    }];
                    
                    
                }];
                 
            }];
            
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
    });
    
    context(@"When a user is logged in", ^{
        
        
        
        beforeAll(^{
            __block BOOL fin = NO;
            
            [BuddyIntegrationHelper bootstrapLogin:^{
                fin = YES;
            }];
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
        
        afterAll(^{
            
        });
        
        
        it(@"Should allow you to search for a User List.", ^{
            __block BOOL fin = NO;
            __block BPUserList *tempUserList2;
            tempUserList2 = [BPUserList new];
            __block NSString *userListName2 =[NSString stringWithFormat:@"userList_%@",[BuddyIntegrationHelper randomString:10] ] ;
            tempUserList2.name =userListName2;
             __block NSArray *userLists;
            [[Buddy userLists] addUserList:tempUserList2 callback:^(NSError *error) {
                
                [error shouldBeNil];
                [[tempUserList2.id shouldNot] beNil];
                [[tempUserList2.name should] equal: userListName2];
                
                __block BPSearchUserList *searchUserList = [BPSearchUserList new];
                searchUserList.name =userListName2;
                
                    [[Buddy userLists] searchUserLists:searchUserList callback:^(NSArray *buddyObjects, BPPagingTokens *tokens, NSError *error) {
                        userLists = buddyObjects;
                        [[theValue([userLists count]) should] beGreaterThan:theValue(0)];
                        [[[[userLists firstObject] name] should] equal:userListName2];
                        fin=YES;
                    }];
                    
                    
                }];
            
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
    });

    
    
        context(@"When a user is logged in", ^{
            beforeAll(^{
                __block BOOL fin = NO;
                
                [BuddyIntegrationHelper bootstrapLogin:^{
                    fin = YES;
                }];
                
                [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
            });
            
            afterAll(^{
                
            });
            
        
        it(@"Should allow you to delete a User List.", ^{
            __block BOOL fin = NO;
            __block BPUserList *tempUserList2;
            tempUserList2 = [BPUserList new];
            __block NSString *userListName2 =[NSString stringWithFormat:@"userList_%@",[BuddyIntegrationHelper randomString:10] ] ;
            tempUserList2.name =userListName2;
            
            [[Buddy userLists] addUserList:tempUserList2 callback:^(NSError *error) {
                
                [error shouldBeNil];
                [[tempUserList2.id shouldNot] beNil];
                [[tempUserList2.name should] equal: userListName2];
                
                __block NSString *userListId2 =tempUserList2.id;
                
                [tempUserList2 destroy:^(NSError *error) {
                    [[error should] beNil];
                    [[Buddy userLists] getUserList:userListId2 callback:^(id newBuddyObject, NSError *error) {
                        [[error shouldNot] beNil];
                        [[newBuddyObject should] beNil];
                        fin = YES;
                    }];
                }];
            }];
            
            
            [[expectFutureValue(theValue(fin)) shouldEventually] beTrue];
        });
    });
         
});

SPEC_END
