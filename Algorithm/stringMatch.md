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

### 字符串匹配-kmp算法之部分匹配表解法
解析见[我的博客](https://blog.csdn.net/Elephant_H/article/details/105393667)
```javascript
//获取部分匹配表
function getPartMatch(str) {
    let result = [0],
        len = str.length;
    for (let i = 1; i < len; i++) {
        let child_str = str.substring(0, i + 1);
        for (let j = 0, j_len = child_str.length; j < j_len; j++) {
            let prefix = child_str.substring(0, j),
                suffix = child_str.substring(j_len - j, j_len);
            if (prefix === suffix && prefix !== '') {
                result[i] = prefix.length;
            }
            if (!result[i]) result[i] = 0
        }
    }
    return result
}
//kmp
function kmpPartMatch(str, mode) {
    let partMatch = getPartMatch(mode),
        str_len = str.length,
        mode_len = mode.length,
        result = [];
    for (let i = 0; i < str_len - mode_len; i++) {
        let index = 0;
        while (
            (str.charCodeAt(i + index) === mode.charCodeAt(index)) && (str_len - i > mode_len)
        ) {
            index++;
            if (index === mode_len) result.push(i);
        }
        if (index > 0) {
            let step = index - partMatch[index - 1] - 1;
            i += step;
        }
    }
    return result.length === 0 ? -1 : result
}
```