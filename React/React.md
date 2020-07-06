> 本文档为 vue 转 react 的入坑笔记，着重记录两者的异同

### JSX 语法

在 jsx 中嵌入表达式

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

jsx 也是一个表达式，可以在`if/else`代码块中使用，可以将 jsx 赋值给变量，把 jsx 当做参数传给函数，以及从函数中返回 jsx

```js
function getGreeting(user) {
  if (user) {
    return <h1>Hello,{formatName(user)}</h1>;
  } else {
    return <h1>Hello,Stranger</h1>;
  }
}
```

jsx 特定属性

```js
//使用引号将属性值指定为字符串字面量
const element = <div tabIndex="0"></div>;

//使用大括号嵌入js表达式
const element = <img src={user.avatarUrl}></img>;

//###注意，不能同时使用引号和大括号
```

使用 jsx 指定子元素

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

React 元素是不可变对象，一旦被创建，你就无法改变它的子元素或者属性。

根据我们已有的知识，更新 UI 的唯一方式是创建一个全新的元素，并将其传入`ReactDOM.render()`

```js
//一个计时器的例子
function tick() {
  const element = (
    <div>
      <h1>Hello, world!</h1>
      <h2>It is {new Date().toLocaleTimeString()}.</h2>
    </div>
  );
  ReactDOM.render(element, document.getElementById("root"));
}

setInterval(tick, 1000);
```

在实践中，大多数 React 应用只会调用一次 ReactDOM.render()，我们通常将这些代码封装到有状态组件中实现这种功能。

---

### 组件&props

函数组件：

```js
function Welcome(props){
  return <h1><Hello,{this.props.name}/hi>
}
```

class 组件：

```js
class Welcome extends React.Component {
  render() {
    return <h1>Hello,{this.props.name}</h1>;
  }
}
```

props 的只读性：

```js
//纯函数：不会更改入参，多次调用相同的入参始终返回相同的结果
function sum(a, b) {
  return a + b;
}

//非纯函数：修改了入参
function withdrad(account, amount) {
  account.total += amount;
}
```

---

### State&声明周期

```js
componentDidMount(); //组件已经被渲染到DOM中后执行

componentWillUnmount(); //组件将要被删除的时候执行
```

不要直接修改 State，应该使用`setState()`

```js
this.state.comment = "Hello"; //won't work

this.setState({ comment: "Hello" }); //work

//构造函数是唯一可以给this.state赋值的地方
```

state 的更新可能是异步的，因为 React 可能会把多个`setState()`合并成一个

```js
//sometimes this won't work
this.setState({
  counter: this.state.counter + this.props.increment,
});

//always work
this.setState((state, props) => ({
  counter: state.counter + props.increment,
}));
```

state 是单向数据流，该 state 中的数据只能影响低于它的组件

```js
//把state作为props传递到它的子组件
<h2>It is {this.state.toLocalTimestring()}.</h2>
//同样适用于自定义组件
<FormattedData date={this.state.date} />
```

### 事件处理

jsx 与传统 HTML 语法上的差异

```js
//传统HTML
<button onclick="handler()"></button>

//jsx，小驼峰命名
<button onClick={handler}></button>

//另外不能通过return false来阻止默认行为，必须显式调用preventDefault()
```

class 组件中默认不会绑定`this`，绑定`this`的方法有如下几种：

```js
//一、在constructor中为方法绑定
class Toggle extends React.component {
  constructor(props){
    super(props)
    this.state = {isToggleOn:true}
    this.handleClick = this.handleClick.bind(this)
  }
  handleClick(){
    ...
  }
  render(){
    ...
  }
}

//二、实验性的public class fileds语法
class Toggle extends React.component {
  constructor(props){
    ...
  }
  handleClick = () => {
    //'this' key is work here
  }
}

//三、绑定时使用回调函数
class Toggle extends React.component{
  constructor(props){
    ...
  }
  handleClick(){
    //'this' key is work here
  }
  render(){
    return (
      <button onClick={() => this.handlerClick()}>click me</button>
    )
  }
}
```

向事件处理程序传递参数

```js
//箭头函数方式
<button onClick={(e) => this.handler(id,e)}>click me</button>

//bind方式
<button onClick={this.handler.bind(this,id)}>click me</button>
```

### 条件渲染

使用`if/else`：

```js
function greeting(props) {
  const isLogin = props.isLogin;
  if (isLogin) {
    return <UserGreeting />;
  }
  return <GuestGreeting />;
}
```

与运算符`&&`：

```js
//在js中，true && expression 总是返回 expression，false && expression总是返回false
function MailBox(props) {
  const messages = props.messages;
  return (
    <div>
      <h1>Hello!</h1>
      {messages.length && (
        <h1>You Have {this.props.messages.length} unread messages</h2>
      )}
    </div>
  );
}
```

三目运算符：

```js
render(){
  const isLogin = this.state.isLogin;
  return (
    <div>
      {
        isLogin ? <LogoutButton /> : <LoginButton />
      }
    </div>
  )
}
```

阻止条件渲染：

```js
//在组件的render函数中return null
function WarningBanner(props) {
  if (!props.warn) {
    return null;
  }

  return (
    //won't reach here
    <div className="warning">Warning!</div>
  );
}
//* 在组建的render方法中返回null并不会影响组件的生命周期。
//* 上例中组件的componentsDidUpdate依然会被调用
```

### 列表 & Key

可以使用 map()将数组映射为一个组件数组：

```js
function NumberList(props) {
  const numbers = props.numbers;
  const listItems = numbers.map((item) => {
    <li key={item.toString()}>{item}</li>;
  });
  return <ul>{listItem}</ul>;
}

const numbers = [1, 2, 3, 4, 5, 6];

ReactDOM.render(
  <NumberList numbers={numbers} />,
  document.getElementById("root")
);
//大部分情况下，key值设置在map()方法中的元素上
```

### 表单

受控组件：

```js
//由于在表单元素上设置了value属性，因此显示的值始终为this.state.value，这使得state成为唯一数据源
//对于受控组件来说，输入的值始终由React的state驱动
class NameForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = { value: "" };
  }

  handleChange(event) {
    this.setState({ value: event.target.vale });
  }

  handleSubmit(event) {
    alert("name is:" + this.state.value);
    event.preventDefault();
  }

  render() {
    return (
      <form onSubmit={() => this.handleSubmit()}>
        <label>
          名字：
          <input
            type="text"
            value={this.state.value}
            onChange={() => this.handleChange()}
          />
        </label>
        <input type="submit" value="提交" />
      </form>
    );
  }
}
```

### 组合

```js
function SplitPane(props) {
  return (
    <div className="SplitPane">
      <div className="SplitPane-left">{props.left}</div>
      <div className="SplitPane-right">{props.right}</div>
    </div>
  );
}

function App(props) {
  return <SplitPane left={<Contacts />} right={<Chat />} />;
}

//类似slot的概念，但是React没有slot的限制，任何东西都可以通过props传递
```

### Hook

在不编写 class 的情况下使用 state 以及其他的 React 特性

```javascript
import React, { useState } from "react";
function Example() {
  //声明一个叫count的state变量,初始值为0
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}></button>
    </div>
  );
}
```
#### useState

1. 调用`useState`的时候做了什么？

定义了一个`state`变量(`count`)，与`class`里的`this.state`提供完全相同的功能。

2. `useState`需要哪些参数?

唯一的参数是`state`的初始值。可以是数字、字符串、对象等。如果想要存储多个不同的变量，也可多次调用`useState`。

3. `useState`的返回值是什么?

返回值为：当前`state`和更新`state`的函数（也就是为什么使用数组解构赋值写法的原因）。在上面的例子中与`this.state.count`和`this.setState`类似。

#### useEffect

相当于`componentDidMount`和`componentDidUpdate`。可以多次调用，并可以通过返回一个函数来指定如何“清除”操作。

```javascript
import React, { useState, useEffect } from "react";

function FriendStatus(props) {
  const [isOnline, setIsOnline] = useState(null);

  function handleStatusChange(status) {
    setIsOnline(status.isOnline);
  }

  useEffect(() => {
    ChatAPI.subscribeToFriendStatus(props.friend.id, handleStatusChange);
    return () => {
      ChatAPI.unsubscribeFromFriendStatus(props.friend.id, handleStatusChange);
    };
  });

  if (isOnline === null) {
    return "Loading...";
  }
  return isOnline ? "Online" : "Offline";
}
```

1. `useEffect`做了什么？

React会保存传递的函数，并且在执行DOM更新之后执行它。

2. 为什么在组件内部调用`useEffect`

可以在`effect`中直接访问`state`变量（`Hook`使用了js的闭包机制），而不需要提供特定的API。

3. `useEffect`会在每次渲染后都执行吗？

是的，在第一次渲染和之后的每次更新都会执行。

4. 如何跳过部分不必要的`useEffect`?

在某些情况下，组件每次渲染后都清理或者执行`effect`会带来不必要的性能开销。可以通过传递一个数组作为`useEffect`的第二个参数，数组中的值为`state`变量，当组件进行重新渲染的时候，`React`会判断数组中的各个`state`值是否改变，当且仅当所有的`state`都没有发生改变时，跳过此次`effect`。另外，可以通过传递一个空数组`[]`的方式，创建永远都不重复执行（只在初始化的时候执行一次）的`effect`。

```javascript
//...省略额外代码
useEffect(() => {
  document.title = `you clicked ${count} times`
},[count])//仅在count更新时才会更新
```

#### Hook的限制条件

1. 只在最顶层使用Hook

不要在循环、条件或者嵌套函数中调用Hook。

2. 只在`React`函数中调用Hook

不要再普通的js函数中调用Hook