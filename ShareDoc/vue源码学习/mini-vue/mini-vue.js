function createVNode(temp) {
    // 维护一个栈，通过进栈出栈匹配嵌套标签
    const stack = [];
    // root节点
    let obj;
    
    let content = temp;
    while (content.length) {
      if (content.indexOf("<") > 0) {
        // 以文字开头
        const index = content.indexOf("<");
        let text = content.substring(0, index);
        content = content.substring(index);
        if (stack.length) {
          stack[stack.length - 1].children.push(text);
        } else {
          obj.children.push(text);
        }
      } else if (content.indexOf("<") < 0) {
        // 纯文字
        if (stack.length) {
          stack[stack.length - 1].children.push(content);
        } else {
          obj = {
            tag: "",
            children: [],
          };
          obj.children.push(content);
        }
        content = "";
      } else {
        // 以标签开头
        const endIndex = content.indexOf(">");
        let currentTag = content.substring(1, endIndex);
        if (currentTag.indexOf("/") < 0) {
          // 开始标签
          stack.push({
            tag: currentTag,
            children: [],
          });
        } else {
          // 结束标签
          let child = stack[stack.length - 1];
  
          obj = child;
          stack.pop();
        }
        content = content.substring(endIndex + 1);
      }
    }
    return obj;
  }
  function createRender() {
    return function render(vn, dom) {
      if (vn.tag !== "") {
        const tag = document.createElement(vn.tag);
        const text = document.createTextNode(...vn.children);
        tag.appendChild(text);
        dom.appendChild(tag);
      } else {
        const text = document.createTextNode(...vn.children);
        dom.appendChild(text);
      }
    };
  }
  const createApp = function (...args) {
    const render = createRender();
    const app = {
      version: "0.0.1",
      mount(selector) {
        const container = document.querySelector(selector);
        const vnode = createVNode(container.innerHTML);
        container.innerHTML = "";
        render(vnode, container);
        return this;
      },
    };
    return app;
  };
  