






#import <UIKit/UIKit.h>

@interface SampleCell : UITableViewCell
@property (nonatomic, assign) id delegate;
@end


@protocol FancyProtocolNameGoesHere
- (void)doSomethingWithThisText:(NSString*)text fromThisCell:(UITableViewCell*)cell;
@end