本文档为 vue 转 react 的入坑笔记，着重记录两者的异同

### JSX 语法
在jsx中嵌入表达式
```js
/**
 * 在jsx中可以在大括号内放置任意有效的javascript表达式，例如：
 * 2 + 2
 * user.firstName
 * formateName(user)
 */
function formatName(user) {
  return user.firstName + " " + user.lastName;
}

const user = {
  firstName: "Harper",
  lastName: "Perez",
};

const element = <h1>Hello, {formatName(user)}!</h1>;
```

jsx也是一个表达式，可以在`if/else`代码块中使用，可以将jsx赋值给变量，把jsx当做参数传给函数，以及从函数中返回jsx
```js
function getGreeting(user){
    if(user){
        return <h1>Hello,{formatName(user)}</h1>
    }else{
        return <h1>Hello,Stranger</h1>
    }
}
```

jsx特定属性
```js
//使用引号将属性值指定为字符串字面量
const element = <div tabIndex="0"></div>;

//使用大括号嵌入js表达式
const element = <img src={user.avatarUrl}></img>;

//###注意，不能同时使用引号和大括号
```

使用jsx指定子元素
```js
//自闭和标签
const element = <img src={user.avatarUrl} />;

//标签里包含子元素
const element = (
  <div>
    <h1>Hello!</h1>
    <h2>Good to see you here.</h2>
  </div>
);
```

---

### 元素渲染

React元素是不可变对象，一旦被创建，你就无法改变它的子元素或者属性。

根据我们已有的知识，更新UI的唯一方式是创建一个全新的元素，并将其传入`ReactDOM.render()`

```js
//一个计时器的例子
function tick() {
  const element = (
    <div>
      <h1>Hello, world!</h1>
      <h2>It is {new Date().toLocaleTimeString()}.</h2>
    </div>
  );
  ReactDOM.render(element, document.getElementById('root'));
}

setInterval(tick, 1000);
```

在实践中，大多数 React 应用只会调用一次 ReactDOM.render()，我们通常将这些代码封装到有状态组件中实现这种功能。