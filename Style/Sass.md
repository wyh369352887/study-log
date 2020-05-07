## Sass常用方法(着重与Less的异同点)

### 父选择器

在嵌套选择器时,有时也需要直接使用嵌套外层的父选择器`&`,有多层嵌套时,`&`指向嵌套最近的一层父级

```css
a {
  font-weight: bold;
  text-decoration: none;
  &:hover { 
      text-decoration: underline; 
  }
  body.firefox & { 
      font-weight: normal; 
  }
}
```
编译为
```css
a {
    font-weight: bold;
    text-decoration: none; 
}
a:hover {
    text-decoration: underline; 
}
body.firefox a {
    font-weight: normal; 
}
```

`&`必须作为选择器的第一个字符,其后可以跟随后缀生成复合的选择器

```css
#main {
  color: black;
  &-sidebar { 
      border: 1px solid; 
  }
}
```
编译为
```css
#main {
    color: black; 
}
#main-sidebar {
    border: 1px solid; 
}
```

### 属性嵌套

有些css属性遵循相同的命名空间,比如`font-family,font-size,font-weight`都以`font`作为属性的命名空间,为了减少重复输入,Sass允许属性嵌套在命名空间中

```css
.funky {
    font: {
        family: fantasy;
        size: 30em;
        weight: bold;
    }
}
```
编译为
```css
.funky {
    font-family: fantasy;
    font-size: 30em;
    font-weight: bold; 
}
```

命名空间也可以有自己的属性值:

```css
.funky {
    font: 20px/24px {
        family: fantasy;
        weight: bold;
    }
}
```
编译为
```css
.funky {
    font: 20px/24px;
    font-family: fantasy;
    font-weight: bold; 
}
```

### 变量$
```css
/* 定义变量 */
$width:5px;

/* 使用变量 */
#main{
    width:$width;
}

/* 局部变量 */
#main{
    $width:5px;
    .content{
        width:$width;
    }
}

/* 可使用'!global'将局部变量提升为全局变量 */
#main{
    $width:5px !global;
}
```

### 插值语句${}

通过`${}`插值语句可以在选择器或属性名中使用变量,也可以避免运行运算表达式

```css
$name: foo;
$attr: border;
p.#{$name} {
  #{$attr}-color: blue;
}
```
编译为
```css
p.foo {
    border-color: blue; 
}
```

```css
/* 避免运算表达式 */
p {
  $font-size: 12px;
  $line-height: 30px;
  font: #{$font-size}/#{$line-height};
}
```
编译为
```css
p {
    font:12px/30px;
}
```

### 变量定义 !default

可以给变量的末尾加上`!default`给一个变量赋值。此时若变量已经被赋值，则不会再被重新赋值，若还没有赋值，则会被赋予新的值。

```css
$content: "First content";
$content: "Second content?" !default;/* 不生效 */
$new_content: null;/* null视为未赋值 */
$new_content: "First time reference" !default;/* 生效 */
```

### 继承 @extend

```css
.error {
    border: 1px #f00;
    background-color: #fdd;
}
.error.intrusion {
    background-image: url("/image/hacked.png");
}
.seriousError {
    @extend .error;
    border-width: 3px;
}
```
编译为
```css
.error,
.seriousError{
    border:1px #f00;
    background-color:#fdd;
}
.error.intrusion,
.seriousError.intrusion{
    background-image: url("/image/hacked.png");
}
.seriousError{
    border-width:3px;
}
```

### 自定义混合指令 @mixin

```css
/* 声明 */
@mixin large-text {
    font: {
        family: Arial;
        size: 20px;
        weight: bold;
    }
    color: #ff0000;
}

/* 引用 */
.page-title {
  @include large-text;
  padding: 4px;
  margin-top: 10px;
}
```
编译为
```css
.page-title {
    font-family: Arial;
    font-size: 20px;
    font-weight: bold;
    color: #ff0000;
    padding: 4px;
    margin-top: 10px; 
}
```

带参数`@mixin`:引用指令时，按照参数的顺序将值传递过去,如果使用关键词的方式传参，可以忽略顺序

```css
@mixin sexy-border($color, $width) {
    border: {
        color: $color;
        width: $width;
        style: dashed;
    }
}
p { 
    @include sexy-border(blue, 1in); 
}
a{
    @include sexy-border( $width:1in,$color:blue); 
}
```

不确定参数的个数时，可以用参数变量`...`声明变量:

```css
@mixin box-shadow($shadows...) {
    -moz-box-shadow: $shadows;
    -webkit-box-shadow: $shadows;
    box-shadow: $shadows;
}
.shadows {
    @include box-shadow(0px 4px 5px #666, 2px 6px 10px #999);
}
```