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

```
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
```
绘制矩形
fillRect()    //实心矩形
strokeRect()  //描边矩形


绘制路径
beginPath()   //开始绘制路径
arc()   //以给定坐标为圆心绘制弧线
arcTo() //从上一点开始绘制一条弧线到下一点
bezierCurveTo() //从上一点开始绘制贝塞尔曲线
lineTo()    //从上一点开始绘制直线
moveTo()    //将绘图游标移动到给定坐标，不画线
quadraticCurveTo()  //从上一点开始绘制二次曲线
rect()  //从给定坐标开始绘制矩形路径，不同于fillRect()和strokeRect()绘制的独立形状

绘制文字

```