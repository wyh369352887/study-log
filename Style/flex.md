### flex布局
---
##### 启用flex布局
块级元素使用flex布局
```css
.box{
    display:flex;
}
```
行内元素使用flex布局
```css
.box{
    display:inline-flex;
}
```
-webkit-内核的浏览器,必须加上`-webkit-`前缀
```css
.box{
    display:-webkit-flex;
    display:flex;
}
```

##### 一些基本概念
采用flex布局的元素称为"容器",它的所有子元素称为"项目"。
容器默认存在两根轴:水平的主轴`main axis`,和垂直的交叉轴`cross axis`。主轴的开始位置叫做`main start`,结束位置叫做`main end`;交叉轴的开始位置叫做`cross start`,结束位置叫做`cross end`。
单个项目占据的主轴空间叫做`main size`,占据的交叉轴空间叫做`cross size`。

##### 容器的属性

```css
.box{
    flex-direction: row | row-reverse | column | column-reverse;
    /*
    flex-direction属性决定主轴的方向
    @property {row} 主轴为水平方向,从左到右(默认)
    @property {row-reverse} 主轴为水平方向,从右到左
    @property {column} 主轴为垂直方向,从上到下
    @property {column-reverse} 主轴为垂直方向,从下到上
    */
    flex-wrap: nowrap | wrap | wrap-reverse;
    /* 
    flex-wrap属性定义如果项目在一条轴线上排不下,如何换行
    @property {nowrap} 不换行,全部排在一行(默认)
    @property {wrap} 换行,第一行在上方
    @property {wrap-reverse} 第一行在下方
    */
    flex-flow: <flex-direction> | <flex-wrap>;
    /* flex-flow是flex-direction和flex-wrap的简写形式 */
    justify-content:flex-start | flex-end | center | space-between | space-around;
    /*  
    justyify-content属性定义了项目在主轴上的对齐方式
    @property {flex-start} 与主轴的起点对齐(默认)
    @property {flex-end} 与主轴的终点对齐
    @property {center} 在主轴上居中对齐
    @property {space-between} 与主轴的两端对齐,且项目之间的间隔都相等
    @property {space-around} 项目之间的间隔相等(项目与容器边框的距离为1,项目与项目之间的距离为2)
    */
    align-items: flex-start | flex-end | center | baseline | stretch;
    /*  
    align-items属性定义项目在交叉轴上的对齐方式
    @property {flex-start} 与交叉轴的起点对齐
    @property {flex-end} 与交叉轴的终点对齐
    @property {center} 在交叉轴上居中对齐
    @property {baseline} 项目的第一行文字的基线对齐
    @property {stretch} 如果项目未设置高度或设为auto,将占满整个容器的高度(默认)
    */
    align-content: flex-start | flex-end | center | space-between | space-around | stretch;
    /*  
    align-content属性定义有多根轴线时,轴线之间的对齐方式。只有一根轴线时无效。
    @property {flex-start} 与交叉轴的起点对齐
    @property {flex-end} 与交叉轴的终点对齐
    @property {center} 在交叉轴上居中对齐
    @property {space-between} 与交叉轴两段对齐
    @property {space-around} 每两根轴线之间距离相等(与容器边框的距离为1,轴线之间的距离为2)
    @property {stretch} 轴线占满整个交叉轴(默认)
    */
}
```

##### 项目的属性

```css
.item{
    order: <Number>;
    /*  
    order属性定义了项目的排列顺序,值越小,排列越靠前,默认为0
    */
    flex-grow: <Number>;
    /*  
    定义项目的放大比例,如果为0,即使存在剩余空间项目也不放大。一旦有一个项目的flex-grow值不为0,则容器内就不会有剩余空间
    */
    flex-shrink: <Number>;
    /*  
    定义项目的缩小比例,默认为1,即容器空间不足,该项目将缩小。该属性值为0的元素不会缩小。该属性的值越大,缩小的比例越大
    */
    flex-basis: <length>;
    /*  
    定义在分配多余空间之前,该项目所占据的主轴空间。默认值为auto,即项目本来的大小。如果没有剩余空间,该属性无效
    */
    align-self: auto | flex-start | flex-end | center | baseline | stretch;
    /*  
    定义项目可以有与其他项目不一样的对齐方式,并覆盖容器的align-items属性,默认值为auto,表示继承父元素的align-items属性,如果没有父元素,则等同于stretch,其他属性与容器元素的align-items属性值相同
    */
}
```