//
//  DropDownListView.m
//  KDropDownMultipleSelection
//
//  Created by macmini17 on 03/01/14.
//  Copyright (c) 2014 macmini17. All rights reserved.
//

#import "DropDownListView.h"
#import "DropDownViewCell.h"

#define DROPDOWNVIEW_SCREENINSET 0
#define DROPDOWNVIEW_HEADER_HEIGHT 50.
#define RADIUS 5.0f


@interface DropDownListView (private)
- (void)fadeIn;
- (void)fadeOut;
@end
@implementation DropDownListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions optionsID:(NSArray *)aOptionsID xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple
{
    isMultipleSelection = isMultiple;
    float height = MIN(size.height, DROPDOWNVIEW_HEADER_HEIGHT+[aOptions count]*44);
    CGRect rect = CGRectMake(point.x, point.y, size.width, height);
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(2.5, 2.5);
        self.layer.shadowRadius = 2.0f;
        self.layer.shadowOpacity = 0.5f;
        
        _kTitleText = [aTitle copy];
        _kDropDownOption = [aOptions copy];
        _kDropDownOptionID = [aOptionsID copy];
        self.arryData=[[NSMutableArray alloc]init];
        _kTableView = [[UITableView alloc] initWithFrame:CGRectMake(DROPDOWNVIEW_SCREENINSET,
                                                                   DROPDOWNVIEW_SCREENINSET + DROPDOWNVIEW_HEADER_HEIGHT,
                                                                   rect.size.width - 2 * DROPDOWNVIEW_SCREENINSET,
                                                                   rect.size.height - 2 * DROPDOWNVIEW_SCREENINSET - DROPDOWNVIEW_HEADER_HEIGHT)];
        _kTableView.separatorColor = [UIColor colorWithWhite:1 alpha:.2];
        _kTableView.separatorInset = UIEdgeInsetsZero;
        _kTableView.backgroundColor = [UIColor whiteColor];
        _kTableView.dataSource = self;
        _kTableView.delegate = self;
        [self addSubview:_kTableView];
        
        if (isMultipleSelection) {
            UIButton *btnDone=[UIButton  buttonWithType:UIButtonTypeCustom];
            [btnDone setFrame:CGRectMake(size.width-60,10,50, 30)];
            [btnDone setImage:[UIImage imageNamed:@"done@2x.png"] forState:UIControlStateNormal];
            [btnDone addTarget:self action:@selector(Click_Done) forControlEvents: UIControlEventTouchUpInside];
            [self addSubview:btnDone];
        }
    }
    return self;
}
-(void)Click_Done
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(DropDownListView:Datalist:DatalistId:)]) {
        NSMutableArray *arryResponceData=[[NSMutableArray alloc]init];
         NSMutableArray *arryResponceDataID=[[NSMutableArray alloc]init];
        for (ISUserInfo * catInfo in _kDropDownOption) {
            if (catInfo.isItemSelected) {
                [arryResponceData addObject:catInfo.name];
                [arryResponceDataID addObject:[NSString stringWithFormat:@"%lu", (unsigned long)catInfo.id]];
            }
        }
        
        [self.delegate DropDownListView:self Datalist:arryResponceData DatalistId:arryResponceDataID];
    }
    // dismiss self
    //[self fadeOut];
}
#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
         
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_kDropDownOption count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"DropDownViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    cell = [[DropDownViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    
    UIImageView *imgarrow=[[UIImageView alloc]init ];
    ISUserInfo * catInfo = [_kDropDownOption objectAtIndex:indexPath.row];

    if(catInfo.isItemSelected){
        imgarrow.frame=CGRectMake(self.frame.size.width-30,10, 20, 20);
        imgarrow.image=[UIImage imageNamed:@"ico_Check.png"];
        imgarrow.contentMode = UIViewContentModeCenter;
	} else
        imgarrow.image=nil;
    
    [cell addSubview:imgarrow];
    cell.textLabel.text = catInfo.name;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ISUserInfo * catInfo = [_kDropDownOption objectAtIndex:indexPath.row];
    catInfo.isItemSelected = !catInfo.isItemSelected;
    [tableView reloadData];
}

#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // tell the delegate the cancellation
}

#pragma mark - DrawDrawDraw
- (void)drawRect:(CGRect)rect {
    CGRect bgRect = CGRectInset(rect, DROPDOWNVIEW_SCREENINSET, DROPDOWNVIEW_SCREENINSET);
    CGRect titleRect = CGRectMake(DROPDOWNVIEW_SCREENINSET + 10, DROPDOWNVIEW_SCREENINSET + 20,
                                  rect.size.width -  2 * (DROPDOWNVIEW_SCREENINSET + 10), 30);
    CGRect separatorRect = CGRectMake(DROPDOWNVIEW_SCREENINSET, DROPDOWNVIEW_SCREENINSET + DROPDOWNVIEW_HEADER_HEIGHT - 2,
                                      rect.size.width - 2 * DROPDOWNVIEW_SCREENINSET, 2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the background with shadow
    [[UIColor lightGrayColor] setFill];
    
    float x = DROPDOWNVIEW_SCREENINSET;
    float y = DROPDOWNVIEW_SCREENINSET;
    float width = bgRect.size.width;
    float height = bgRect.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, x, y + RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y, x + RADIUS, y, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + RADIUS, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - RADIUS, y + height, RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - RADIUS, RADIUS);
	CGPathCloseSubpath(path);
	CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
    
    // Draw the title and the separator with shadow

    UIColor *cl=[UIColor whiteColor];
    NSDictionary *attributes = @{ NSFontAttributeName: NEO_SANS_PRO_REGULAR(14),NSForegroundColorAttributeName:cl};
    [_kTitleText drawInRect:titleRect withAttributes:attributes];
    
    CGContextFillRect(ctx, separatorRect);
}

-(void)SetBackGroundDropDown_R:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)alph {
    R=r;
    G=g;
    B=b;
    A=alph;
}

@end
