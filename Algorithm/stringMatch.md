### 字符串匹配——暴力匹配
```javascript
function bruteForce(str, mode) {
    let str_len = str.length,
        mode_len = mode.length,
        result = [];
    for (let i = 0; i < str_len; i++) {
        let index = 0;
        while (
            (str.charCodeAt(i + index) === mode.charCodeAt(index)) && (str_len - i > mode_len)
        ) {
            index++;
            if (index === mode_len) result.push(i);
        }
    }
    return result.length === 0 ? -1 : result
}
```