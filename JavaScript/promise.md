### Promise API
---

1. promise.finally:无论promise的状态如何改变,finally中的回调函数总是会执行

2. promise.all:将多个promise封装成一个新的promise实例。

只有当所有promise的状态都变为fulfilled,新实例的状态才变为fulfilled,所有promise的返回值组成一个数组传递给新实例的回调函数。

若有一个promise的状态变为rejected,新实例的状态就变为rejected,此时第一个状态变为rejected的promise的返回值会被传递给新实例的回调函数。

3. promise.race:用法同promise.all一样,不同的是只要有一个promise的状态改变了,新实例的状态都会随之改变(不论fulfilled或rejected)