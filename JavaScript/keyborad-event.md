## keydown keypress keyup

Chrome 81.0.4044.138

Safari 13.0.4下测试:

触发顺序: `keydown` -> `keypress` -> `keyup`

其中如果键入了不能产生字符的按键,不会触发`keypress`事件

***

#### 在vue中使用elementUI的折叠面板(el-collapse)组件遇到的问题

`el-collapse`的`header`中可以通过`slot`插入自定义头部内容,如果头部包含了输入框,在键入空格/回车时会触发`el-collapse`的折叠动作,经调试只有监听`keyup`事件并阻止其冒泡可以解决问题

---