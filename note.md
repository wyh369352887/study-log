2019.12.02
---
1.  document.querySelector(someDom).style获取到的是通过元素的style属性设置的样式，不包含样式表层叠样式<br/>
    document.defaultView.getComputedStyle(someDom,null)获取元素所有计算后的样式(第二个参数是伪元素字符串，不需要时传null)<br/>
2.  offsetHeight、offsetWidth<br/>
    宽（高）+ 内边距 + 边框宽（高）度，不包括外边距<br/>
    offsetTop、offsetLeft<br/>
    上（左）外边框到包含元素的上（左）内边框的距离，包含此元素的外边距以及包含元素的内边距<br/>
    offsetParent<br/>
    不一定与parentNode相等，想求元素的offsetLeft或offsetTop，就遍历元素的offsetParent的offsetLeft或offsetTop值相加，直到根元素(根元素的offsetParent = null)<br/>