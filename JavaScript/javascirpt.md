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