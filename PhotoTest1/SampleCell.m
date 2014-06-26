#import "SampleCell.h"

@interface SampleCell ()

@property (strong, nonatomic) UIButton *button;
- (void)handleTouchUpInside;

@end


@implementation SampleCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureCell];
    }
    return self;
}

- (void)configureCell
{
    _button = [[UIButton alloc] init];
    //Configure all the images etc, for the button
    [_button addTarget:self action:@selector(handleTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button]; //you'd probably want to set the frame first...
}

- (void)handleTouchUpInside
{
    if (_button.selected) {
        [self.delegate doSomethingWithThisText:self.textLabel.text fromThisCell:self];
    }
    _button.selected = !_button.selected;
}

@end
