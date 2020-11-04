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

  if (__DEV__) {
    injectNativeTagCheck(app);
  }

  const { mount } = app;
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

  return app;
}) as CreateAppFunction<Element>;
```

```typescript
function ensureRenderer() {
  return (
    renderer || (renderer = createRenderer<Node, Element>(rendererOptions))
  );
}
```
