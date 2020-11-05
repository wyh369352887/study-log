# createApp() mount()

## 从源码分析 crateApp()和mount()做了什么

#### 主入口

```typescript
// packages/vue/src/index.ts
export * from "@vue/runtime-dom";
```

```typescript
// packages/runtime-dom/src/index.ts

export const createApp = ((...args) => {
  const app = ensureRenderer().createApp(...args);

  // 省略
}) as CreateAppFunction<Element>;
```

```typescript
function ensureRenderer() {
  return (
    //首次启动、注册根实例时会创建一个新的renderer
    renderer || (renderer = createRenderer<Node, Element>(rendererOptions))
  );
}
```

```typescript
// packages/runtime-core/src/renderer.ts

export function createRenderer<
  HostNode = RendererNode,
  HostElement = RendererElement
>(options: RendererOptions<HostNode, HostElement>) {
  return baseCreateRenderer<HostNode, HostElement>(options);
}
```

#### `baseCreateRenderer`方法非常的长，有 1800+行，进行了大量的函数声明，这里对函数体进行了省略。

#### 函数名起的非常语义化，可以清晰得知`baseCreateRenderer`主要是声明了一些`模板编译`和`patch算法`相关的函数。

```typescript
function baseCreateRenderer(
  options: RendererOptions,
  createHydrationFns?: typeof createHydrationFunctions
): any {
  const patch = () => {};
  const processText = () => {};
  const processCommentNode = () => {};
  const mountStaticNode = () => {};

  /**
   * Dev / HMR only
   */
  const patchStaticNode = () => {};
  const moveStaticNode = () => {};
  const removeStaticNode = () => {};

  const processElement = () => {};
  const mountElement = () => {};
  const setScopeId = () => {};
  const mountChildren = () => {};
  const patchElement = () => {};
  const patchBlockChildren = () => {};
  const patchProps = () => {};
  const processFragment = () => {};
  const processComponent = () => {};
  const mountComponent = () => {};
  const updateComponent = () => {};
  const setupRenderEffect = () => {};
  const updateComponentPreRender = () => {};
  const patchChildren = () => {};
  const patchUnkeyedChildren = () => {};
  const patchKeyedChildren = () => {};
  const move = () => {};
  const unmount = () => {};
  const remove = () => {};
  const removeFragment = () => {};
  const unmountComponent = () => {};
  const unmountChildren = () => {};
  const getNextHostNode = () => {};
  const render = () => {};
  const internals = {};
  let hydrate = {};
  let hydrateNode = {};

  return {
    render,
    hydrate,
    createApp: createAppAPI(render, hydrate),
  };
}
```

#### 这里`createApp`方法是调用`createAppAPI`返回的。

```typescript
// packages/runtime-core/src/apiCreateApp.ts

export function createAppAPI<HostElement>(
  render: RootRenderFunction,
  hydrate?: RootHydrateFunction
): CreateAppFunction<HostElement> {
  return function createApp(rootComponent, rootProps = null) {
    // 接收两个参数，第一个是根实例的配置对象，第二个是props

    if (rootProps != null && !isObject(rootProps)) {
      // 校验props类型
      __DEV__ && warn(`root props passed to app.mount() must be an object.`);
      rootProps = null;
    }

    /**
     * createAppContext()创建App上下文，返回一个具有
     * app、config、mixins、components、directives、provides属性的对象
     */
    const context = createAppContext();

    // set记录已安装的插件
    const installedPlugins = new Set();

    let isMounted = false;

    /**
     * 给context.app初始化一个对象，并赋值给一个新的变量app
     */
    const app: App = (context.app = {
      _uid: uid++,
      _component: rootComponent as ConcreteComponent,
      _props: rootProps,
      _container: null,
      _context: context,

      version,

      get config() {},

      set config(v) {},

      use() {},

      mixin() {},

      component() {},

      directive() {},

      mount() {},

      unmount() {},

      provide(key, value) {},
    });

    return app;
  };
}
```

#### 再回到`cerateApp()`

```typescript
// packages/runtime-dom/src/index.ts

export const createApp = ((...args) => {
  const app = ensureRenderer().createApp(...args);

  /**
   * 给app.config添加isNativeTag属性，用于开发环境的组件名称校验
   */
  if (__DEV__) {
    injectNativeTagCheck(app);
  }

  /**
   * 保存app.mount方法，将原来的重写
   */
  const { mount } = app;
  app.mount = () => {};

  return app;
}) as CreateAppFunction<Element>;
```

#### 创建 app 时的`mount()`方法做了什么？

```typescript
const app = {
  mount(rootContainer: HostElement, isHydrate?: boolean): any {
    // isMounted初始化为false
    if (!isMounted) {
      // 创建VNode
      const vnode = createVNode(rootComponent as ConcreteComponent, rootProps);

      // 初始化挂载时将app的上下文环境存储在vnode根节点上
      vnode.appContext = context;

      // 开发环境添加reload方法提升效率
      if (__DEV__) {
        context.reload = () => {
          render(cloneVNode(vnode), rootContainer);
        };
      }

      // 根据不同的运行环境执行不同的渲染VNode流程
      if (isHydrate && hydrate) {
        hydrate(vnode as VNode<Node, Element>, rootContainer as any);
      } else {
        render(vnode, rootContainer);
      }
      isMounted = true;
      app._container = rootContainer;

      // for devtools and telemetry
      (rootContainer as any).__vue_app__ = app;

      if (__DEV__ || __FEATURE_PROD_DEVTOOLS__) {
        devtoolsInitApp(app, version);
      }

      // 返回根组件实例的一个代理
      return vnode.component!.proxy;
    } else if (__DEV__) {
      warn(
        `App has already been mounted.\n` +
          `If you want to remount the same app, move your app creation logic ` +
          `into a factory function and create fresh app instances for each ` +
          `mount - e.g. \`const createMyApp = () => createApp(App)\``
      );
    }
  },
};
```

#### 重写了的`mount()`方法又做了什么？

```typescript
// 将原来的mount方法保存下来
const { mount } = app;
// web平台重新mount逻辑
app.mount = (containerOrSelector: Element | string): any => {
  const container = normalizeContainer(containerOrSelector);
  if (!container) return;
  const component = app._component;
  // render函数和tempalte选项在渲染时的优先级高于挂载元素的InnerHTML
  if (!isFunction(component) && !component.render && !component.template) {
    component.template = container.innerHTML;
  }
  // clear content before mounting
  container.innerHTML = "";
  const proxy = mount(container);
  container.removeAttribute("v-cloak");
  container.setAttribute("data-v-app", "");

  // 返回实例，调用app.mount()后可以链式调用其他实例方法
  return proxy;
};
```

至此，`createApp()`方法的逻辑已经梳理完成，此时调用`app.mount()`方法即可将app挂载在DOM元素上。

#### 总结一下createApp()和mount()做的工作：

- 创建Renderer
- 创建实例
- 创建VNode
- 根据不同的平台渲染VNode
- 将VNode挂载到根元素