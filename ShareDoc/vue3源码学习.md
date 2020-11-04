# 从 0 手写 Vue

> version 3.0.2

## 目录

- createApp()
- setep()
- render() h()
- Virtual Dom
- 生命周期 hooks
- Proxy 双向绑定
- reactive() ref()
- computed()
- watch()
- provide() inject()
- directives()
- components()

---

### createApp()

##### 从源码分析 crateApp()做了什么

主入口

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

`baseCreateRenderer`方法非常的长，有 1800+行，进行了大量的函数声明，这里对函数体进行了省略。
函数名起的非常语义化，可以清晰得知`baseCreateRenderer`主要是声明了一些`模板编译`和`patch算法`相关的函数。

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

这里`createApp`方法是调用`createAppAPI`返回的。

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

再回到`cerateApp()`

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

创建 app 时的`mount()`方法做了什么？

```typescript
const app = {
  mount(rootContainer: HostElement, isHydrate?: boolean): any {
    // isMounted初始化为false
    if (!isMounted) {
      // 生成虚拟DOM树
      const vnode = createVNode(rootComponent as ConcreteComponent, rootProps);

      // 初始化挂载时将app的上下文环境存储在vnode根节点上
      vnode.appContext = context;

      // 开发环境添加reload方法提升效率
      if (__DEV__) {
        context.reload = () => {
          render(cloneVNode(vnode), rootContainer);
        };
      }

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

创建 VNode 的`createVnode`方法，返回一个初始化的空`VNode`

```typescript
// 开发环境对参数做了一下处理，最后走的依然是_createVNode方法
export const createVNode = (__DEV__
  ? createVNodeWithArgsTransform
  : _createVNode) as typeof _createVNode;

function _createVNode(
  type: VNodeTypes | ClassComponent | typeof NULL_DYNAMIC_COMPONENT,
  props: (Data & VNodeProps) | null = null,
  children: unknown = null,
  patchFlag: number = 0,
  dynamicProps: string[] | null = null,
  isBlockNode = false
): VNode {
  if (!type || type === NULL_DYNAMIC_COMPONENT) {
    if (__DEV__ && !type) {
      warn(`Invalid vnode type when creating vnode: ${type}.`);
    }
    type = Comment;
  }

  if (isVNode(type)) {
    // 如果接收到的参数是一个已经存在的VNode，类似：
    // <component :is="vnode"/>
    const cloned = cloneVNode(type, props, true /* mergeRef: true */);
    if (children) {
      normalizeChildren(cloned, children);
    }
    return cloned;
  }

  // class component normalization.
  if (isClassComponent(type)) {
    type = type.__vccOpts;
  }

  // class & style normalization.
  if (props) {
    // for reactive or proxy objects, we need to clone it to enable mutation.
    if (isProxy(props) || InternalObjectKey in props) {
      props = extend({}, props);
    }
    let { class: klass, style } = props;
    if (klass && !isString(klass)) {
      props.class = normalizeClass(klass);
    }
    if (isObject(style)) {
      // reactive state objects need to be cloned since they are likely to be
      // mutated
      if (isProxy(style) && !isArray(style)) {
        style = extend({}, style);
      }
      props.style = normalizeStyle(style);
    }
  }

  // encode the vnode type information into a bitmap
  const shapeFlag = isString(type)
    ? ShapeFlags.ELEMENT
    : __FEATURE_SUSPENSE__ && isSuspense(type)
    ? ShapeFlags.SUSPENSE
    : isTeleport(type)
    ? ShapeFlags.TELEPORT
    : isObject(type)
    ? ShapeFlags.STATEFUL_COMPONENT
    : isFunction(type)
    ? ShapeFlags.FUNCTIONAL_COMPONENT
    : 0;

  if (__DEV__ && shapeFlag & ShapeFlags.STATEFUL_COMPONENT && isProxy(type)) {
    type = toRaw(type);
    warn(
      `Vue received a Component which was made a reactive object. This can ` +
        `lead to unnecessary performance overhead, and should be avoided by ` +
        `marking the component with \`markRaw\` or using \`shallowRef\` ` +
        `instead of \`ref\`.`,
      `\nComponent that was made reactive: `,
      type
    );
  }

  const vnode: VNode = {
    __v_isVNode: true,
    [ReactiveFlags.SKIP]: true,
    type,
    props,
    key: props && normalizeKey(props),
    ref: props && normalizeRef(props),
    scopeId: currentScopeId,
    children: null,
    component: null,
    suspense: null,
    ssContent: null,
    ssFallback: null,
    dirs: null,
    transition: null,
    el: null,
    anchor: null,
    target: null,
    targetAnchor: null,
    staticCount: 0,
    shapeFlag,
    patchFlag,
    dynamicProps,
    dynamicChildren: null,
    appContext: null,
  };

  // validate key
  if (__DEV__ && vnode.key !== vnode.key) {
    warn(`VNode created with invalid key (NaN). VNode type:`, vnode.type);
  }

  normalizeChildren(vnode, children);

  // normalize suspense children
  if (__FEATURE_SUSPENSE__ && shapeFlag & ShapeFlags.SUSPENSE) {
    const { content, fallback } = normalizeSuspenseChildren(vnode);
    vnode.ssContent = content;
    vnode.ssFallback = fallback;
  }

  if (
    shouldTrack > 0 &&
    // avoid a block node from tracking itself
    !isBlockNode &&
    // has current parent block
    currentBlock &&
    // presence of a patch flag indicates this node needs patching on updates.
    // component nodes also should always be patched, because even if the
    // component doesn't need to update, it needs to persist the instance on to
    // the next vnode so that it can be properly unmounted later.
    (patchFlag > 0 || shapeFlag & ShapeFlags.COMPONENT) &&
    // the EVENTS flag is only for hydration and if it is the only flag, the
    // vnode should not be considered dynamic due to handler caching.
    patchFlag !== PatchFlags.HYDRATE_EVENTS
  ) {
    currentBlock.push(vnode);
  }

  return vnode;
}
```

重写了的`mount()`方法又做了什么？

```typescript
app.mount = (containerOrSelector: Element | string): any => {
  const container = normalizeContainer(containerOrSelector);
  if (!container) return;
  const component = app._component;
  if (!isFunction(component) && !component.render && !component.template) {
    component.template = container.innerHTML;
  }
  // clear content before mounting
  container.innerHTML = "";
  const proxy = mount(container);
  container.removeAttribute("v-cloak");
  container.setAttribute("data-v-app", "");
  return proxy;
};
```
