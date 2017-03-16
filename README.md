# HJSynchronize

This HJSynchronize is a multi thread synchronization tool used on iOS

## Example Usage

Check out this [project](https://github.com/panghaijiao/HJSynchronizeDemo). It contains a few demos of the API in use for various scenarios.

**Usage**

*Asynchronous queue*

```
[HJSynchronizeQueue execAsynBlock:^{
      // to do
}];
```
*Synchronization queue*

```
[HJSynchronizeQueue execAsynBlock:^{
     // to do
}];
```
For more information you can visit the [web site](http://www.olinone.com/?p=250)

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the [Get Started](http://cocoapods.org/#get_started) section for more details.

## Podfile

```
pod 'HJSynchronize',    :git => 'https://github.com/panghaijiao/HJSynchronize.git'
```

## License

[MIT license](http://www.opensource.org/licenses/mit-license.php).
