# WYNullView

An easy way to use when view' content is empty

# Overview

![](https://github.com/WymanLyu/WYNullView/blob/master/WYNullView/Images/nullTest.gif)

# How to use

* Installation with CocoaPods：pod 'WYNullView'

* Import the main file：#import "WYNullView.h"

* On the empty state show default content, then all you have to do is:

```objc
if (showNullView) { // 无数据，empty data -》 show nullview
  [self.tableView wy_showNullView];
} else { // 有数据，data -》 hide nullview
  [self.tableView wy_hideNullView];
}
```

* You will be able to fully customize the content and appearance of the empty states for your application

```objc
if (showNullView) { // 无数据，empty data -》 show nullview
  [self.tableView wy_showNullView:^UIView *(NullView *defaultNullView) {
     // you can do any constom operation in this block, even return a new constom UIView obj 
     // rerurn [UIView new];
     defaultNullView.desText = @"基于NullView自定义";
     defaultNullView.frame = CGRectMake(10, 10, defaultNullView.frame.size.width, defaultNullView.frame.size.height);
     defaultNullView.backgroundColor = [UIColor cyanColor];
     return defaultNullView;
  } heightOffset:0.0];
} else { // 有数据，data -》 hide nullview
  [self.tableView wy_hideNullView];
}

```

# Implementation

* UIView-Category add AssociatedObject "wy_nullView":

```objc
///> 空视图
@property (nonatomic, strong) UIView *wy_nullView;

```

* Looking for NullView chain:

	* \+ (void)wy_configGlobleNullView:(NullViewHandle)nullViewHandle
	* \- (void)wy_configNullView:(NullViewHandle)nullViewHandle
	* \- (void)wy_showNullView:(NullViewHandle)nullViewHandle heightOffset:(CGFloat)offset

* NullViewHandle Type:

```
typedef UIView *(^NullViewHandle)(NullView *defaultNullView);
```

* Different methods can be used in different ways:

	* Global configuration 【View object whatever it is type, show the same content from "wy_configGlobleNullView" nullViewHandle return 】:

	```Objc
 	[UIView wy_configGlobleNullView:^UIView *(NullView *defaultNullView) {
       // return globalNullView...
    }];
	```  
	
	* View configuration【Once config, you can call "wy_showNullView" directly, 】

		
	```Objc
	- (void)viewDidLoad {
	  [mView wy_configNullView:^UIView *(NullView *defaultNullView) {
         // return nullView...
      }];
	}
	- (void)func1 {
	  ...
	  [mView wy_showNullView];
	  ...
	}
    - (void)func2 {
      ...
	  [mView wy_showNullView];
	  ...
    }
	```
   
	* If you have plenty of time, you can do the following【Equivalent to the above】:
	
	```Objc
			
	- (void)func1 {
	  ...
	  [mView wy_showNullView:^UIView *(NullView *defaultNullView) {
         // return nullView...
      } heightOffset:0.0]];
	  ...
	}
    - (void)func2 {
      ...
	  [mView wy_showNullView:^UIView *(NullView *defaultNullView) {
        // return nullView...
       } heightOffset:0.0]];
	  ...
    }
   ```
   
* Control special subView show/hidden 

	* filter obj
	
	```Objc

  	// add objc_whitelist 
 	[[mView wy_objWhitelist] addObject:makeWeakReference(mView_subView)];
 
	```
	* filter class

	```Objc

 	// add class_whitelist
 	[[self.tableView wy_classWhitelist] addObject:makeWeakReference([mView_subView class])];
	```

# Hope

If you think it's useful, star to me, Free to share with ideas, issue or pull requests

# License

MIT
