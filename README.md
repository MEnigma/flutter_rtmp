# flutter_rtmp

```
environment:
  sdk: ">=2.1.0 <3.0.0"
  flutter: ">=1.10.0"
```

## 使用方法
>   **git安装使用时建议要按照tag/release版本号**

### [更新 0.1.6](https://github.com/MEnigma/flutter_rtmp/blob/master/CHANGELOG.md)


### 引入
#### 1.第一种方法
    flutter_rtmp:
       git: https://github.com/MEnigma/flutter_rtmp.git
       ref: ***

#### 2.第二种
    flutter_rtmp: ^*.*.*

#### 关于iOS的配置
```
需要在info.plist中添加 

<key>io.flutter.embedded_views_preview</key>
<true/>
```
#### 关于Android的配置
```
暂无需配置
```

>示例
>   ```
>    /// 控制器
>    void initState() {
>        super.initState();
>        _manager = RtmpManager(onCreated: () {
>            print("--- view did created ---");
>        });
>    }
>
>    /// 视图
>   Widget build(BuildContext context) {
>
>      return RtmpView(
>            manager: _manager,
>       );
>   }
>   ```
    
### 引用

>*   iOS 使用[LFLiveKit](https://github.com/LaiFengiOS/LFLiveKit)
>*   android中使用[yasea](https://github.com/begeekmyfriend/yasea)

### 进度

* [x] 推流
* [x] 切换摄像头
* [ ] 美颜
* [ ] 旋转


### [LICENSE](https://github.com/MEnigma/flutter_rtmp/blob/master/LICENSE)

* 参与者
>* mark < https://github.com/MEnigma >
>* youshinki < https://github.com/youshinki >

### Versions
* [0.1.4](https://github.com/MEnigma/flutter_rtmp/tree/v0.1.4)
* [0.1.6](https://github.com/MEnigma/flutter_rtmp/tree/v0.1.6)