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