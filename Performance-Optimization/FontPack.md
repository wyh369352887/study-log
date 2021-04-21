在设计开发用户交互界面时，我们常常会碰到有关字体的问题：

+ 不同终端设备所默认的系统字体不同。
+ 相同终端设备对不同平台下载的同一款字体，渲染有细微差别。
+ 在某些特定场景，或是需要与其他内容作明显的区分时，设计师提供给我们的设计稿中经常会使用**特殊字体**。



对于前两点，我们可以统一使用开发语言中默认支持的一些开源字体，或者根据公司情况选择已购买版权的商用字体，下载指定的字体包在项目中引用。

而对于第三点，有时只需要对数字或字母使用特殊字体，有时甚至只有几个汉字使用了特殊字体。这时，面对少则几兆，多则几十兆的字体包，盲目引入是不可取的。



##### 特殊字体的内容已知

可以直接使用图片大法，常见场景：Banner、KV、按钮等。但也要综合考虑，如果项目中这种场景较多，建议还是引入自定义字体包（方法见下面）

##### 特殊字体的内容未知且包含汉字

这种情况笔者目前并不知道比较完美的动态内容自定义字体包的解决方案，通常还是直接引入整个字体包

##### 特殊字体内容未知但不包含汉字（包含固定汉字时也适用）

推荐使用[font-spider-cli](https://www.npmjs.com/package/font-spider-cli)，是[字蛛font-spider](https://github.com/aui/font-spider)的命令行版本。个人觉得相比于字蛛，使用cli版本更加简单方便，同时也不需要额外的`html、css`相关知识。



### 步骤如下：

新建一个文件夹，可以在anywhere。但如果是在你的项目内，使用完毕后建议删除。

`$ mkdir font-spider-cli && cd font-spider-cli`

安装cli

`$ npm install font-spider-cli`

按照npm上的文档试一下

> 输入命令 fsc -t 需要转换的文字 -f 文字文件的名称不要后缀 -n 文字名称

这里需要注意的是：

+ 字体包文件不要加类型后缀
+ 把字体包文件直接拖进终端窗口就可以显示完整路径，如果字体包名称中包含空格，把空格删掉
+ 不出意外的话，应该会报错，因为我们没有配`fsc`的环境变量

`fsc -t 你想要转换的内容 -f /Users/myMac/Desktop/font-spider-cli/MesloLGS -n myFont`

果不其然，`zsh: command not found: fsc`。这里笔者为了方便，一次性工具，不再配置环境变量，直接索引到脚本文件所在的目录下执行

`node_modules/font-spider-cli/bin/fsc -t 你想要转换的内容 -f /Users/myMac/Desktop/font-spider-cli/MesloLGS -n myFont`

然后你将会看到：

```
Font family: myFont
Original size: 1260.156 KB     // 原始大小
Include chars: ABCDEFG
Chars length: 7
Font id: ecc0892b0b3890d20437f3285bf9fe94
CSS selectors: .text
Font files:
File MesloLGS.eot created: 7.69 KB
File MesloLGS.woff created: 7.6 KB
File MesloLGS.ttf created: 7.512 KB
File MesloLGS.svg created: 3.018 KB
// 上边四行是提取指定内容后的字体包大小
```

同时，`font-spider-cli/`下会多出`.ttf .eot .svg .woff`四个同名字体文件（即我们需要的东西）和`.font-spider`文件夹，里边存放了原始字体包。

看了一下源码，其实cli版本就是将`font-spider`需要手动做的一些操作给封装了进来，更加快捷。

贴上核心部分：

```javascript
const program = require('commander');
const version = require('./package.json').version;
const fontspider = require('font-spider');
const colors = require('colors/safe');
const fs = require('fs-extra');
const spider = fontspider.spider;
const compressor = fontspider.compressor;
const path = require('path');
program
    .version(version)
    .option('-t, --text <text>', '输入需要转换的文字')
    .option('-f, --font <font>', '输入font地址(执行目录下)')
    .option('-n, --name <name>', '输入font地址(执行目录下)')
    .parse(process.argv);

function mock(text, font, fontname) {
    font = path.resolve(process.cwd(), font);
    return `
    <style>
    @font-face {
        font-family: '${fontname}';
        src: url('${font}.eot');
        src:
          url('${font}.eot?#font-spider') format('embedded-opentype'),
          url('${font}.woff') format('woff'),
          url('${font}.ttf') format('truetype'),
          url('${font}.svg') format('svg');
        font-weight: normal;
        font-style: normal;
      }
    .text {
        font-family: '${fontname}';
    }
    </style>
    <div class="text">${text}</div>
    `;
}

if (
    typeof program.text === 'function' ||
    typeof program.font === 'function' ||
    typeof program.name === 'function')
{
    onerror(new ReferenceError('-t或-f或-n未输入'));
}

const html = mock(program.text, program.font, program.name);

compressWebFont([{
    path: process.cwd(),
    contents: html
}], {});

function compressWebFont(htmlFiles, options) {

    logIn('Loading ..');

    spider(htmlFiles, options).then(function(webFonts) {

        if (webFonts.length === 0) {
            clearLonIn();
            log('<web font not found>');
            return webFonts;
        }

        logIn('Loading ...');

        return compressor(webFonts, options);
    }).then(function(webFonts) {

        clearLonIn();
        webFonts.forEach(function(webFont) {

            log('Font family:', colors.green(webFont.family));
            log('Original size:', colors.green(webFont.originalSize / 1000 + ' KB'));
            log('Include chars:', webFont.chars);
            log('Chars length:', colors.green(webFont.chars.length));
            log('Font id:', webFont.id);
            log('CSS selectors:', webFont.selectors.join(', '));
            log('Font files:');

            webFont.files.forEach(function(file) {
                if (fs.existsSync(file.url)) {
                    log('File', colors.cyan(path.relative('./', file.url)),
                        'created:', colors.green(file.size / 1000 + ' KB'));
                } else {
                    log(colors.red('File ' + path.relative('./', file.url) + ' not created'));
                }
            });

            log('');
        });

        return webFonts;
    }).catch(onerror);
}
```

