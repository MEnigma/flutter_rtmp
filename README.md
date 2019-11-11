# flutter_rtmp



## 使用方法
>   **使用时建议要按照release版本号**

### 引入
#### 1.第一种方法
    flutter_rtmp:
       git: https://github.com/MEnigma/flutter_rtmp.git

#### 2.第二种
    flutter_rtmp: ^*.*.*


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
>*   android中使用[libWSLive](https://github.com/geeklx/myapplication2018/tree/master/p004_livedemo)

### 进度

* [x] 推流
* [x] 切换摄像头
* [ ] 美颜
* [ ] 旋转 (android端会根据宽高比调整横竖屏)


## [LICENSE](https://github.com/MEnigma/flutter_rtmp/blob/master/LICENSE)

* 参与者
>* mark < https://github.com/MEnigma >
>* youshinki < 327624872yzh@163.com >