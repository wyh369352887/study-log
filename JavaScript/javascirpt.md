# 《Javascript高级程序设计》部分内容

## 2019.12.02

1.`document.querySelector(someDom).style`

获取到的是通过元素的style属性设置的样式，不包含样式表层叠样式

`document.defaultView.getComputedStyle(someDom,null)`

获取元素所有计算后的样式(第二个参数是伪元素字符串，不需要时传null)

2.`offsetHeight、offsetWidth`：宽（高）+ 内边距 + 边框宽（高）度，不包括外边距，包含此元素的外边距以及包含元素的内边距

`offsetTop、offsetLeft`：上（左）外边框到包含元素的上（左）内边框的距离，包含此元素的外边距以及包含元素的内边距

`offsetParent`：不一定与parentNode相等，想求元素的offsetLeft或offsetTop，就遍历元素的offsetParent的offsetLeft或offsetTop值相加，直到根元素(根元素的offsetParent = null)

3.`scrollHeight、scrollWidth`：在没有滚动条的情况下，元素内容的总高(宽)度

`scrollTop、scrollLeft`：元素上（左）侧被隐藏的内容的高（宽）度

## 2019.12.03
1.`document.createNodeInerator()`和`document.createTreeWalker()`用于遍历dom结构

2.`document.createRange()`创建dom范围，进行后续操作

## 2019.12.06
1.`attachEvent() detachEvent()`IE中的`addEventListener removeEventListener`其中`this`指向window

2.`addEventListener`可以添加多个事件处理程序，按照添加的顺序执行,`attachEvent`也可以添加多个事件处理程序，按照相反的顺序执行

3.`removeEventListener`的第二个参数不能是匿名函数

4.封装兼容性高的事件操作程序(没有考虑`this`的指向问题)

```javascript
var EventUtil = {
    addHandler: function(element, type, handler){
        if (element.addEventListener){
            element.addEventListener(type, handler, false);
        } else if (element.attachEvent){
            element.attachEvent("on" + type, handler);
        } else {
            element["on" + type] = handler;
        }
    },
    getEvent: function(event){
            return event ? event : window.event;
    },
            getTarget: function(event){
                return event.target || event.srcElement;
    },
            preventDefault: function(event){
                if (event.preventDefault){
                    event.preventDefault();
                } else {
                    event.returnValue = false;
                }
    },
    stopPropagation: function(event){
        if (event.stopPropagation){
            event.stopPropagation();
        } else {
            event.cancelBubble = true;
        }
    ,}
    removeHandler: function(element, type, handler){
        if (element.removeEventListener){
            element.removeEventListener(type, handler, false);
        } else if (element.detachEvent){
            element.detachEvent("on" + type, handler);
        } else {
            element["on" + type] = null;
} }
};
```

5.`event.currentTarget`是注册事件的元素

`event.target`是事件发生的实际目标

P362

## 2019.12.09
1.可以通过`element.contextmenu`制作自定义的右键菜单

2.`DomContentLoaded`事件在dom树解析完毕后触发，不考虑js、css、img等资源是否下载完毕，触发时间早于`window.onload`

P402

## 2019.12.11
1.使用`clipboardEvent`和`execCommand`来操作剪贴板内容

P427

## 2019.12.12
1.HTML5表单元素的`required`属性，只有在进行表单的submit时才会发生作用

2.HTML5中Input的几种type属性`email`、`url`等，校验存在问题，建议使用正则手动校验

3.可以通过将`select[optionIndex] = null`的方式将下拉菜单的选项清除

4.可以使用`appendChild`方法将一个select中的option转移到另一个option中(appendChild方法如果传入一个已经存在的dom,将会先在父节点中将其删除)

5.canvas API
绘制矩形
```javascript
fillRect(x坐标,y坐标,宽度,高度)    //实心矩形
strokeRect(x坐标,y坐标,宽度,高度)  //描边矩形
clearRect(x坐标,y坐标,宽度,高度)    //清除矩形区域
```

绘制路径
```javascript
beginPath()   //开始绘制路径
arc(x,y,弧线半径,起始角度,结束角度,是否逆时针)   //以(x,y)为圆心绘制弧线
arcTo(x1,y1,x2,y2,半径) //从上一点开始绘制一条弧线到(x2,y2),且经过(x1,y1)
bezierCurveTo(c1x,c1y,c2x,c2y,x,y) //从上一点开始绘制贝塞尔曲线到(x2,y2),并且以(c1x,c1y)和(c2x,c2y)为控制点
lineTo(x,y)    //从上一点开始绘制直线到(x,y)
moveTo(x,y)    //将绘图游标移动到(x,y)，不画线
quadraticCurveTo(cx,cy,x,y)  //从上一点开始绘制二次曲线到(x,y),且(cx,cy)为控制点
rect(x,y,宽度,高度)  //从给定坐标开始绘制矩形路径，不同于fillRect()和strokeRect()绘制的独立形状
```

绘制文字
```javascript
font()  //设置文字样式(字体,字号等)
textAlign() //设置文字对齐方式
testBaseline()  //设置文字基线
fillText('文本内容',x,y)  //设置文本内容和位置,如果textAlign为`middle`,则(x,y)为文本块的中心点坐标;为`start`,则x坐标为文本块左端的位置;为`end`,x坐标为文本块右端的位置
```

上下文变换
```javascript
rotate(角度)    //旋转
scale(x轴倍率,y轴倍率)     //缩放
translate(x,y)     //将原点移动到(x,y)
```

绘制图像
```javascript
drawImage(图像,x坐标,y坐标,宽度,高度)     //可以多传入4个参数,只绘制图像中的某个区域(目标图像的x坐标,目标图像的y坐标,目标图像的宽度,目标图像的高度)
```

阴影
```
shadowColor     //阴影颜色
shadowOffsetX   //阴影x轴偏移量
shadowOffsetY   //阴影y轴偏移量
shadowBlur      //阴影模糊程度(px)
```

渐变
```javascript
通过`createLinearGradient`创建渐变实例
var gradient = context.createLinearGradient(起点x坐标,起点y坐标,终点x坐标,终点y坐标);
gradient.addColorStop(0~1的数字,色值)
最后将渐变实例添加到画布
context.fillStyle = gradient

通过`createRadialGradient`创建放射渐变实例
var gradient = context.createLinearGradient(起点圆心x坐标,起点圆心y坐标,起点圆半径,终点圆心x坐标,终点圆心y坐标,终点圆半径);
var gradient = context.createLinearGradient(起点x坐标,起点y坐标,终点x坐标,终点y坐标);
gradient.addColorStop(0~1的数字,色值)
最后将渐变实例添加到画布
context.fillStyle = gradient
```

模式(重复的图像,可以用来填充或描边图形)
```javascript
var pattern = content.createPattern(HTML<img>元素、<video>元素或另一个<canvas>元素,重复规则)
context.fillStyle = pattern
```

使用图像数据
```javascript
getImageData(x坐标,y坐标,宽度,高度)     //获取(x,y)为左顶点的矩形的图像数据

返回的是ImageData的实例,每个ImageData都有三个属性:width,height,data

data中是一个数组,保存着每一个像素点的红、绿、蓝、透明度的值
```

全局上下文透明度:`globalAlpha(0~1)`

后绘制的图形与先绘制的图形结合的行为
```
source-over(默认值):后绘制的图形位于先绘制的图形上方

source-in:后绘制的图形与先绘制的图形重叠的部分可见，两者其他部分完全透明

source-out:后绘制的图形与先绘制的图形不重叠的部分可见，先绘制的图形完全透明

source-atop:后绘制的图形与先绘制的图形重叠的部分可见，先绘制图形不受影响

destination-over:后绘制的图形位于先绘制的图形下方，只有之前透明像素下的部分才可见

destination-in:后绘制的图形位于先绘制的图形下方，两者不重叠的部分完全透明

destination-out:后绘制的图形擦除与先绘制的图形重叠的部分

destination-atop:后绘制的图形位于先绘制的图形下方，在两者不重叠的地方，先绘制的图形会变透明

lighter:后绘制的图形与先绘制的图形重叠部分的值相加，使该部分变亮

copy:后绘制的图形完全替代与之重叠的先绘制图形

xor:后绘制的图形与先绘制的图形重叠的部分执行“异或”操作
```

P463

## 2019.12.13
### WebGL

`ArrayBuffer`类型化数组,只表示内存中的一块地方,只能用它分配一定数量的字节

```
var buffer = new ArrayBuffer(20)    //分配20B的内存
```

创建了`ArrayBuffer`后,能够通过该对象获得的信息只有它包含的字节数

```
var bytes = buffer.byteLength;
```

数组缓冲器视图DataView

`var view = new DataView(buffer实例,开始位置,选择的字节长度)`

实例化之后,DataView对象会把开始位置和长度信息保存在`byteOffset`和`byteLength`中

读取和写入DataView的时候要根据实际操作的数据类型,选择相应的`getter`和`setter`方法

数据类型|getter|setter
:-:|:-:|:-:
有符号8位整数|getInt8(byteOffset)|setInt8(byteOffset, value)
无符号8位整数|getUint8(byteOffset)|setUint8(byteOffset, value)
有符号16位整数|getInt16(byteOffset,littleEndian)|setInt16(byteOffset,value,littleEndian)
无符号16位整数|getUint16(byteOffset,littleEndian)|setUint16(byteOffset,value,littleEndian)
有符号32位整数|getInt32(byteOffset,littleEndian)|setInt32(byteOffset,value,littleEndian)
无符号32位整数|getUint32(byteOffset,littleEndian)|setUint32(byteOffset,value,littleEndian)
32位浮点数|getFloat32(byteOffset,littleEndian)|setFloat32(byteOffset,value,littleEndian)
64位浮点数|getFloat64(byteOffset,littleEndian)|setFloat64(byteOffset,value,littleEndian)

`byteOffset`为字节偏移量,标识存储的开始位置,`littleEndian`是一个布尔值,表示读写数值时是否采用小端字节序(即将数据的最低有效位保存在低内存地址中)，而不是大端字节 序(即将数据的最低有效位保存在高内存地址中)。使用DataView得明确知道数据需要多少字节，并选择正确的读写方法,比如:

```javascript
var buffer = new ArrayBuffer(20),
    view = new DataView(buffer),
    value;
view.setUint16(0, 25);
view.setUint16(2, 50); //不能从字节 1 开始，因为 16 位整数要用 2B value = view.getUint16(0);
```

```javascript
var buffer = new ArrayBuffer(20),
    view = new DataView(buffer),
    value;

view.setUint16(0,25);
value = view.getUnit8(0);

alert(value); //0,因为数值25以16位长度被写入,前八位都是0
```

类型化视图

```
Int8Array    //表示 8 位二补整数。
Uint8Array    //表示 8 位无符号整数。
Int16Array    //表示 16 位二补整数。
Uint16Array    //表示 16 位无符号整数。
Int32Array    //表示 32 位二补整数。
Uint32Array    //表示 32 位无符号整数。
Float32Array    //表示 32 位 IEEE 浮点值。
Float64Array    //表示 64 位 IEEE 浮点值。
```

因为都继承自`DataView`,所以可以使用相同的构造函数参数进行实例化,第一个参数是要 使用 ArrayBuffer 对象，第二个参数是作为起点的字节偏移量(默认为 0)，第三个参数是要包含的字节数,只有第一个参数是必须的

```javascript
//创建一个新数组，使用整个缓冲器
var int8s = new Int8Array(buffer);
//只使用从字节 9 开始的缓冲器
var int16s = new Int16Array(buffer, 9);
//只使用从字节 9 到字节 18 的缓冲器
var uint16s = new Uint16Array(buffer, 9, 10);
```

能够指定缓冲器中的可用字节段,意味着能在一个缓冲器中存储不同类型的数值

```javascript
//使用缓冲器的一部分保存 8 位整数，另一部分保存 16 位整数 var int8s = new Int8Array(buffer, 0,10);
var uint16s = new Uint16Array(buffer, 11, 10);
```

每个视图构造函数都有一个名为BYTES_PER_ELEMENT的属性,表示类型化数组的每个元素需要多少字节,可以利用这个属性进行初始化

```javascript
//需要 10 个元素空间
var int8s = new Int8Array(buffer, 0, 10 * Int8Array.BYTES_PER_ELEMENT);
//需要 5 个元素空间
var uint16s = new Uint16Array(buffer, int8s.byteOffset + int8s.byteLength,5 * Uint16Array.BYTES_PER_ELEMENT);
//基于一个缓冲器创建了两个视图,前10B用于存放8位整数,后边的用于存放16位整数
```

如果为相应元素指定的字节数放不下相应的值,则实际保存的值是最大可能值的模

P468

## 2019.12.14
1.WebGL上下文

```javascript
var canvas = document.getElementById('canvas');
var gl = canvas.getContext('experimental-webgl);
```

2.准备绘图阶段，一般以某种实色清除<canvas>，为绘图做准备
```javascript
gl.clearColor(0,0,0,1);
gl.clear(gl.COLOR_BUFFER_BIT);
```

3.视口与坐标

视口坐标与网页坐标不同，坐标原点(0,0)位于<canvas>元素的左下角，通过viewport(x轴坐标,y轴坐标,宽度,高度)设置视口.

`gl.viewport(0,0,drawing.width,drawing.height)  //视口使用整个<canvas>`

视口内部坐标与定义视口的坐标系也不同，坐标原点(0,0)位于视口的中心，视口右上角坐标为(1,1)，视口左下角坐标为(-1,-1);

4.缓冲区

使用`gl.createBuffer()`创建缓冲区,使用`gl.bindBuffer()`绑定到webGL上下文，这两部做完以后，就可以用数据填充缓冲区了

在重载页面之前，缓冲区始终保存在内存中，需要手动调用`gl.deleteBuffer(buffer)`来释放缓存

5.错误

webGL不会主动抛出错误，需要使用`gl.getError()`判断是否有错误，返回值可能为：

```
gl.NO_ERROR //上一次操作没有错误
gl.INVALID_ENUM  //应该给方法传入webGL常量，参数错误
gl.INVALID_VALUE  //在需要无符号数的地方传入了数值
gl.INVALID_OPERATION  //在当前状态下不能完成操作
gl.OUT_OF_MEMORY  //没有足够的内存完成操作
gl.CONTEXT_LOST_WEBGL  //由于外部事件干扰，丢失了当前的webGL上下文
```

p480

## 2019.12.16

1.跨文档消息传递`postMessage(msg,origin)`,msg:消息字符串,origin:接受消息方来自哪个域名

`postMessage()`会触发接收消息方window对象的onmessage事件，`onmessage(msg,origin,source)`,msg:消息字符串,origin:发送消息方所在域名,source:发送消息方window的代理对象(只是一个代理，仅仅使用source调用postMessage()进行回执即可)

2.拖动事件的触发顺序:

dragstart => drag => dragend

当某个元素被拖动到一个有效的放置目标上时,会依次触发:

dragenter(进入有效区) => dragover(在有效区内移动) => dragleave(离开有效区)或drop(被放置在有效区内)

3.自定义放置目标:

```javascript
dom.addEventListener('dragenter',funciton(e){
    e.preventDefault();
},false);

dom.addEventListener('dragover',funciton(e){
    e.preventDefault();
},false);
```

4.`dataTransfer`对象的传递数据作用

```javascript
//传递text数据
event.dataTransfer.setData('text','some text');
var text = event.dataTransfer.getData('text');

//传递url数据
event.dataTransfer.setData('URL','http://www.url.com');
var url = event.dataTransfer.getData('URL');
```

5.`dataTransfer`对象可以确定拖动元素和放置元素可以接收什么操作(`dragEffect和effectAllowed`)

```
在ondragenter事件中为放置元素确定dropEffect属性,可能的值如下:
none           //不能把拖动元素放在这里
move           //应该把拖动元素移动到放置目标
copy           //应该把拖动元素复制到放置目标
link           //放置目标会打开拖动的元素(有URL)

在ondragstart事件中为拖动元素确定effectAllowed属性,可能的值如下:
uninitialized  //没有设置任何放置行为
none           //被拖动的元素不能有任何行为
copy           //只允许值为copy的dropEffect
link           //只允许值为link的dropEffect
move           //只允许值为move的dropEffect
copyLink       //允许copy + link
copyMove       //允许copy + move
linkMove       //允许link + move
all            //允许所有
```

## 2019.12.17

1.使元素可拖放,需给元素添加`draggable = "true"`属性

`<div draggable="true"></div>`

2.检测浏览器是否支持某种格式和编解码器

```javascript
var audio = document.getElementById('audio');

if(audio.canPlayType("audio/mpeg")){
    //canPlayType()返回值 //probably、maybe或空字符串
}
```

3.audio元素没有必要一定插入文档中才能播放,通过`new Audio()`生成一个audio对象并为其src属性赋值,在下载完成后调用play()方法即可播放

4.历史状态管理

```javascript
history.pushState(状态信息(对象),新状态的标题,可选的相对URL) //添加页面栈

```

点击浏览器的回退按钮会触发window对象的popstate事件,该事件有一个state属性,包含着pushState方法第一个参数中的内容

```javascript
history.replaceState(状态信息(对象),新状态的标题)  //重写当前页面栈层
```

5.try-catch语句

```javascript
try{
    //可能会发生错误的语句
}catch(e){
    //错误发生时的操作
}finally{
    //finall语句是可选的,一旦有finally语句,无论程序是否错误都会执行其中的代码
}
```

P505

## 2019.12.18

1.常见的错误类型:

```
类型转换错误:常发生于比较是否相等和if()语句。建议始终使用'==='比较是否相等,在if()语句的条件中使用布尔值

数据类型错误:常发生于给函数传递错误类型的参数

通信错误:常见于和服务器之间的通信
```

2.致命错误与非致命错误,区别:

致命错误:

+ 应用程序无法继续运行
+ 错误明显导致了用户的主要操作
+ 会导致其他连带错误

非致命错误:

+ 不影响用户的主要任务
+ 只影响页面的一部分内容
+ 可以恢复
+ 执行相同操作可以消除错误

P520

## 2019.12.19

1.JSON是一种数据格式，不是一种语言

2.JSON的属性必须用双引号包裹，单引号会导致语法错误

3.JSON无需分号结尾

4.`JSON.stringify()`接收3个参数,第一个参数是一个js对象,

第二个参数是一个数组时:

```
var obj = {
    name:'Bob',
    age:25,
    sex:'male'
}

JSON.stringify(obj,['name','age']);

//"{"name":"Bob","age":25}"  只会返回数组中包含的属性
```

第二个参数是一个函数时:

```javascript
var obj = {
    name:'Bob',
    age:25,
    sex:'male',
    city:'ShangHai'
}

JSON.stringify(obj,function(key,value){
    switch(key){
        case 'name':
            return 'Hi, ' + value;
        case 'age':
            return undefined;
        case 'sex':
            return 'unknown';
        default:
            return value;
    }
})

//"{"name":"Hi, Bob","sex":"unknown","city":"ShangHai"}"

//作为第二个参数的函数接收2个参数,第一个是键名,第二个是键值
//可根据键名对键值进行操作
//当return undefined时,删除此属性
//同时一定要添加default,保持未操作的属性不被改变
```

第三个参数用于控制结果中的缩进和空白符:为数值时,每一行缩进数值位的空格(最大为10),为字符串时,用字符串代替空格进行缩进

5.可以为任何对象添加toJSON()方法,修改默认的stringify()行为

```javascript
var obj = {
    name:'Bob',
    age:25,
    sex:'male',
    city:'ShangHai',
	toJSON:function(){
        return this.name
    }
}

JSON.stringify(obj) //"Bob"
```

6.将一个对象传入`JSON.stringify()`方法,序列化该对象的顺序如下:

    a. 如果对象存在`toJSON()`方法且能通过它取得有效值,则调用该方法,否则返回对象本身
    b. 如果`JSON.stringify()`提供了第二个参数,则应用该过滤器,传入过滤器的是(1)的返回值
    c. 对(2)的返回值进行相应的序列化
    d. 如果提供了第三个参数,则进一步进行序列化

7.`JSON.parse()`也可以接收2个参数,第一个参数是JSON字符串,第二个参数与与`JSON.stringify()`的第二个参数类似,但不能为数组

P570

## 2019.12.20

1.xhr用法

```javascript
var xhr = new XMLHttpRequest();
xhr.onreadystatechange = function(){
    if(xhr.readyStatus == 4){
        if((xhr.status >= 200 && xhr.status < 300) || xhr.status == 304){
            alert(xhr.responseText);
        }else{
            alert("request was unsuccessful: " + xhr.status);
        }
    }
}
xhr.open('get','example.php',true);  //第一个参数是请求方法,第二个参数是请求目标,第三个参数表示是否异步
xhr.send(null); //send()方法接收一个参数,是请求主体发送的数据
                //在接收到相应之前还可以调用xhr.abort()来取消异步请求
```

2.请求头和响应头

使用`xhr.setRequestHeader('自定义请求头','值')`可以设置自定义请求头,但必须在xhr.open()方法之后,同时在xhr.send()方法之前

使用`xhr.getResponseHeader(‘头部名称’)`可以获得指定的响应头,使用`xhr.getAllResponseHeader()`可以获得一个包含所有头部信息的长字符串

3.判断是否为数组、函数、正则表达式、原生JSON对象

`Object.prototype.toString.call(value) == "[object Function]"`
`Object.prototype.toString.call(value) == "[object Array]"`
`Object.prototype.toString.call(value) == "[object RegExp]"`
`window.JSON && Object.prototype.toString.call(value) == "[object JSON]"`

4.作用域安全的构造函数

```javascript
function Person(name,age){
    if(this instanceof Person){
        this.name = name;
        this.age = age;
    }else{
        return new Person(name,age);
    }
}
var Ann = new Person('Ann',20);
var Bob = Person('Bob',22);

Ann.name //'Ann'
Bob.name //'Bob'

//在没有使用new关键字调用构造函数时,构造函数内的this指向Window,会导致错误的属性赋值
```

5.惰性载入函数:对环境确定即唯一确定的属性或对象等进行检查的函数,实际上只有第一次的执行是有意义的

第一种思路:

```javascript
function foo(){
    if(someValue == 'a'){
        foo = function(){
            //do something a
        }
    }else if(someValue == 'b'){
        foo = function(){
            //do something b
        }
    }else if(someValue == 'c'){
        foo = funtion(){
            //do something c
        }
    }
    ........
    return foo();
}
```

第二种思路:

```javascript
var foo = (function(){
    if(someValue == 'a'){
        return function(){
            //do something a
        }
    }else if(someValue == 'b'){
        return function(){
            //do something b
        }
    }else if(someValue == 'c'){
        return function(){
            //do something c
        }
    }
    ...
})();
```
P606

## 2019.12.23

1.对象防篡改
`Object.preventExtensions()`可以使对象不能再被扩展(不可逆转)

`Object.isExtensible()`检测对象是否可以扩展

`Object.seal()`可以将对象密封：不能增加和删除属性，可以修改已有属性

`Object.isSeal()`检测对象是否密封,`Object.isExtensible()`检测密封对象同样会返回true

`Object.freeze()`是最严格的对象防篡改级别，不可扩展、不可删除、不可修改对象的属性。(如果定义了属性的[[set]]函数，属性仍然可写);

`Object.isFrozen()`检测对象是否冻结，同样，冻结的对象`Object.isExtensible()`和`Object.isSeal()`都返回true

2.定时器

`setTimeout`和`setInterval`并不是表示在指定时间后执行（重复执行）事件，而是在指定事件后将事件添加到线程队列中。

重复定时器:使用`setTimeout`来实现`setInterval`的功能，同时避免了因为定时器代码的执行时间大于定时器的间隔带来的间隔丢失问题

```javascript
var interval = 500;
setTimeout(funciton(){
    //do some thing
    setTimeout(arguments.callee,interval);
},interval);
```

3.分割任务:例如循环处理一个数组中的内容，如果不是必须同步完成处理或者不是必须按照顺序完成处理，可以对任务进行分割

```javascript
var array = [1,2,3,4,5,6,7,8,9];

function chunk(array,progress,context){   //array:待处理数组   progress:处理函数   context:处理函数的运行环境
    setTimeout(function(){
        var item = array.shift();       //取出数组中的第一个元素
        progress(item,context);

        if(array.length > 0){           //如果数组中还有元素，则创建下一个定时器
            setTimeout(argrments.callee,100);
        }
    },100);
}
```
P614

## 2019.12.24

1.函数节流:确保函数在请求停止了一段时间后才执行,避免过多的触发导致程序崩溃

```javascript
var processor = {
    timeoutId:null,
    //实际进行处理的方法
    performProcessing:function(){
        //do something here
    },
    process:function(){
        clearTimeout(this.timeoutId);

        var that = this;
        this.timeoutId = setTimeout(function(){
            that.performProcessing();
        },100);
    }
}

processor.process();

//100ms内,processor.performProcessing()只执行一次
```

2.自定义事件:应用于非DOM元素

```javascript
function EventTarget(){
    this.handlers = {};
    //用于储存事件处理程序
}

EventTarget.prototype = {
    constructor:EventTarget,
    addHandler:function(type,handler){
        if(typeof this.handlers[type] == 'undefined'){
            this.handlers[type] = [];
            //如果事件处理程序中没有针对该事件的数组,则创建一个
        }

        this.handlers[type].push(handler);
        //将事件push到该事件的处理程序数组末端
    },

    fire:function(event){
        //触发事件
        if(!event.target){
            event.target = this;
            //event事件的属性需要手动添加
        }
        if(this.handlers[event.type] instanceof Array){
            var handlers = this.handlers[event.type];
            for(var i = 0,len = handlers.length; i < len; i++){
                handlers[i](event);
            }
            //如果有针对该事件的处理程序,则依次调用
        }
    },

    removeHandler(type,handler){
        if(this.handlers[type] instanceof Array){
            var handlers = this.handlers[type];
            for(var i = 0,len = handlers.length; i < len; i++){
                if(handlers[i] === handler){
                    break;
                }
            }
            //查找针对该事件的处理程序中是否有指定名称的方法,如果找到则跳出循环
            handlers.splice(i, 1);
            //如果找到了对应的方法,删除。如果没有找到,不删除任何东西
        }
    }
}
```
P617

## 2019.12.25

1.`navigator.onLine`返回设备是否联网

2.window对象还有`online`和`offline`两个事件,在设备从离线转为在线和在线转为离线时触发

3.cookie大小限制为4kb(4096B±1B),作用于一个域名下的所有cookie,而非每个cookie单独限制

4.cookie格式:name = value

  子cookie格式: name = name1 = value1 & name2 = value2 & name3 = value3 ...

  P637

## 2019.12.27

1.`document.visibilityState`表示页面的可见状态

2.document的`visibilityChange`事件在页面由可见 => 不可见 或由 不可见 => 可见时触发

3.`navagator.geolocation.getCurrentPosition(successCallback,errorCallback,option)`获取地理位置API

`successCallback`接受一个对象参数,其中可能包括:

```
latitude:十进制纬度
longitude:十进制经度
accuracy:经纬度坐标的精确度,以米为单位
altitude:海拔,米为单位,没有则为null
altitudeAccuracy:海拔经度,越大越不准确
heading:指南针的方向,0表示正北,值为NaN表示没有检测到数据
speed:速度,m/s,如果没有则为null
```

`errorCallback`也接受一个对象参数,其中包括两个属性:`message`:出错的为本信息,`code`:错误类型(1:用户拒绝共享,2:位置无效,3:超时);

`option`是一个配置对象,其中包括3个属性:

```
enableHighAccuracy:Boolean,是否尽可能使用准备的位置信息
timeout:超时时间
maximumAge:表示上一次取得的坐标信息的有效时间，以毫 秒表示，如果时间到则重新取得新坐标信息
```

4.`navigator.geolocation.watchPosition(successCallback,errorCallback,option)`跟踪用户的地理位置,参数用法同上

5.FileReader

FileReader是一种异步文件读取机制,可以想象成XMLHttpRequest,提供了如下方法:

```javascript
readAsText(file,encoding):以纯文本形式读取文件，将读取到的文本保存在 result 属 性中。第二个参数用于指定编码类型，是可选的
readAsDataURL(file):读取文件并将文件以数据 URI 的形式保存在 result 属性中
readAsBinaryString(file):读取文件并将一个字符串保存在result属性中，字符串中的
每个字符表示一字节
readAsArrayBuffer(file):读取文件并将一个包含文件内容的 ArrayBuffer 保存在
result 属性中
```

同时提供了如下事件:

```
progress:每50ms触发一次,表示是否又读取了新数据
error:发生错误(错误码:1 表示未找到文件,2表示安全性错误,3表示读取中断,4表示文件不可读,5表示编码错误)
load:读取完成
loadend:读取结束,无论成功还是失败
```

6.读取部分内容:File对象提供了一个slice(startByte,length)方法,第一个参数表示开始的字节数,第二个参数表示要读取的字节数

7.对象URL:又叫blob URL,指的是引用保存在File或Blob中数据的URL,可以不用将文件内容读取到js中直接使用

```
创建blob URL:window.URL.createObjectURL(File或Bolb对象)
释放:window.URL.revokeObjectURL(URL对象)
```

P696

## 2019.12.30

1.`window.performence`对象记录了页面加载过程中的各种时间

2.Web Workers:浏览器使用线程、后台进程、其他处理器运行一些比较消耗性能的js,从而避免影响用户体验

```javascript
var worker = new Worker("file.js");  //传入要执行的Js文件名

work.postMessage("start!")  //页面与worker中的代码通信,传递的数据可以是任意能够被序列化的值

//注意,只有当worker接受到消息才会实际开始执行代码
```

worker的onmessage事件和onerror事件:

```javascript
//接收worker返回的信息
worker.onmessage = function(event){
    var data = event.data;

    //对data进行处理
}

//接受worker抛出的错误
worker.onerror = function(event){
    var filename = event.filename;  //出错的文件名
    var lineno = event.lineno //代码行数
    var message = event.message //详细错误信息
}
```

停止worker工作:`worker.terminate()`;

worker内部接收页面传来的数据:

```javascript
//worker内部的全局对象是worker本身,即this、self指向worker

self.onmessage = function(event){
    var data = event.data;

    //处理data
}
```

worker内部终止任务:`self.close()`;

3.剩余参数和分布参数

```javascript
function foo(num1,num2,...nums){
    //do some thing
}
//表示函数foo接收至少两个参数,当传入参数大于2时,其他的参数以数组的形式保存在nums变量中

foo(...[1,2,3,4,5]);
//将一个数组作为参数传递给函数foo,数组中的元素与已表明的函数参数一一对应,超出的部分以数组的形式保存在变量nums中

//剩余参数在声明函数的时候使用,分布参数在调用函数的时候使用
```

4.解构赋值:允许字面量出现在等号左边

```javascript
//可以用来交换两个变量

var value1 = 5;
var value2 = 10;
[value1,value2] = [value2,value1];
//value1 = 10,value2 = 5;
```

```javascript
var person = {
    name:'wang',
    age:18
}
var {name:myName,age:myAge} = person;

//name => wang
//age => 18
//实际上相当于定义了myName和myAge两个变量,并取得了person对象中对应的值
```

《JavaScript高级程序设计(第三版)》结束

### 事件委托
---

事件冒泡:从当前触发的事件目标一级一级向上传递，直到document为止<br/>
事件捕获:从document开始触发，一级一级向下传递，直到真正事件目标为止<br/>
事件委托:通过监听父元素，给不同子元素绑定事件，减少监听次数，从而提升速度<br/>

### 原型链
---

`__proto__`和`constructor`属性是对象独有的,`prototype`属性是函数独有的,又因为函数也是一种对象,所以函数也拥有`__proto`和`constructor`属性

从一个实例访问某属性:

```javascript
var foo = {},
    F = function(){};

Object.prototype.a = 'value a';
Function.prototype.b = 'value b';

foo.a //'value a'
foo.b //undefined
F.a   //'value a'
F.b   //'value b'

foo.a ==> foo.__proto__.a ==> Object.prototype.a  // 'value a'
foo.b ==> foo.__proto__.b ==> Object.prototype.b  // undefined
F.a ==> F.__proto__.a ==> Function.prototype.a ==> Function.prototype.__proto__.a ==> Object.prototype.a 
// 'value a',(*此时把Function.prototype视作一个普通对象)
F.b ==> F.__proto__.b ==> Function.prototype.b // 'value b'
```

### 构造函数的返回值
---

构造函数不需要显式的返回值:当return一个非对象时(数字,字符串,布尔值等),会忽略返回值;当return一个对象时,则返回该对象(* return null也会忽略返回值)

### instanceof
---

作用:测试一个构造函数的`prototype`属性是否存在于一个对象的原型链上,也就是检查对象是否是该构造函数的实例
```
let obj = {};
obj instanceof Object //true
//obj.__proto__ === Object.prototype;
```

### 宏任务与微任务
---

`setTimeout(fn,time)`:延迟`time`秒后将函数`fn`推入主线程队列。由于主线程队列里的任务执行也需要时间,所以一般延迟执行的时间总是大于`time`。同时根据HTML的标准,`setTimeout(fn,0)`也并不是在主线程任务完成后0秒就执行`fn`,最快是4ms。

`setInterval(fn,time)`:每隔`time`秒就将`fn`推入主线程队列一次。与`setTimeout`类似,有一点不同的要注意,如果`fn`的执行时间大于`time`,那么每两次`fn`执行过程之中将完全没有时间间隔。

除了广义的同步任务和异步任务,我们对任务还有更精细的定义:

宏任务:包括整体代码,setTimeout,setInterval
微任务:Promise,process.nextTick(callback),Async/Await

#### js执行顺序:
---

![loop](https://user-gold-cdn.xitu.io/2017/11/21/15fdcea13361a1ec?imageView2/0/w/1280/h/960/format/webp/ignore-error/1 "流程图")

### 普通函数和箭头函数的区别
---

1. 普通函数的`this`指向调用它的对象(无则为`window`);箭头函数没有自己的`this`,所以它的`this`指向定义它时的环境上下文。

2. 普通函数可以是署名函数可以是匿名函数,箭头函数全都是匿名函数

3. 普通函数可以用于构造函数(`new`关键字),箭头函数不能用于构造函数

4. 普通函数内部有`arguments`对象,箭头函数没有

### for...in和for...of
---
`for...in`:可以枚举普通对象,可以枚举数组,返回对象(数组)的键名(元素下标),但是无法过滤掉原型上的属性或者数组的非元素属性(借助`hasOwnProperty()`可以过滤掉原型上的属性)

`for...of`:可以迭代所有设置了迭代器`[Symbol.iterator]`的数据结构(对于手动设置了`[Symbol.iterator]`的普通对象也可以迭代)

### 深拷贝与浅拷贝
---

>本节参考

>https://juejin.im/post/5d6aa4f96fb9a06b112ad5b1

>https://juejin.im/post/59ac1c4ef265da248e75892b

#### 堆和栈的区别:
栈:自动分配的内存空间,它由系统自动释放

堆:动态分配的内容,大小不定也不会自动释放

#### 基本数据类型和引用数据类型
基本数据类型主要是:`undefined,null,boolean,string,number`
基本数据类型存放在栈中,且值不可变,动态修改了基本数据类型的值,它的原始值不会改变,而是返回了一个新的基本数据类型。

引用数据类型(`object`)是存放在堆内存中的,变量实际上是一个存放在栈内存中的指针,指向堆内存中实际的地址。每个空间大小不一样,要根据情况进行特定的分配。引用数据类型的值是可以改变的。

#### 赋值与浅拷贝

```javascript
let obj = {
    name:'foo',
    age:20,
    family:{
        dad:'bar',
        mom:'baz'
    }
}
let obj2 = obj;
let obj3 = shallowCopy(obj);
function shallowCopy(source){
    let target = {};
    for(let prop in source){
        if(source.hasOwnProperty(prop)){
            target[prop] = source[prop];
        }
    }
    return target
}
obj.age = 18;
obj.family.dad = 'woo';
console.log(obj)//{ name: 'foo', age: 18, family: { dad: 'woo', mom: 'baz' } }
console.log(obj2)//{ name: 'foo', age: 18, family: { dad: 'woo', mom: 'baz' } }
console.log(obj3)//{ name: 'foo', age: 20, family: { dad: 'woo', mom: 'baz' } }
```
对于赋值来说,源对象实际上与赋值得来的新对象都指向堆内存中的同一个对象,所以改变任何属性都会彼此影响
对于浅拷贝来说,借助了基本数据类型的特性,对源对象第一层的数据进行枚举并手动赋值,如果该数据是基本数据类型,那么修改时不会彼此影响;如果该数据是引用数据类型,那么在修改时还是会彼此影响,此时需借助深拷贝来切断这种联系。

#### 浅拷贝与深拷贝
在不考虑其他情况的前提下,最简单粗暴的一个深拷贝方法:
```javascript
JSON.parse(JSON.stringify())
```
缺点是无法拷贝函数以及其他的引用数据类型,无法拷贝`undefined`,无法解决循环引用的问题

那么就必须在浅拷贝的思路上进行改进:
```javascript
function deepCopy(source){
    if(typeof source === 'object'){
        let target = {};
        for(let prop in source){
            if(source.hasOwnProperty(prop)){
                //递归直到属性为基本数据类型
                target[parop] = deepCopy(source[prop]);
            }
        }
        return target
    }else{
        return source
    }
}
```

但是js中并不是只有`object`一种引用数据类型,另外的比如还有`array`

```javascript
function deepCopy(source){
    if(typeof source === 'object'){
        let target = Array.isArray(source) ? [] : {};
        for(let prop in source){
            if(source.hasOwnProperty(prop)){
                target[parop] = deepCopy(source[prop]);
            }
        }
        return target
    }else{
        return source
    }
}
```

接着再解决一个`JSON.parse(JSON.stringify())`无法处理的循环引用问题

```javascript
function deepCopy(source,map = new Map()){
    if(typeof source === 'object'){
        let target = Array.isArray(source) ? [] : {};
        if(map.get(source)){
            return map.get(source)
        }
        map.set(source,target);
        for(let prop in source){
            if(source.hasOwnProperty(prop)){
                target[parop] = deepCopy(source[prop]);
            }
        }
        return target
    }else{
        return source
    }
}
```

到这里只考虑了`object`和`array`两种最为常用的引用数据类型,当然还有其他的引用数据类型(`function`,`null`),以及可遍历的数据结构(`map`,`set`),不可遍历的类型(`boolean`,`number`,`string`,`date`,`error`)等等,这时候可以借助`Object.prototype.toString()`去精准识别数据类型,再对其进行进一步的操作处理。

---

# 《Javascript高级程序设计》第四版更新内容

## `0.1 + 0.2 != 0.3`

> 由于转化二进制时的误差，所有采用IEEE 754标准的语言都存在该问题

### 解决方式

```javascript
// 1.toFixed(),不推荐
(0.1 + 0.2).toFixed(2) === (0.3).toFixed(2) // true

// 2.乘法分配律结合等式的性质
0.1 * 1e10 + 0.2 * 1e10 === 0.3 * 1e10 // true

// 3.Number.EPSILON:表示 1 与Number可表示的大于 1 的最小的浮点数之间的差值。当浮点数运算的误差小于这个值，可以视作没有误差
Math.abs(0.1 + 0.2 - 0.3) < Number.EPSILON
```

---

## `Number()、parseInt()、parseFloat()`

### Number()函数转换规则:

```javascript
/*
Boolean:
true => 1,false => 0
*/
Number(true) = 1
Number(false) = 0

/*
Null: null => 0,
*/
Number(null) = 0

/*
Undefined: undefined => NaN
*/
Number(undefined) = NaN

/*
字符串:
包含符号的有效十进制数字符串 => 带符号的十进制数(忽略前边的0)
*/
Number("1") = 1
Number("123") = 123
Number("011") = 11

/*
包含有效的浮点值格式 => 带符号的浮点数数(忽略前边的0)
*/
Number("1.1") = 1.1
Number("-1.1") = -1.1
Number("00001.1") = 1.1

/*
包含有效的十六进制格式 => 该十六进制值对应的十进制数值
*/
Number("0xf") = 15

/*
空字符串 => 0
*/
Number("") = 0

/*
对象，调用 valueOf() 方法，并按照上述规则转换返回的
值。如果转换结果是 NaN ，则调用 toString() 方法，再
按照转换字符串的规则转换。
*/
```

### parseInt()转换规则

```javascript
/*
parseInt()更关注字符串是否包含数值模式:
从第一个非空字符开始，如果不是数值字符或加号减号，立即返回NaN
直到字符串结束，或碰到非数值字符
*/
parseInt("") = NaN
parseInt("1234blue") = 1234
parseInt("12.34") //parseInt()只针对整数,小数点不是有效的整数字符

/*
可以传入第二个参数指定不同进制，识别相对应的正确有效字符
*/
parseInt("AF", 16) = 175
parseInt("AF") = NaN // 默认十进制
```

### parseFloat()转换规则

```javascript
/*
与parseInt()类似，不同的地方：
1.可以识别一个小数点，从第二个小数点开始视为无效字符
2.始终忽略开头的零，且只解析十进制
*/
parseFloat("1234blue") = 1234
parseFloat("0xA") = 0
parseFloat("22.5") = 22.5
parseFloat("22.5.34") = 22.5
parseFloat("0908.5") = 908.5
```

---

## `Math.floor()、Math.ceil()、~~`

```javascript
/* 
两个按位取反操作符组合起来被一部分人用来当做取整操作
实际上表现的功能为：省略小数部分
在数字的符号不同时表现行为也稍有不同
*/

// number < 0 时，~~与Math.ceil()功能相同，向上取整
~~-1.3 = -1
Math.ceil(-1.3) = -1
Math.floor(-1.3) = -2

// number > 0 时，~~与Math.floor()功能相同，向下取整
~~1.3 = 1
Math.floor(1.3) = 1
Math.ceil(1.3) = 2
```