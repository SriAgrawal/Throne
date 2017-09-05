//
//  ISServiceHelper.m
//  Instasneaks
//
//  Created by Suresh patel on 08/08/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "ISServiceHelper.h"

@interface NSDictionary(JSONCategories)

+(id)dictionaryWithContentsOfJSONURLData:(NSData *)JSONData;
-(NSData*)toNSData;
-(NSString *)toJsonString;

@end

@interface ISServiceHelper ()

@end

@implementation NSDictionary(JSONCategories)
+(id)dictionaryWithContentsOfJSONURLData:(NSData *)JSONData
{
    __autoreleasing NSError* error = nil;
    if(JSONData == nil) {
        return [NSDictionary dictionary];
    }
    id result = [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result ;
}

-(NSData*)toNSData
{
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    
    
    if (error != nil) return nil;
    return result;
}

-(NSString*)toJsonString
{
    
    __autoreleasing NSError* error = nil;
    NSData *jsonOutputData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    NSString *result = [[NSString alloc] initWithData:jsonOutputData encoding:NSUTF8StringEncoding];
    if (error != nil) return nil;
    return result;
}

@end



//TODO:- // Note:- Implement delegates if required for your requirement. PUT and Delete are not tested; May requires improvement

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> APIs Constants Start >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

static double timeoutInterval = 45.0;

// Local
//static NSString *baseURL = @"http://172.16.1.68:3000/api/";

// Staging
static NSString *baseURL = @"https://throne2.herokuapp.com/api/";

// Production
//static NSString *baseURL = @"http://ec2-52-52-167-224.us-west-1.compute.amazonaws.com/api/";


//>>>>>>>>>>>>>>>>>>> APIs Constants Start >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

@implementation ISServiceHelper

+ (ISServiceHelper *)helper {
    
    static ISServiceHelper *_manager = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _manager = [[ISServiceHelper alloc] init];
    });
    return _manager;
}

#pragma mark - Public methods

- (void)request:(NSMutableDictionary *)parameterDict apiName:(NSString *)name method:(Method)methodType completionBlock:(void (^)(NSDictionary *resultDict, NSError *error))handler {
    
    if (![APPDELEGATE isReachable]) {
        
        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
        [errorDetails setValue:@"Unable to connect network. Please check your internet connection." forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"Connection Error!" code:1009 userInfo:errorDetails];
        handler(nil,error);
        return ;
    }
    
    NSURL *requestURL = [self requestURL:parameterDict apiName:name method:methodType];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    
    [request setHTTPMethod:[self methodName:methodType]];
    
    if (methodType == POST || methodType == PUT || methodType == PATCH) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    
    [request setValue:[USERDEFAULT valueForKey:kEmail] forHTTPHeaderField:@"X-User-Email"];
    [request setValue:[USERDEFAULT valueForKey:kAuthentication_Token] forHTTPHeaderField:@"X-User-Token"];

    [request setHTTPBody:[self body:parameterDict method:methodType]];
    [request setTimeoutInterval:timeoutInterval];
    
    NSLog(@"\n\n Request URL  >>>>>>  %@",requestURL);
    NSLog(@"\n\n Request Header  >>>>>>  %@",request.allHTTPHeaderFields);
    NSLog(@"\n\n Request Body  >>>>>>  %@",request.HTTPBody);
    NSLog(@"\n\n Request Parameters  >>>>>>  %@",[parameterDict toJsonString]);
    
    if ([self isTokenRequiredForApi:name]) {
        [request setValue:@"TOKEN VALUE" forHTTPHeaderField:@"authorization"];
    }
    
    //hideAllHuds(false, type:hudType)
    [self progressHud:YES];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //hideAllHuds(false, type:hudType)
        [self progressHud:NO];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger responseCode = [httpResponse statusCode];
        
        NSLog(@"\n\n Response Code >>>>>> \n%ld",(long)responseCode);
        
        //NSDictionary *responseHeader = [httpResponse allHeaderFields];
        //KLog("\n\n Response Header >>>>>> \n%ld",responseHeader)
        
        
        if (error != nil) {
            NSLog(@"\n\n error  >>>>>>  %@",error);
            handler(nil, error);
        } else {
            
            NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            id result = [NSDictionary dictionaryWithContentsOfJSONURLData:data];
            
            NSLog(@"\n\nResponse String>>>> \n%@",responseString);
            
            handler(result, nil);
        }
        
    }];
    
    [dataTask resume];
}

#pragma mark - Private methods

- (BOOL)isTokenRequiredForApi:(NSString *)name {
    
    BOOL required = NO;
    
    if ([name isEqualToString:@"API name which need token"]) {
        required = YES;
    }
    
    return required;
}

- (NSString *)methodName:(Method)methodType {
    
    switch (methodType) {
            
        case GET: return @"GET";
            
        case POST: return @"POST";
            
        case DELETE: return @"DELETE";
            
        case PUT: return @"PUT";
           
        case PATCH: return @"PATCH";
        
            
    }
}
- (NSData *)body:(NSMutableDictionary *)parameterDict method:(Method)methodType {
    
    switch (methodType) {
            
        case GET: return [NSData data];
            
        case POST: return [parameterDict toNSData];
            
        case DELETE: return [NSData data];
            
        case PUT: return [parameterDict toNSData];
        
        case PATCH: return [parameterDict toNSData];// depends on server requirement
            
    }
}

- (NSURL *)formattedURL:(NSMutableDictionary *)parameterDict apiName:(NSString *)name {
    
    NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", baseURL, name];
    BOOL isFirst = YES;
    
    for (NSString *key in [parameterDict allKeys]) {
        
        id object = parameterDict[key];
        if ([object isKindOfClass:[NSArray class]]) {
            
            for (id eachObject in object) {
                
                [urlString appendString:[NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, eachObject]];
                isFirst = NO;
            }
        } else {
            [urlString appendString:[NSString stringWithFormat:@"%@%@=%@", isFirst ? @"?": @"&", key, parameterDict[key]]];
        }
        
        isFirst = NO;
    }
    
    NSString *encodedString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return [NSURL URLWithString:encodedString];
}

- (NSURL *)requestURL:(NSMutableDictionary *)parameterDict apiName:(NSString *)name method:(Method)methodType {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseURL,name];
    
    switch (methodType) {
            
        case GET: return [self formattedURL:parameterDict apiName:name];
            
        case POST:return [NSURL URLWithString:urlString];
            
        default: return [NSURL URLWithString:urlString];
    }
}

- (void)progressHud:(BOOL)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *hud = [MBProgressHUD HUDForView:[APPDELEGATE window]];
        if (status) {
            if (hud == nil) {
                hud = [MBProgressHUD showHUDAddedTo:[APPDELEGATE window] animated:YES];
            }
            [hud.bezelView.layer setCornerRadius:8.0];
            [hud.bezelView setColor:[UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.8]];
            [hud setMargin:12];
            [hud setActivityIndicatorColor:[UIColor whiteColor]];
            
        } else {
            
            [hud hideAnimated:true afterDelay:0.1];
        }
    });
    
}

@end
