2019.12.02
---
1. document.querySelector(someDom).style获取行内样式<br/>
   document.defaultView.getComputedStyle(someDom,null)获取元素所有计算后的样式(第二个参数是伪元素字符串，不需要时传null)