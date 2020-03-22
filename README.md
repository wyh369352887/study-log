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
```
fillRect(x坐标,y坐标,宽度,高度)    //实心矩形
strokeRect(x坐标,y坐标,宽度,高度)  //描边矩形
clearRect(x坐标,y坐标,宽度,高度)    //清除矩形区域
```

绘制路径
```
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
```
font()  //设置文字样式(字体,字号等)
textAlign() //设置文字对齐方式
testBaseline()  //设置文字基线
fillText('文本内容',x,y)  //设置文本内容和位置,如果textAlign为`middle`,则(x,y)为文本块的中心点坐标;为`start`,则x坐标为文本块左端的位置;为`end`,x坐标为文本块右端的位置
```

上下文变换
```
rotate(角度)    //旋转
scale(x轴倍率,y轴倍率)     //缩放
translate(x,y)     //将原点移动到(x,y)
```

绘制图像
```
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
```
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
```
var pattern = content.createPattern(HTML<img>元素、<video>元素或另一个<canvas>元素,重复规则)
context.fillStyle = pattern
```

使用图像数据
```
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

```
var buffer = new ArrayBuffer(20),
    view = new DataView(buffer),
    value;
view.setUint16(0, 25);
view.setUint16(2, 50); //不能从字节 1 开始，因为 16 位整数要用 2B value = view.getUint16(0);
```

```
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

```
//创建一个新数组，使用整个缓冲器
var int8s = new Int8Array(buffer);
//只使用从字节 9 开始的缓冲器
var int16s = new Int16Array(buffer, 9);
//只使用从字节 9 到字节 18 的缓冲器
var uint16s = new Uint16Array(buffer, 9, 10);
```

能够指定缓冲器中的可用字节段,意味着能在一个缓冲器中存储不同类型的数值

```
//使用缓冲器的一部分保存 8 位整数，另一部分保存 16 位整数 var int8s = new Int8Array(buffer, 0,10);
var uint16s = new Uint16Array(buffer, 11, 10);
```

每个视图构造函数都有一个名为BYTES_PER_ELEMENT的属性,表示类型化数组的每个元素需要多少字节,可以利用这个属性进行初始化

```
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

```
var canvas = document.getElementById('canvas');
var gl = canvas.getContext('experimental-webgl);
```

2.准备绘图阶段，一般以某种实色清除<canvas>，为绘图做准备
```
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

```
dom.addEventListener('dragenter',funciton(e){
    e.preventDefault();
},false);

dom.addEventListener('dragover',funciton(e){
    e.preventDefault();
},false);
```

4.`dataTransfer`对象的传递数据作用

```
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

```
var audio = document.getElementById('audio');

if(audio.canPlayType("audio/mpeg")){
    //canPlayType()返回值 //probably、maybe或空字符串
}
```

3.audio元素没有必要一定插入文档中才能播放,通过`new Audio()`生成一个audio对象并为其src属性赋值,在下载完成后调用play()方法即可播放

4.历史状态管理

```
history.pushState(状态信息(对象),新状态的标题,可选的相对URL) //添加页面栈

```

点击浏览器的回退按钮会触发window对象的popstate事件,该事件有一个state属性,包含着pushState方法第一个参数中的内容

```
history.replaceState(状态信息(对象),新状态的标题)  //重写当前页面栈层
```

5.try-catch语句

```
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

```
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

```
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

```
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

```
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

```
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

```
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

```
var interval = 500;
setTimeout(funciton(){
    //do some thing
    setTimeout(arguments.callee,interval);
},interval);
```

3.分割任务:例如循环处理一个数组中的内容，如果不是必须同步完成处理或者不是必须按照顺序完成处理，可以对任务进行分割

```
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

```
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

```
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

```
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

```
var worker = new Worker("file.js");  //传入要执行的Js文件名

work.postMessage("start!")  //页面与worker中的代码通信,传递的数据可以是任意能够被序列化的值

//注意,只有当worker接受到消息才会实际开始执行代码
```

worker的onmessage事件和onerror事件:

```
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

```
//worker内部的全局对象是worker本身,即this、self指向worker

self.onmessage = function(event){
    var data = event.data;

    //处理data
}
```

worker内部终止任务:`self.close()`;

3.剩余参数和分布参数

```
function foo(num1,num2,...nums){
    //do some thing
}
//表示函数foo接收至少两个参数,当传入参数大于2时,其他的参数以数组的形式保存在nums变量中

foo(...[1,2,3,4,5]);
//将一个数组作为参数传递给函数foo,数组中的元素与已表明的函数参数一一对应,超出的部分以数组的形式保存在变量nums中

//剩余参数在声明函数的时候使用,分布参数在调用函数的时候使用
```

4.结构赋值:允许字面量出现在等号左边

```
//可以用来交换两个变量

var value1 = 5;
var value2 = 10;
[value1,value2] = [value2,value1];
//value1 = 10,value2 = 5;
```

```
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

### TypeScript

1.元组:元组类型允许表示一个已知元素数量和类型的数组:

```
let x: [string, number];
x = ['hello',888];
```

2.枚举:枚举类型是对JavaScript标准数据类型的一个补充,使用枚举类型可以为一组数值赋予友好的名字

```
enum Color {Red,Blue,Green};
let c:Color = Color.Green;
```

默认情况下,从0开始为元素编号,也可以手动为元素编号:

```
//从1开始编号
enum Color {Red = 1,Blue,Green};

//全部手动编号
enum Color {Red = 1,Blue = 2,Green = 4};
```

使用枚举类型的一个方便之处是由枚举的值得到他的名字:

```
enum Color { Red = 1, Blue, Green};
let num:string = Color[2];
//'Blue'
//
```

3.Any:Any类型用于在编译时还不确定类型的变量

```
let noSure:any = 4;
noSure = "some string"; //ok
noSure = false; //ok
```

4.void:void类型与Any相反,表示没有任何类型,当一个函数没有返回值时,通常会见到其返回值类型是void

```
function foo(): void{
    //do something without return
}
```

5.null和undefined:在默认情况下null和undefined是所有类型的子类型,即可以把null和undefined赋值给其他的类型,但是在开启了`--stricNullChecks`标记后,只能将他们赋值给自身

```
let n:null = null;
let u:undefined = undefined;
```

6.Never:never类型表示的是永不存在的值的类型,never类型可以被赋值给任何类型,但是任何类型都不能赋值给never类型(除了never本身)

7.Object:object类型表示非原始类型,也就是除number,string,boolean,symbol,null,undefined之外的类型

8.类型断言:跳过了编译器的语法检查

```
//两种语法
let someValue:any = 'this is a string';
let strLength:number = (<string>someValue).length;

let someValue:any = 'this is a string';
let strLength:number = (someValue as string).length;
```

## 2019.12.31

1.
### 接口:

```
//定义接口,描述要求
interface LabelledValue{
    label:string
}

//使用接口检查参数
function foo(labelledObj:LabelledValue){
    console.log(laballedObj.label);
}

let myObj = {size:10,label:'some string'};

foo(myObj);

//*并不会检查属性的顺序
```

##### 可选属性:属性名后 + ?

```typescript
interface SquareConfig {
  color?: string;
  width?: number;
}

function createSquare(config: SquareConfig): {color: string; area: number} {
  let newSquare = {color: "white", area: 100};
  if (config.color) {
    newSquare.color = config.color;
  }
  if (config.width) {
    newSquare.area = config.width * config.width;
  }
  return newSquare;
}

let mySquare = createSquare({color: "black"});//参数中没有"width"属性也可以通过编译
```

##### 只读属性:属性名前 + readonly

```typescript
interface Point {
    readonly x: number;
    readonly y: number;
}

let p1: Point = { x: 10, y: 20 };
//使用Point接口初始化一个变量

p1.x = 5; 
// error, x为只读属性
```

```typescript
//ts中具有ReadonlyArray类型,与普通的Array类似,只是把所有可变方法都去掉了,所以是只读数组
let a: number[] = [1, 2, 3, 4];
let ro: ReadonlyArray<number> = a;

ro[0] = 12; 
// error,不可修改

ro.push(5);
// error,不可修改

ro.length = 100;
// error,不可修改

a = ro; 
// error,赋值给一个普通数组也不行,但是可以用类型断言重写

a = ro as number[];
```

定义包含接口中不存在的属性时,ts中会报错:

```typescript
interface SquareConfig {
    color?: string;
    width?: number;
}

let mySquare: SquareConfig = { msg: "hi", width: 100 };
//error,SquareConfig中没有msg属性

//a.可以通过类型断言绕过检查
let mySquare: SquareConfig = { msg: "hi", width: 100 } as SquareConfig;

//b.可以通过添加字符索引签名规避该问题
interface SquareConfig{
    color?:string;
    width?:number;
    [propName:string]:any;  //不限制SquareConfig的属性数量,只要属性名不是color或width,那么他的类型可以是任何值
}

//c.可以将对象赋值给另一个变量规避该问题
let squareOptions = {colour:"red",width:100};
let mySquare = createSquare(squareOptions);//因为squareOpitons不会经过额外属性检查的步骤,所以编译器不会报错
```

## 2020.1.2

##### 函数类型:接口除了可以描述普通对象,还可以描述函数类型

```typescript
//定义一个函数类型接口
interface func {
    (param1:number ,param2:string):boolean
}
//定义了一个有两个参数的函数类型接口,第一个参数为number类型,第二个参数为string类型,函数返回值时boolean类型

let myFunc:func;

myFunc = function(p1,p2):boolean{
    //do some thing
    return false
}
//函数调用时的参数名不必与接口中的名字相同,编译器会对位检查参数类型,符合即可

```

##### 可索引的类型:

```typescript
interface StringArray {
    [index:number]:string
}
//支持number和string两种索引方式,但两种方法返回值必须保持一致

let myArray:StringArray;
myArray = ["red","blue"];

let myStr:string = myArray[0]

//可以将索引签名前加"readonly"将索引设为只读
interface StringArray {
    readonly [index:number]:string
}
```

##### 类 类型:强制一个类去符合某种契约

```typescript
interface ClockInterface {
    currentTime:Date;
    setTime(d:Date);
}

class Clock implements ClockInterface {
    currentTime:Date;
    setTime(d:Date){
        //do some thing
    };
    constructor(h:number,m:number){};
}
//接口规定了类的公共成员,不检查私有成员
```

##### 接口的继承:

```typescript
interface Shape {
    color: string;
}

interface Square extends Shape {
    sideLength: number;
}

let square = <Square>{};
square.color = "blue";
square.sideLength = 10;
```

一个接口也可以继承多个接口

```typescript
interface Shape {
    color: string;
}

interface PenStroke {
    penWidth: number;
}

interface Square extends Shape, PenStroke {
    sideLength: number;
}

let square = <Square>{};
square.color = "blue";
square.sideLength = 10;
square.penWidth = 5.0;
```

##### 混合类型接口:

```typescript
//一个对象可以同时作为函数和对象使用,并带有额外的属性
interface Counter {
    (start: number): string;
    interval: number;
    reset(): void;
}

function getCounter(): Counter {
    let counter = <Counter>function (start: number) { };
    counter.interval = 123;
    counter.reset = function () { };
    return counter;
}

let c = getCounter();
c(10);
c.reset();
c.interval = 5.0;
```

##### 接口继承类:

```typescript
//接口继承类时,同时继承了类的私有成员,因此只有类的子类才能实现接口,因为只有类的子类能拥有这个私有成员
class Control {
    private state: any;
}

interface SelectableControl extends Control {
    select(): void;
}

class Button extends Control implements SelectableControl {
    select() { }
}

class TextBox extends Control {
    select() { }
}

// 错误：“Image”类型缺少“state”属性。
class Image implements SelectableControl {
    select() { }
}
```

## 2020.1.3

### 类

##### 类的继承

```typescript
class Animal{
    move(distanceInMeters:number = 0){
        console.log(`Animal moved ${distanceInMeters}m.`);
    }
}

class Dog extends Animal {
    bark(){
        console.log('woo! woo!');
    }
}

const dog = new Dog();
dog.bark();
dog.move(10);
dog.bark();
//woo! woo!
//Animal moved 10m.
//woo! woo!
```

派生类包含了一个构造函数，它 必须调用 super()，它会执行基类的构造函数。 而且，在构造函数里访问 this的属性之前，我们 一定要调用 super()。 这个是TypeScript强制执行的一条重要规则。


```typescript
class Animal {
    name: string;
    constructor(theName: string) { this.name = theName; }
    move(distanceInMeters: number = 0) {
        console.log(`${this.name} moved ${distanceInMeters}m.`);
    }
}

class Snake extends Animal {
    constructor(name: string) { super(name); }
    move(distanceInMeters = 5) {
        console.log("Slithering...");
        super.move(distanceInMeters);
    }
}

class Horse extends Animal {
    constructor(name: string) { super(name); }
    move(distanceInMeters = 45) {
        console.log("Galloping...");
        super.move(distanceInMeters);
    }
}

let sam = new Snake("Sammy the Python");
let tom: Animal = new Horse("Tommy the Palomino");

sam.move();
tom.move(34);
//Slithering...
//Sammy the Python moved 5m.
//Galloping...
//Tommy the Palomino moved 34m.
```

##### 公共,私有与受保护的修饰符

类的成员默认为公开的(public),声明是不表明等同于在属性、方法或构造函数前加 `public`

```typescript
class Animal {
    public name: string;
    public constructor(theName: string) { this.name = theName; }
    public move(distanceInMeters: number) {
        console.log(`${this.name} moved ${distanceInMeters}m.`);
    }
}
```

##### 私有成员:private

```typescript
class Animal {
    private name: string;
    constructor(theName: string) { this.name = theName; }
}

new Animal("Cat").name; // 错误: 'name' 是私有的.
```

当我们比较带有 private或 protected成员的类型的时候，情况就不同了。 如果其中一个类型里包含一个 private成员，那么只有当另外一个类型中也存在这样一个 private成员， 并且它们都是来自同一处声明时，我们才认为这两个类型是兼容的。 对于 protected成员也使用这个规则:

```typescript
class Animal {
    private name: string;
    constructor(theName: string) { this.name = theName; }
}

class Rhino extends Animal {
    constructor() { super("Rhino"); }
}

class Employee {
    private name: string;
    constructor(theName: string) { this.name = theName; }
}

let animal = new Animal("Goat");
let rhino = new Rhino();
let employee = new Employee("Bob");

animal = rhino;//success,rhino的私有成员name是来自animal中定义的
animal = employee;//error,animal和employee不兼容,他们的私有成员name不来自同一处声明
```

##### protected:行为与`private`成员类似,但是可以在派生类中访问

```typescript
class Person {
    protected name: string;
    constructor(name: string) { this.name = name; }
}

class Employee extends Person {
    private department: string;

    constructor(name: string, department: string) {
        super(name)
        this.department = department;
    }

    public getElevatorPitch() {
        return `Hello, my name is ${this.name} and I work in ${this.department}.`;
    }
}

let howard = new Employee("Howard", "Sales");
console.log(howard.getElevatorPitch());
console.log(howard.name); // 错误,protected成员只能在本身和派生类中访问,无法在实例中访问
```

##### 可以将构造函数标记成`protected`成员,意味着不能直接通过这个类创造实例,但是可以先继承,再通过派生类创造实例

```typescript
class Person {
    protected name: string;
    protected constructor(theName: string) { this.name = theName; }
}

// Employee 能够继承 Person
class Employee extends Person {
    private department: string;

    constructor(name: string, department: string) {
        super(name);
        this.department = department;
    }

    public getElevatorPitch() {
        return `Hello, my name is ${this.name} and I work in ${this.department}.`;
    }
}

let howard = new Employee("Howard", "Sales");
let john = new Person("John"); // 错误: 'Person' 的构造函数是被保护的.
```

## 2020.1.6 

##### readonly修饰符:只读属性必须在声明时或构造函数内被初始化

```typescript
class Octopus {
    readonly name: string;
    readonly numberOfLegs: number = 8;
    constructor (theName: string) {
        this.name = theName;
    }
}
let dad = new Octopus("Man with the 8 strong legs");//通过构造函数初始化
dad.name = "Man with the 3-piece suit"; // 错误! name 是只读的.
```

##### 存取器:截取对对象成员的访问和设置操作

```typescript
let passcode = "secret passcode";

class Employee {
    private _fullName: string;

    get fullName(): string {
        return this._fullName;
    }

    set fullName(newName: string) {
        if (passcode && passcode == "secret passcode")
        //设置对象成员时添加验证条件
            this._fullName = newName;
        }
        else {
            console.log("Error: Unauthorized update of employee!");
        }
    }
}

let employee = new Employee();
employee.fullName = "Bob Smith";
if (employee.fullName) {
    alert(employee.fullName);
}

//*只有get没有set方法的属性被编译器自动推断成readonly
```

##### 类的静态属性:在实例上访问类的静态属性时,要通过`类名.`调用

```typescript
class Grid {
    static origin = {x: 0, y: 0};
    calculateDistanceFromOrigin(point: {x: number; y: number;}) {
        let xDist = (point.x - Grid.origin.x);
        let yDist = (point.y - Grid.origin.y);
        return Math.sqrt(xDist * xDist + yDist * yDist) / this.scale;
    }
    constructor (public scale: number) { }
}

let grid1 = new Grid(1.0);  // 1x scale
let grid2 = new Grid(5.0);  // 5x scale

console.log(grid1.calculateDistanceFromOrigin({x: 10, y: 10}));
console.log(grid2.calculateDistanceFromOrigin({x: 10, y: 10}));
```

##### 抽象类、抽象方法:使用`abstract`定义,不能直接实例化一个抽象类,抽象类中可以包含成员的实现细节,但是抽象方法方法体必须在派生类中实现

```typescript
abstract class Department {

    constructor(public name: string) {
    }

    printName(): void {
        console.log('Department name: ' + this.name);
    }

    abstract printMeeting(): void; // 必须在派生类中实现
}

class AccountingDepartment extends Department {

    constructor() {
        super('Accounting and Auditing'); // 在派生类的构造函数中必须调用 super()
    }

    printMeeting(): void {
        console.log('The Accounting Department meets each Monday at 10am.');
    }

    generateReports(): void {
        console.log('Generating accounting reports...');
    }
}

//let department: Department; 可以,允许创建一个对抽象类型的引用
//let department = new Department(); 错误: 不能创建一个抽象类的实例
//let department = new AccountingDepartment(); 可以,允许对一个抽象子类进行实例化和赋值
//department.printName(); Department name: Accounting and Auditing
//department.printMeeting(); The Accounting Department meets each Monday at 10am.
```

## 2020.1.7

### 函数

##### 为函数定义类型

```typescript
function add(x: number, y: number): number {
    return x + y;
}

let myAdd = function(x: number, y: number): number { return x + y; };

//完整的函数定义例子

let myAdd: (x: number, y: number) => number = function(x: number, y: number): number { 
    return x + y; 
};
```

##### 可选参数和默认参数

```typescript
//可选参数:在参数名旁边+？
function buildName(firstName: string, lastName?: string) {//lastName是可选参数
    if (lastName)
        return firstName + " " + lastName;
    else
        return firstName;
}
//可选参数必须跟在必须参数后面
```

```typescript
//带默认值的参数
function buildName(firstName: string, lastName = "Smith") {
    return firstName + " " + lastName;
}
//带默认值的参数无需放在最后,但是想要取到参数的默认值,在调用时需给对应位置的参数传递undefined

let result = buildName("Bob", undefined); 
```

##### 剩余参数

```typescript
//用省略号表示
function buildName(firstName: string, ...restOfName: string[]) {
  return firstName + " " + restOfName.join(" ");
}
```

##### 函数重载

```typescript
//根据不同的参数类型返回不同的结果
let suits = ["hearts", "spades", "clubs", "diamonds"];

function pickCard(x: {suit: string; card: number; }[]): number;
function pickCard(x: number): {suit: string; card: number; };
function pickCard(x): any {
    if (typeof x == "object") {
        let pickedCard = Math.floor(Math.random() * x.length);
        return pickedCard;
    }
    else if (typeof x == "number") {
        let pickedSuit = Math.floor(x / 13);
        return { suit: suits[pickedSuit], card: x % 13 };
    }
}

let myDeck = [{ suit: "diamonds", card: 2 }, { suit: "spades", card: 10 }, { suit: "hearts", card: 4 }];

let pickedCard1 = myDeck[pickCard(myDeck)];

let pickedCard2 = pickCard(15);
```

## 2020.1.8 

## 泛型

##### 泛型函数

```typescript
//使用类型变量,在函数名后边加<>
function identity<T>(arg: T): T {
    return arg;
}
//函数的返回值类型和参数类型保持一致:T
//只关心函数的返回值和参数的类型是否一致,不必关心他们具体是什么类型

//调用
//传入具体的类型
let output = identity<string>("myString");

//不传入具体类型,使用类型推论,编译器会根据传入的值自动判断函数返回值的类型
let output = identity("myString");
```

##### 泛型接口

```typescript
//将泛型函数的签名作为整个接口的一个参数
interface GenericIdentityFn {
    <T>(arg: T): T;
}

function identity<T>(arg: T): T {
    return arg;
}

let myIdentity: GenericIdentityFn = identity;
```

##### 泛型类

```typescript
//与泛型函数类似,在类名后加<>
class GenericNumber<T> {
    zeroValue: T;
    add: (x: T, y: T) => T;
}

let myGenericNumber = new GenericNumber<number>();
myGenericNumber.zeroValue = 0;
myGenericNumber.add = function(x, y) { return x + y; };
```

##### *不能创建泛型枚举和泛型命名空间

##### 泛型约束:可以定义一个接口来描述约束条件

```typescript
interface lengthWise {
    length:number
}

function loggingIdentify<T extends lengthWise>(arg:T):T{
    console.log(arg.length);
    return arg
}
//如果没有约束条件,编译器不能保证每一种类型的值都具有length属性,所以会报错
//添加了约束条件后,不再适用于所有类型

loggingIdentify(3);
//error,number类型没有Length属性
```

## 枚举:定义一些带名字的常量。ts支持数字的和基于字符串的枚举

```typescript
//数字枚举
enum Direction = {
    Up = 1,
    Down,
    Left,
    Right
}
//Up的值初始化为1,其余的成员会从1开始增长:2、3、4
//不初始化的情况下默认从0开始

//字符串枚举:没有自增长行为,所以每个成员必须初始化
enum Direction {
    Up = "UP",
    Down = "DOWN",
    Left = "LEFT",
    Right = "RIGHT",
}

//异构枚举:混合了数字枚举和字符串枚举
enum BooleanLikeHeterogeneousEnum {
    No = 0,
    Yes = "YES",
}

//反向映射:通过枚举成员的值查找枚举成员
enum Enum {
    A
}
let a = Enum.A;
let nameOfA = Enum[a]; // "A"

//外部枚举:用来描述已经存在的枚举类型的形状
declare enum Enum {
    A = 1,
    B,
    C = 2
}
//不同的一点:在正常的枚举里没有初始化的成员被当成是常数成员,在外部枚举里,没有初始化的成员被当成是需要经过计算的

```

## 2020.1.9

## 类型兼容性

##### ts中结构化类型的基本规则是:如果x要兼容y,那么y至少具有与x相同的属性

```typescript
interface Named {
    name: string;
}

let x: Named;
let y = { name: 'Alice', location: 'Seattle' };
x = y;
//success,编译器会检查在y中能否找到与x对应的属性
```

##### 比较两个函数

```typescript
//针对参数列表:是否能将x赋值给y,要看x的参数列表中的每个参数是否在y中能找到对应的,不要求参数名相同,只要求类型相同(允许忽略参数)
let x = (a: number) => 0;
let y = (b: number, s: string) => 0;

y = x; // OK
x = y; // Error

//针对返回值:与针对参数列表时相反,被赋值函数的返回值必须是赋值函数返回值的子类型(不允许忽略返回值的属性)
let x = () => ({name: 'Alice'});
let y = () => ({name: 'Alice', location: 'Seattle'});

x = y; // OK
y = x; // Error, because x() lacks a location property
```

##### 数字类型和枚举类型互相兼容,但是不同的枚举类型之间互不兼容

```typescript
enum Status { Ready, Waiting };
enum Color { Red, Blue, Green };

let status = Status.Ready;
status = Color.Green;  // Error
```

##### 比较两个类:只比较实例的成员,静态成员和构造函数不会被比较

```typescript
class Animal {
    feet: number;
    constructor(name: string, numFeet: number) { }
}

class Size {
    feet: number;
    constructor(numFeet: number) { }
}

let a: Animal;
let s: Size;

a = s;  // OK, a.feet = s.feet also OK

//类具有pravite、protected属性时,只有当两个实例包含来自同一个类的该属性时才兼容
class Animal {
    feet: number;
    private name:string;
    constructor(name: string, numFeet: number) { }
}
class Person{
    feet: number;
    private name:string;
    constructor(name: string, numFeet: number) { }
}

let a: Animal;
let b: Person;
let c: Animal;

a = b;//error
a = c;//OK
```

##### 比较泛型

```typescript
interface Empty<T> {
}
let x: Empty<number>;
let y: Empty<string>;

x = y;  // OK, because y matches structure of x

//泛型内没有属性时,相当于比较两个any类型

interface NotEmpty<T> {
    data: T;
}
let x: NotEmpty<number>;
let y: NotEmpty<string>;

x = y;  // Error, because x and y are not compatible

//泛型内有属性时,属性有了类型就不再兼容
```

## 2020.1.10

## 高级类型

##### 交叉类型:"&"

```typescript
//包含了所需的每个类型的所有成员
function extend<T, U>(first: T, second: U): T & U {
    let result = <T & U>{};
    for (let id in first) {
        (<any>result)[id] = (<any>first)[id];
    }
    for (let id in second) {
        if (!result.hasOwnProperty(id)) {
            (<any>result)[id] = (<any>second)[id];
        }
    }
    return result;
}

class Person {
    constructor(public name: string) { }
}
interface Loggable {
    log(): void;
}
class ConsoleLogger implements Loggable {
    log() {
        // ...
    }
}
var jim = extend(new Person("Jim"), new ConsoleLogger());
var n = jim.name;
jim.log();

//交叉类型jim包含了Person类的name属性和ConsoleLogger类的log()方法
```

##### 联合类型:"|"

```typescript
//包含了所需的类型中的共有成员
interface Bird {
    fly();
    layEggs();
}

interface Fish {
    swim();
    layEggs();
}

function getSmallPet(): Fish | Bird {
    // return something
}

let pet = getSmallPet();
pet.layEggs(); // okay
pet.swim();    // errors

联合类型pet只包含了Bird、Fish类所共有的layEggs()方法
```

##### 类型保护

```typescript
//用户自定义类型的保护: parameterName is Type
//定义一个函数,返回一个类型谓词
function isFish(pet: Fish | Bird): pet is Fish {
    return (<Fish>pet).swim !== undefined;
}

//调用isFish()并传入一个变量时会返回变量是否属于这个类型
if (isFish(pet)) {
    pet.swim();
}
else {
    pet.fly();
}
//*注意TypeScript不仅知道在 if分支里 pet是 Fish类型； 它还清楚在 else分支里，一定 不是 Fish类型，一定是 Bird类型


//原始类型的保护:typeof
//typeof类型保护可以不必抽成一个函数
function padLeft(value: string, padding: string | number) {
    if (typeof padding === "number") {
        return Array(padding + 1).join(" ") + value;
    }
    if (typeof padding === "string") {
        return padding + value;
    }
    throw new Error(`Expected string or number, got '${padding}'.`);
}


//instanceof类型保护:要求instanceof右侧是一个具体的构造函数
interface Padder {
    getPaddingString(): string
}

class SpaceRepeatingPadder implements Padder {
    constructor(private numSpaces: number) { }
    getPaddingString() {
        return Array(this.numSpaces + 1).join(" ");
    }
}

class StringPadder implements Padder {
    constructor(private value: string) { }
    getPaddingString() {
        return this.value;
    }
}

function getRandomPadder() {
    return Math.random() < 0.5 ?
        new SpaceRepeatingPadder(4) :
        new StringPadder("  ");
}

// 类型为SpaceRepeatingPadder | StringPadder
let padder: Padder = getRandomPadder();

if (padder instanceof SpaceRepeatingPadder) {
    padder; // 类型细化为'SpaceRepeatingPadder'
}
if (padder instanceof StringPadder) {
    padder; // 类型细化为'StringPadder'
}

```

##### --strictNullChecks标记

```typescript
//当你声明一个变量时，它不会自动地包含 null或 undefined。 你可以使用联合类型明确的包含它们
let s = "foo";
s = null; // 错误, 'null'不能赋值给'string'
let sn: string | null = "bar";
sn = null; // 可以

sn = undefined; // error, 'undefined'不能赋值给'string | null'

//对于可选参数和可选属性,会被自动添加变成 'type || undefined'
function f(x: number, y?: number) {
    return x + (y || 0);
}
f(1, 2);
f(1);
f(1, undefined);
f(1, null); // error, 'null' is not assignable to 'number | undefined'

class C {
    a: number;
    b?: number;
}
let c = new C();
c.a = 12;
c.a = undefined; // error, 'undefined' is not assignable to 'number'
c.b = 13;
c.b = undefined; // ok
c.b = null; // error, 'null' is not assignable to 'number | undefined'

//由于值可以是null的类型使用了联合类型,在需要去除null类型时,如果编译器不能够去除null或undefined,可以再标识符后加!手动使用类型断言去除
function foo(s:number | null){
    console.log(s.toString());//error,s有可能是null
}

function foo(s:number | null){
    console.log(s!.toString());//ok,手动去除了null和undefined
}
```

## 2020.1.13

##### 类型别名:给类型起一个新名字。并不会创建一个新类型,只是创建了一个新名字来引用该类型

```typescript
type Name = string;
type NameResolver = () => string;
type NameOrResolver = Name | NameResolver;
function getName(n: NameOrResolver): Name {
    if (typeof n === 'string') {
        return n;
    }
    else {
        return n();
    }
}
```

##### 字符串字面量类型:可以指定允许的值

```typescript
//字符串字面量类型与类型别名结合
type Easing = "ease-in" | "ease-out" | "ease-in-out";

class UIElement {
    animate(dx: number, dy: number, easing: Easing) {
        if (easing === "ease-in") {
            // ...
        }
        else if (easing === "ease-out") {
        }
        else if (easing === "ease-in-out") {
        }
        else {
            // error! should not pass null or undefined.
        }
    }
}

let button = new UIElement();
button.animate(0, 0, "ease-in");
button.animate(0, 0, "uneasy"); // error: "uneasy" is not allowed here
```

##### 数字字面量类型

```typescript
function rollDie(): 1 | 2 | 3 | 4 | 5 | 6 {
    // ...
}
```

##### 可辨识联合:将单例类型、联合类型、类型保护和类型别名合并

```typescript
interface Square {
    kind: "square";
    size: number;
}
interface Rectangle {
    kind: "rectangle";
    width: number;
    height: number;
}
interface Circle {
    kind: "circle";
    radius: number;
}

type Shape = Square | Rectangle | Circle;

function area(s: Shape) {
    switch (s.kind) {
        case "square": return s.size * s.size;
        case "rectangle": return s.height * s.width;
        case "circle": return Math.PI * s.radius ** 2;
    }
}
```

##### 多态的this类型

```typescript
class BasicCalculator {
    public constructor(protected value: number = 0) { }
    public currentValue(): number {
        return this.value;
    }
    public add(operand: number): this {
        this.value += operand;
        return this;
    }
    public multiply(operand: number): this {
        this.value *= operand;
        return this;
    }
    // ... other operations go here ...
}

//每个方法都返回this,实现连续调用

let v = new BasicCalculator(2)
            .multiply(5)
            .add(1)
            .currentValue();
```

##### keyof操作符:对于任意类型T,keyof T返回T上已知的公共属性名的联合

```typescript
interface Person {
    name: string;
    age: number;
}

let personProps: keyof Person; // 'name' | 'age'
```

##### T[K]索引访问操作符:编译器会实时返回对应的真实类型

```typescript
//getProperty里的 o: T和 name: K，意味着 o[name]: T[K]。 当你返回 T[K]的结果，编译器会实例化键的真实类型，因此 getProperty的返回值类型会随着你需要的属性改变。
let name: string = getProperty(person, 'name');
let age: number = getProperty(person, 'age');
let unknown = getProperty(person, 'unknown'); // error, 'unknown' is not in 'name' | 'age'
```

##### 映射类型:从旧类型中创建新类型

```typescript
type Readonly<T> = {
    readonly [P in keyof T]: T[P];
}
//将类型T中的所有属性变为只读

type Partial<T> = {
    [P in keyof T]?: T[P];
}
//将类型T中的所有属性变为可选
```

##### Symbols

```typescript
//一些众所周知的内置symbols

//Symbl.hasInstance
//构造器对象用来识别一个对象是否是其实例

let array:number[] = [];

array instanceof Array; //true
Array[Symbol.hasInstance](array); //true

//Symbol.isConcatSpreadable
//布尔值，表示当在一个对象上调用Array.prototype.concat时，这个对象的数组元素是否可展开

let x:number[] = [1];
let y:number[] = [2];
let boo = x.concat(y);//[1,2]

let x:number[] = [1];
let y:number[] = [2];
x[Symbol.isConcatSpreadable] = false;
let boo = x.concat(y); //[[1],2],x不能被展开

//Symbol.iterator
//返回对象的默认迭代器

let x:number[] = [1,2,3];
x[Symbol.iterator]//ƒ values() { [native code] }

//Symbol.match
//正则表达式用来匹配字符串

const regexp1 = /foo/;

console.log('/foo/'.startsWith(regexp1));//error,第一个参数不应是个正则表达式

regexp1[Symbol.match] = false;

console.log('/foo/'.startsWith(regexp1));
// ok,true

console.log('/baz/'.endsWith(regexp1));
// ok,false

//Symbol.replace
//指向一个方法，当对象被String.prototype.replace方法调用时，会返回该方法的返回值

const x = {};
x[Symbol.replace] = (...s) => console.log(s);
'Hello'.replace(x, 'World') // ["Hello", "World"]

//Symbol.search
//接受一个正则表达式,返回该正则表达式在字符串中匹配到的下标

class MySearch {
  constructor(value) {
    this.value = value;
  }
  [Symbol.search](string) {
    return string.indexOf(this.value);
  }
}
'foobar'.search(new MySearch('foo')) // 0

//Symbol.split
//用法与Symbol.search类似,在被String.prototype.split调用时返回该方法的返回值

//

//Symbol.species
//指向一个构造函数。创建衍生对象时，会使用该属性

class MyArray extends Array {
}

const a = new MyArray(1, 2, 3);
const b = a.map(x => x);
const c = a.filter(x => x > 1);

b instanceof MyArray // true
c instanceof MyArray // true

//b和c不仅是Array的实例,实际上也是myArray的衍生对象
//Symbol.species就是为了解决这个问题而提供的

//默认的Symbol.species属性
static get [Symbol.species]() {
  return this;
}

//修改后的Symbol.species属性
class MyArray extends Array {
  static get [Symbol.species]() { return Array; }
}

const a = new MyArray();
const b = a.map(x => x);

b instanceof MyArray // false
b instanceof Array // true

//b就不再是a的衍生对象了

//Symbol.toPrimitive
//指向一个方法,在该对象被转为原始类型的值时调用
//转换有3种模式:
//1.转换成数值  'number'
//2.转换成字符串  'string'
//3.可以是数值也可以是字符串  'default'

let obj = {
  [Symbol.toPrimitive](hint) {
    switch (hint) {
      case 'number':
        return 123;
      case 'string':
        return 'str';
      case 'default':
        return 'default';
      default:
        throw new Error();
     }
   }
};

2 * obj // 246
3 + obj // '3default'
obj == 'default' // true
String(obj) // 'str'

//Symbol.toStringTag
//指向一个方法,在该对象上调用Object.prototype.toString方法时,如果这个属性存在,它的返回值会出现在toString方法返回的字符串中
//可以用来定制[object Object]或[object Array]等object后面那个字符串的值

class Collection {
  get [Symbol.toStringTag]() {
    return 'xxx';
  }
}
let x = new Collection();
Object.prototype.toString.call(x) // "[object xxx]"
```

## 2020.02.26

##### 迭代器和生成器

```typescript
//for..of和for..in的区别:for..of迭代对象的值,for..in迭代对象的键

let list = [4, 5, 6];

for (let i in list) {
    console.log(i); // "0", "1", "2",
}

for (let i of list) {
    console.log(i); // "4", "5", "6"
}

//另一个区别是for..in可以操作任何对象,它提供了一种查看对象属性的方法。

let pets = new Set(["Cat", "Dog", "Hamster"]);
pets["species"] = "mammals";

for (let pet in pets) {
    console.log(pet); // "species"
}

for (let pet of pets) {
    console.log(pet); // "Cat", "Dog", "Hamster"
}
```

## 2020.02.27

##### export和import

语法与js类似,但在使用`export = `导出模块时,也必须使用`import = `来导入。

## 面试整理

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
F.a ==> F.__proto__.a ==> Function.prototype.a ==> Function.prototype.__proto__.a(*此时把Function.prototype视作一个普通对象) ==> Object.prototype.a // 'value a'
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

## TCP协议相关
---

UDP协议(User Datagram Protocol):用户数据报协议。不需要在传输数据之前连接双方,具有不可靠性。但比较轻便高效。

TCP协议(Transmission Control Protocol):传输控制协议。建立连接和断开连接都要进行握手,具有可靠性。

#### 三次握手:三次的意义是双方都能确定拥有发送和接收能力的最小次数
---

1.客户端发送SYN包(SYN同步序列编号,是建立连接时使用的握手信号)到服务器,等待服务器响应。

2.服务器收到SYN包,使用ACK包(确认字符)进行应答,同时也发出一个SYN包。

3.客户端收到SYN包,向服务器发送ACK包确认,此时TCP连接完成。

#### 四次挥手:
---

1.客户端发送断开连接请求,并停止发送数据。

2.服务器收到请求后发出ACK包表示确认,若此时服务器端如有未发送完成的数据,仍要继续发送。

3.服务器数据发送完毕,向客户端发送断开连接请求。

4.客户端收到请求后,进入TIME_WAIT状态,持续2MSL,这段时间内如果没有收到服务器发送的请求,就进入关闭状态。而服务器端接收到ACK包后,立即进入关闭状态。

#### HTTP发展历程
---

HTTP/0.9:没有HEADER,只规定了客户端和服务端的通信形式,只支持GET请求

HTTP/1.0:正式作为标准,传输内容格式不限制,增加了PUT、PATCH、HEAD、OPTIONS、DELETE命令

HTTP/1.1:增加了持久连接(Keep-Alive)和管道机制

HTTP/2:增加了多路复用,服务端推送,头部压缩,二进制帧数据传输等

##### keep-alive
---

在HTTP/1.1之前,每次发请求都需要重新建立TCP连接,资源十分浪费。keep-alive允许在一定时间内,同一个域名多次请求数据,只建立一次HTTP连接,其他请求可以复用这个链接通道。

##### 管道机制
---

在管道机制出现之前,每个请求都要在接收到上一个请求的响应后才能发出,而服务器在处理完第一个请求到接收到第二个请求之中的这段时间里是处于闲置的。于是,管到机制出现了,它允许浏览器将多个请求打包发送给服务器,这样服务器在处理完一个请求后可以马上开始处理下一个,但响应的接收顺序必须和请求的发出顺序一致,这样的情况下服务端为了保证按顺序回传,通常需要缓存多个响应,占用服务端资源。另外当服务端收到多个管道请求后,需要按照接收顺序逐个响应,如果第一个请求处理的特别慢,那么后续的请求都会被阻塞,这种情况称为"队首阻塞"。

##### HTTP/2头部压缩
---

HTTP请求都是由状态行、请求/响应头、消息主体三部分组成,一般而言,消息主体都会经过gzip压缩,或者本身就是压缩后的二进制文件,其体积并不大,而状态行和头部却没有经过任何压缩,直接以文本传输,有时体积甚至比消息主体还大,所以对头部进行HPACK算法压缩,减小体积。

##### HTTP/2 server push
---

支持服务端推送,意味着服务端可以发送页面HTML时主动推送其他资源,而不必等待浏览器发送请求后再去响应。

## HTTPS相关

##### HTTPS的优点
---

1. 不使用明文传输,比较安全。
2. 会通过数字证书来验证身份。
3. 可以保证数据的完整性,防止传输内容被中间人冒充或篡改。
4. HTTP常用端口是80,HTTPS常用端口是443

##### 为什么HTTPS在数据传输过程中使用对称加密?而在传输共享秘钥时使用非对称加密?
---

因为非对称加密的加解密效率非常低,在实际场景中端与端之间的交互量非常大,对非对称加密的效率是无法忍受的。而且只有服务器端保存了私钥,无法构成双向的非对称加解密过程。

##### HTTPS中间人攻击
---

中间人攻击即:假设不存在认证机构,人人都可以伪造证书,那么中间人可以先伪装成服务端和客户端通信,又伪装成客户端和服务端通信,虽然使用了HTTPS,但是缺少证书的验证过程,数据安全依然无法得到保障。

##### 回流与重绘
---

文档中的元素因为几何属性(大小、位置等)改变而影响现有文档布局的时候，浏览器会使这些受影响的元素暂时失效，并重新计算他们的大小、位置等属性，并显示在页面中，这称为回流(重新渲染在页面的过程就是重绘)。

### restful API风格约束
---

1. uri规范
使用名词,如:
```
http://api.example.com/class-management/students
http://api.example.com/device-management/managed-devices/{device-id}
http://api.example.com/user-management/users/
http://api.example.com/user-management/users/{id}
```

2. http method对应不同的请求动作
`GET`:查询
`POST`:新增
`PUT`:更新(全部)
`PATCH`:更新(部分)
`DELETE`:删除

3. 使用连字符(-)而不是下划线(_)来提高uri的可读性
```
http://api.example.com/inventory-management/managed-entities/{id}/install-script-location //更易读
http://api.example.com/inventory_management/managed_entities/{id}/install_script_location //更容易出错
```

4. 在uri中使用小写字母

5. 不使用文件扩展名
```
http://api.example.com/device-management/managed-devices.xml / 不要使用它 /
http://api.example.com/device-management/managed-devices / *这是正确的URI * /
```

6. 使用查询组件过滤uri集合
```
http://api.example.com/device-management/managed-devices
http://api.example.com/device-management/managed-devices?region=USA
http://api.example.com/device-management/managed-devices?region=USA&brand=XYZ
http://api.example.com/device-management/managed-devices?region=USA&brand=XYZ&sort=installation-date
```

7. 不要在末未使用`/`

8. 使用http状态码定义api执行结果
`2xx`:成功
`3xx`:重定向相关
`4xx`:客户端错误
`5xx`:服务端错误

9. 版本定义
uri版本控制:
```
http://api.example.com/v1
http://apiv1.example.com
```

使用自定义请求标头进行版本控制
```
Accept-version：v1
Accept-version：v2
```
使用Accept header进行版本控制:
```
Accept:application / vnd.example.v1 + json
Accept:application / vnd.example + json; version = 1.0
```

10. 尽量将api部署在专用域名下
```
https://api.example.com
//除非确定api很简单,不会有进一步扩展,则可以放在主域名下
https://example.org/api/
```

### Promise API
---

1. promise.finally:无论promise的状态如何改变,finally中的回调函数总是会执行

2. promise.all:将多个promise封装成一个新的promise实例。

只有当所有promise的状态都变为fulfilled,新实例的状态才变为fulfilled,所有promise的返回值组成一个数组传递给新实例的回调函数。

若有一个promise的状态变为rejected,新实例的状态就变为rejected,此时第一个状态变为rejected的promise的返回值会被传递给新实例的回调函数。

3. promise.race:用法同promise.all一样,不同的是只要有一个promise的状态改变了,新实例的状态都会随之改变(不论fulfilled或rejected)


## Vue相关

### vue有哪些生命周期

`beforeCreate`:创建vue实例,data,$el等还未创建

`created`:实例的data可以访问,$el还未挂载

`created`和`beforeMount`之间的阶段:

1. 判断是否有`el`选项:
  + 有,继续向下编译
  + 无,停止编译,停止生命周期
2. 判断是否有`template`选项:
  + 有,将`template`作为模板编译成render函数
  + 无,将外部的HTML作为模板编译
  + (template中模板的优先级要高于外部HTML,如果同时存在render函数、template选项、外部HTML,则render函数的优先级最高,见下面代码)

```HTML
<body>
    <div id="app">
        <h1>这里是外部HTML</h1>
    </div>
</body>
<script>
var app = new Vue({
    el:'#app',
    template:'<h1>这里是template选项</h1>',
    render:function(createElement){
        return createElement('h1','这里是render函数')
    }
})
</script>

//此时#app里显示<h1>这里是render函数</h1>
```
`beforeMount`:$el还未挂载

`mounted`:$el已挂载

`beforeUpdate`:data发生改变,页面还未渲染

`updated`:data发生改变,且页面渲染完成

`beforeDestroy`:在实例将要销毁时调用,此时还未销毁,实例仍然可用

`destroyed`:实例销毁后调用,解绑所有子组件、事件监听器、watchers,此时修改实例已不能触发页面的渲染

---

### vue-router有哪些导航钩子

1. 全局导航钩子:
  + `router.beforeEach(to,from,next)`:全局前置守卫,每个导航被触发时都会调用
  + `router.beforeResolve(to,from,next)`:与`router.beforeEach`类似,但是稍晚些触发(在目标路由的`beforeRouterEnter`之后调用)
  + `afterEach(to,from)`:全局后置钩子,每个导航被触发后都会调用,不接收next函数,所以不会改变导航本身
2. 组件内钩子:
  + `beforeRouterEnter`:进入路由前调用,不能访问`this`,因为实例还没被创建,可以通过next(vm => {})回调来访问该实例
  + `beforeRouterUpdate`:在改变路由,并复用当前组件时调用,可以访问`this`
  + `beforeRouterLeave`:离开该组件的路由时调用,可以访问`this`
3. 路由独享的钩子:
  + `beforeEnter`:某个路由独享的守卫,参数与全局前置守卫一致

#### 钩子触发顺序(a -> b):
1. a路由的`beforeLeave`
2. 全局前置守卫`router.beforeEach`
3. b的独享守卫`beforeEnter`
4. b的`beforeRouteEnter`
5. 全局解析守卫`router.beforeResolve`
6. 全局后置守卫`router.afterEach`

---

### vue数据双向绑定的原理

核心原理是使用`Object.defineProperty()`劫持数据,并添加访问器属性,使data变成可监测对象。

`view层`=>`model层`的改变,由于是简单的一对一关系,通过事件监听即可实现;而`model层`=>`view层`的改变,可能涉及到一对多的情况,则使用了`订阅/发布模式`,在编译模板时,为所有使用了数据的模板元素创建一个`watcher`实例,并将该`watcher`添加到对应的`data`属性的订阅列表中,当某个`data`属性发生改变时,通知到对应的`watcher`实例,再由`watcher`实例对具体的模板元素进行更新。

`Object`类型与`Array`类型的的数据在实现上略有不同,在收集依赖时都是通过`getter`,而在值改变通知`watcher`时,`Array`类型则是对原生的数组操作进行了封装,在调用原生方法的同时添加了手动通知`watcher`的功能。

---

### vue生命周期

大致分为四个阶段:
1. 初始化阶段:为vue实例初始化一些属性、事件以及响应式数据。
2. 模板编译阶段:将模板编译成渲染函数。
3. 挂载阶段:将实例挂载到指定的DOM上,即将模板渲染到真实DOM中。
4. 销毁阶段:将实例自身从父组件中删除,并取消依赖追踪及事件监听器。

##### 初始化阶段

new了一个Vue,主要逻辑为:合并逻辑,将用户传入的配置与类本身的默认配置进行合并;调用一些初始化函数(initLifecycle,initEvents,initRender,initInjection,initState,initProvide);触发生命周期钩子函数(beforeCreate,created);最后调用$mount开启下一个阶段

---

### vue模板编译过程:

将用户写的模板解析生成抽象语法树(AST) => 遍历AST,找出其中的静态节点并打上标记(产生VNode并为VNode的视图更新过程提供优化) => 将AST生成render函数

---

#### 模板解析过程主要有3个解析器:

1. HTML解析器:主要解析器
2. 文本解析器:负责解析文本内容
3. 过滤器解析器:负责解析文本中包含的过滤器

---

### vue:keep-alive组件

组件本身并不会渲染出任何东西，作用是缓存失活的组件，并在再次激活的时候保留失活前的状态。缓存方式是保存在VNode(虚拟DOM)中。

---

### vue.$nextTick()属于宏任务还是微任务？

在vue的运行环境支持Promise时，$nextTick()会优先使用Promise。否则会被定义为宏任务。