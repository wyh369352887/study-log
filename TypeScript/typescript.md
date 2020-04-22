### TypeScript

1.元组:元组类型允许表示一个已知元素数量和类型的数组:

```
let x: [string, number];
x = ['hello',888];
```

2.枚举:枚举类型是对JavaScript标准数据类型的一个补充,使用枚举类型可以为一组数值赋予友好的名字

```
enum Color {Red,Blue,Green};
let c:Color = Color.Green;
```

默认情况下,从0开始为元素编号,也可以手动为元素编号:

```
//从1开始编号
enum Color {Red = 1,Blue,Green};

//全部手动编号
enum Color {Red = 1,Blue = 2,Green = 4};
```

使用枚举类型的一个方便之处是由枚举的值得到他的名字:

```
enum Color { Red = 1, Blue, Green};
let num:string = Color[2];
//'Blue'
//
```

3.Any:Any类型用于在编译时还不确定类型的变量

```
let noSure:any = 4;
noSure = "some string"; //ok
noSure = false; //ok
```

4.void:void类型与Any相反,表示没有任何类型,当一个函数没有返回值时,通常会见到其返回值类型是void

```
function foo(): void{
    //do something without return
}
```

5.null和undefined:在默认情况下null和undefined是所有类型的子类型,即可以把null和undefined赋值给其他的类型,但是在开启了`--stricNullChecks`标记后,只能将他们赋值给自身

```
let n:null = null;
let u:undefined = undefined;
```

6.Never:never类型表示的是永不存在的值的类型,never类型可以被赋值给任何类型,但是任何类型都不能赋值给never类型(除了never本身)

7.Object:object类型表示非原始类型,也就是除number,string,boolean,symbol,null,undefined之外的类型

8.类型断言:跳过了编译器的语法检查

```
//两种语法
let someValue:any = 'this is a string';
let strLength:number = (<string>someValue).length;

let someValue:any = 'this is a string';
let strLength:number = (someValue as string).length;
```

## 2019.12.31

1.
### 接口:

```
//定义接口,描述要求
interface LabelledValue{
    label:string
}

//使用接口检查参数
function foo(labelledObj:LabelledValue){
    console.log(laballedObj.label);
}

let myObj = {size:10,label:'some string'};

foo(myObj);

//*并不会检查属性的顺序
```

##### 可选属性:属性名后 + ?

```typescript
interface SquareConfig {
  color?: string;
  width?: number;
}

function createSquare(config: SquareConfig): {color: string; area: number} {
  let newSquare = {color: "white", area: 100};
  if (config.color) {
    newSquare.color = config.color;
  }
  if (config.width) {
    newSquare.area = config.width * config.width;
  }
  return newSquare;
}

let mySquare = createSquare({color: "black"});//参数中没有"width"属性也可以通过编译
```

##### 只读属性:属性名前 + readonly

```typescript
interface Point {
    readonly x: number;
    readonly y: number;
}

let p1: Point = { x: 10, y: 20 };
//使用Point接口初始化一个变量

p1.x = 5; 
// error, x为只读属性
```

```typescript
//ts中具有ReadonlyArray类型,与普通的Array类似,只是把所有可变方法都去掉了,所以是只读数组
let a: number[] = [1, 2, 3, 4];
let ro: ReadonlyArray<number> = a;

ro[0] = 12; 
// error,不可修改

ro.push(5);
// error,不可修改

ro.length = 100;
// error,不可修改

a = ro; 
// error,赋值给一个普通数组也不行,但是可以用类型断言重写

a = ro as number[];
```

定义包含接口中不存在的属性时,ts中会报错:

```typescript
interface SquareConfig {
    color?: string;
    width?: number;
}

let mySquare: SquareConfig = { msg: "hi", width: 100 };
//error,SquareConfig中没有msg属性

//a.可以通过类型断言绕过检查
let mySquare: SquareConfig = { msg: "hi", width: 100 } as SquareConfig;

//b.可以通过添加字符索引签名规避该问题
interface SquareConfig{
    color?:string;
    width?:number;
    [propName:string]:any;  //不限制SquareConfig的属性数量,只要属性名不是color或width,那么他的类型可以是任何值
}

//c.可以将对象赋值给另一个变量规避该问题
let squareOptions = {colour:"red",width:100};
let mySquare = createSquare(squareOptions);//因为squareOpitons不会经过额外属性检查的步骤,所以编译器不会报错
```

## 2020.1.2

##### 函数类型:接口除了可以描述普通对象,还可以描述函数类型

```typescript
//定义一个函数类型接口
interface func {
    (param1:number ,param2:string):boolean
}
//定义了一个有两个参数的函数类型接口,第一个参数为number类型,第二个参数为string类型,函数返回值时boolean类型

let myFunc:func;

myFunc = function(p1,p2):boolean{
    //do some thing
    return false
}
//函数调用时的参数名不必与接口中的名字相同,编译器会对位检查参数类型,符合即可

```

##### 可索引的类型:

```typescript
interface StringArray {
    [index:number]:string
}
//支持number和string两种索引方式,但两种方法返回值必须保持一致

let myArray:StringArray;
myArray = ["red","blue"];

let myStr:string = myArray[0]

//可以将索引签名前加"readonly"将索引设为只读
interface StringArray {
    readonly [index:number]:string
}
```

##### 类 类型:强制一个类去符合某种契约

```typescript
interface ClockInterface {
    currentTime:Date;
    setTime(d:Date);
}

class Clock implements ClockInterface {
    currentTime:Date;
    setTime(d:Date){
        //do some thing
    };
    constructor(h:number,m:number){};
}
//接口规定了类的公共成员,不检查私有成员
```

##### 接口的继承:

```typescript
interface Shape {
    color: string;
}

interface Square extends Shape {
    sideLength: number;
}

let square = <Square>{};
square.color = "blue";
square.sideLength = 10;
```

一个接口也可以继承多个接口

```typescript
interface Shape {
    color: string;
}

interface PenStroke {
    penWidth: number;
}

interface Square extends Shape, PenStroke {
    sideLength: number;
}

let square = <Square>{};
square.color = "blue";
square.sideLength = 10;
square.penWidth = 5.0;
```

##### 混合类型接口:

```typescript
//一个对象可以同时作为函数和对象使用,并带有额外的属性
interface Counter {
    (start: number): string;
    interval: number;
    reset(): void;
}

function getCounter(): Counter {
    let counter = <Counter>function (start: number) { };
    counter.interval = 123;
    counter.reset = function () { };
    return counter;
}

let c = getCounter();
c(10);
c.reset();
c.interval = 5.0;
```

##### 接口继承类:

```typescript
//接口继承类时,同时继承了类的私有成员,因此只有类的子类才能实现接口,因为只有类的子类能拥有这个私有成员
class Control {
    private state: any;
}

interface SelectableControl extends Control {
    select(): void;
}

class Button extends Control implements SelectableControl {
    select() { }
}

class TextBox extends Control {
    select() { }
}

// 错误：“Image”类型缺少“state”属性。
class Image implements SelectableControl {
    select() { }
}
```

## 2020.1.3

### 类

##### 类的继承

```typescript
class Animal{
    move(distanceInMeters:number = 0){
        console.log(`Animal moved ${distanceInMeters}m.`);
    }
}

class Dog extends Animal {
    bark(){
        console.log('woo! woo!');
    }
}

const dog = new Dog();
dog.bark();
dog.move(10);
dog.bark();
//woo! woo!
//Animal moved 10m.
//woo! woo!
```

派生类包含了一个构造函数，它 必须调用 super()，它会执行基类的构造函数。 而且，在构造函数里访问 this的属性之前，我们 一定要调用 super()。 这个是TypeScript强制执行的一条重要规则。


```typescript
class Animal {
    name: string;
    constructor(theName: string) { this.name = theName; }
    move(distanceInMeters: number = 0) {
        console.log(`${this.name} moved ${distanceInMeters}m.`);
    }
}

class Snake extends Animal {
    constructor(name: string) { super(name); }
    move(distanceInMeters = 5) {
        console.log("Slithering...");
        super.move(distanceInMeters);
    }
}

class Horse extends Animal {
    constructor(name: string) { super(name); }
    move(distanceInMeters = 45) {
        console.log("Galloping...");
        super.move(distanceInMeters);
    }
}

let sam = new Snake("Sammy the Python");
let tom: Animal = new Horse("Tommy the Palomino");

sam.move();
tom.move(34);
//Slithering...
//Sammy the Python moved 5m.
//Galloping...
//Tommy the Palomino moved 34m.
```

##### 公共,私有与受保护的修饰符

类的成员默认为公开的(public),声明是不表明等同于在属性、方法或构造函数前加 `public`

```typescript
class Animal {
    public name: string;
    public constructor(theName: string) { this.name = theName; }
    public move(distanceInMeters: number) {
        console.log(`${this.name} moved ${distanceInMeters}m.`);
    }
}
```

##### 私有成员:private

```typescript
class Animal {
    private name: string;
    constructor(theName: string) { this.name = theName; }
}

new Animal("Cat").name; // 错误: 'name' 是私有的.
```

当我们比较带有 private或 protected成员的类型的时候，情况就不同了。 如果其中一个类型里包含一个 private成员，那么只有当另外一个类型中也存在这样一个 private成员， 并且它们都是来自同一处声明时，我们才认为这两个类型是兼容的。 对于 protected成员也使用这个规则:

```typescript
class Animal {
    private name: string;
    constructor(theName: string) { this.name = theName; }
}

class Rhino extends Animal {
    constructor() { super("Rhino"); }
}

class Employee {
    private name: string;
    constructor(theName: string) { this.name = theName; }
}

let animal = new Animal("Goat");
let rhino = new Rhino();
let employee = new Employee("Bob");

animal = rhino;//success,rhino的私有成员name是来自animal中定义的
animal = employee;//error,animal和employee不兼容,他们的私有成员name不来自同一处声明
```

##### protected:行为与`private`成员类似,但是可以在派生类中访问

```typescript
class Person {
    protected name: string;
    constructor(name: string) { this.name = name; }
}

class Employee extends Person {
    private department: string;

    constructor(name: string, department: string) {
        super(name)
        this.department = department;
    }

    public getElevatorPitch() {
        return `Hello, my name is ${this.name} and I work in ${this.department}.`;
    }
}

let howard = new Employee("Howard", "Sales");
console.log(howard.getElevatorPitch());
console.log(howard.name); // 错误,protected成员只能在本身和派生类中访问,无法在实例中访问
```

##### 可以将构造函数标记成`protected`成员,意味着不能直接通过这个类创造实例,但是可以先继承,再通过派生类创造实例

```typescript
class Person {
    protected name: string;
    protected constructor(theName: string) { this.name = theName; }
}

// Employee 能够继承 Person
class Employee extends Person {
    private department: string;

    constructor(name: string, department: string) {
        super(name);
        this.department = department;
    }

    public getElevatorPitch() {
        return `Hello, my name is ${this.name} and I work in ${this.department}.`;
    }
}

let howard = new Employee("Howard", "Sales");
let john = new Person("John"); // 错误: 'Person' 的构造函数是被保护的.
```

## 2020.1.6 

##### readonly修饰符:只读属性必须在声明时或构造函数内被初始化

```typescript
class Octopus {
    readonly name: string;
    readonly numberOfLegs: number = 8;
    constructor (theName: string) {
        this.name = theName;
    }
}
let dad = new Octopus("Man with the 8 strong legs");//通过构造函数初始化
dad.name = "Man with the 3-piece suit"; // 错误! name 是只读的.
```

##### 存取器:截取对对象成员的访问和设置操作

```typescript
let passcode = "secret passcode";

class Employee {
    private _fullName: string;

    get fullName(): string {
        return this._fullName;
    }

    set fullName(newName: string) {
        if (passcode && passcode == "secret passcode")
        //设置对象成员时添加验证条件
            this._fullName = newName;
        }
        else {
            console.log("Error: Unauthorized update of employee!");
        }
    }
}

let employee = new Employee();
employee.fullName = "Bob Smith";
if (employee.fullName) {
    alert(employee.fullName);
}

//*只有get没有set方法的属性被编译器自动推断成readonly
```

##### 类的静态属性:在实例上访问类的静态属性时,要通过`类名.`调用

```typescript
class Grid {
    static origin = {x: 0, y: 0};
    calculateDistanceFromOrigin(point: {x: number; y: number;}) {
        let xDist = (point.x - Grid.origin.x);
        let yDist = (point.y - Grid.origin.y);
        return Math.sqrt(xDist * xDist + yDist * yDist) / this.scale;
    }
    constructor (public scale: number) { }
}

let grid1 = new Grid(1.0);  // 1x scale
let grid2 = new Grid(5.0);  // 5x scale

console.log(grid1.calculateDistanceFromOrigin({x: 10, y: 10}));
console.log(grid2.calculateDistanceFromOrigin({x: 10, y: 10}));
```

##### 抽象类、抽象方法:使用`abstract`定义,不能直接实例化一个抽象类,抽象类中可以包含成员的实现细节,但是抽象方法方法体必须在派生类中实现

```typescript
abstract class Department {

    constructor(public name: string) {
    }

    printName(): void {
        console.log('Department name: ' + this.name);
    }

    abstract printMeeting(): void; // 必须在派生类中实现
}

class AccountingDepartment extends Department {

    constructor() {
        super('Accounting and Auditing'); // 在派生类的构造函数中必须调用 super()
    }

    printMeeting(): void {
        console.log('The Accounting Department meets each Monday at 10am.');
    }

    generateReports(): void {
        console.log('Generating accounting reports...');
    }
}

//let department: Department; 可以,允许创建一个对抽象类型的引用
//let department = new Department(); 错误: 不能创建一个抽象类的实例
//let department = new AccountingDepartment(); 可以,允许对一个抽象子类进行实例化和赋值
//department.printName(); Department name: Accounting and Auditing
//department.printMeeting(); The Accounting Department meets each Monday at 10am.
```

## 2020.1.7

### 函数

##### 为函数定义类型

```typescript
function add(x: number, y: number): number {
    return x + y;
}

let myAdd = function(x: number, y: number): number { return x + y; };

//完整的函数定义例子

let myAdd: (x: number, y: number) => number = function(x: number, y: number): number { 
    return x + y; 
};
```

##### 可选参数和默认参数

```typescript
//可选参数:在参数名旁边+？
function buildName(firstName: string, lastName?: string) {//lastName是可选参数
    if (lastName)
        return firstName + " " + lastName;
    else
        return firstName;
}
//可选参数必须跟在必须参数后面
```

```typescript
//带默认值的参数
function buildName(firstName: string, lastName = "Smith") {
    return firstName + " " + lastName;
}
//带默认值的参数无需放在最后,但是想要取到参数的默认值,在调用时需给对应位置的参数传递undefined

let result = buildName("Bob", undefined); 
```

##### 剩余参数

```typescript
//用省略号表示
function buildName(firstName: string, ...restOfName: string[]) {
  return firstName + " " + restOfName.join(" ");
}
```

##### 函数重载

```typescript
//根据不同的参数类型返回不同的结果
let suits = ["hearts", "spades", "clubs", "diamonds"];

function pickCard(x: {suit: string; card: number; }[]): number;
function pickCard(x: number): {suit: string; card: number; };
function pickCard(x): any {
    if (typeof x == "object") {
        let pickedCard = Math.floor(Math.random() * x.length);
        return pickedCard;
    }
    else if (typeof x == "number") {
        let pickedSuit = Math.floor(x / 13);
        return { suit: suits[pickedSuit], card: x % 13 };
    }
}

let myDeck = [{ suit: "diamonds", card: 2 }, { suit: "spades", card: 10 }, { suit: "hearts", card: 4 }];

let pickedCard1 = myDeck[pickCard(myDeck)];

let pickedCard2 = pickCard(15);
```

## 2020.1.8 

## 泛型

##### 泛型函数

```typescript
//使用类型变量,在函数名后边加<>
function identity<T>(arg: T): T {
    return arg;
}
//函数的返回值类型和参数类型保持一致:T
//只关心函数的返回值和参数的类型是否一致,不必关心他们具体是什么类型

//调用
//传入具体的类型
let output = identity<string>("myString");

//不传入具体类型,使用类型推论,编译器会根据传入的值自动判断函数返回值的类型
let output = identity("myString");
```

##### 泛型接口

```typescript
//将泛型函数的签名作为整个接口的一个参数
interface GenericIdentityFn {
    <T>(arg: T): T;
}

function identity<T>(arg: T): T {
    return arg;
}

let myIdentity: GenericIdentityFn = identity;
```

##### 泛型类

```typescript
//与泛型函数类似,在类名后加<>
class GenericNumber<T> {
    zeroValue: T;
    add: (x: T, y: T) => T;
}

let myGenericNumber = new GenericNumber<number>();
myGenericNumber.zeroValue = 0;
myGenericNumber.add = function(x, y) { return x + y; };
```

##### *不能创建泛型枚举和泛型命名空间

##### 泛型约束:可以定义一个接口来描述约束条件

```typescript
interface lengthWise {
    length:number
}

function loggingIdentify<T extends lengthWise>(arg:T):T{
    console.log(arg.length);
    return arg
}
//如果没有约束条件,编译器不能保证每一种类型的值都具有length属性,所以会报错
//添加了约束条件后,不再适用于所有类型

loggingIdentify(3);
//error,number类型没有Length属性
```

## 枚举:定义一些带名字的常量。ts支持数字的和基于字符串的枚举

```typescript
//数字枚举
enum Direction = {
    Up = 1,
    Down,
    Left,
    Right
}
//Up的值初始化为1,其余的成员会从1开始增长:2、3、4
//不初始化的情况下默认从0开始

//字符串枚举:没有自增长行为,所以每个成员必须初始化
enum Direction {
    Up = "UP",
    Down = "DOWN",
    Left = "LEFT",
    Right = "RIGHT",
}

//异构枚举:混合了数字枚举和字符串枚举
enum BooleanLikeHeterogeneousEnum {
    No = 0,
    Yes = "YES",
}

//反向映射:通过枚举成员的值查找枚举成员
enum Enum {
    A
}
let a = Enum.A;
let nameOfA = Enum[a]; // "A"

//外部枚举:用来描述已经存在的枚举类型的形状
declare enum Enum {
    A = 1,
    B,
    C = 2
}
//不同的一点:在正常的枚举里没有初始化的成员被当成是常数成员,在外部枚举里,没有初始化的成员被当成是需要经过计算的

```

## 2020.1.9

## 类型兼容性

##### ts中结构化类型的基本规则是:如果x要兼容y,那么y至少具有与x相同的属性

```typescript
interface Named {
    name: string;
}

let x: Named;
let y = { name: 'Alice', location: 'Seattle' };
x = y;
//success,编译器会检查在y中能否找到与x对应的属性
```

##### 比较两个函数

```typescript
//针对参数列表:是否能将x赋值给y,要看x的参数列表中的每个参数是否在y中能找到对应的,不要求参数名相同,只要求类型相同(允许忽略参数)
let x = (a: number) => 0;
let y = (b: number, s: string) => 0;

y = x; // OK
x = y; // Error

//针对返回值:与针对参数列表时相反,被赋值函数的返回值必须是赋值函数返回值的子类型(不允许忽略返回值的属性)
let x = () => ({name: 'Alice'});
let y = () => ({name: 'Alice', location: 'Seattle'});

x = y; // OK
y = x; // Error, because x() lacks a location property
```

##### 数字类型和枚举类型互相兼容,但是不同的枚举类型之间互不兼容

```typescript
enum Status { Ready, Waiting };
enum Color { Red, Blue, Green };

let status = Status.Ready;
status = Color.Green;  // Error
```

##### 比较两个类:只比较实例的成员,静态成员和构造函数不会被比较

```typescript
class Animal {
    feet: number;
    constructor(name: string, numFeet: number) { }
}

class Size {
    feet: number;
    constructor(numFeet: number) { }
}

let a: Animal;
let s: Size;

a = s;  // OK, a.feet = s.feet also OK

//类具有pravite、protected属性时,只有当两个实例包含来自同一个类的该属性时才兼容
class Animal {
    feet: number;
    private name:string;
    constructor(name: string, numFeet: number) { }
}
class Person{
    feet: number;
    private name:string;
    constructor(name: string, numFeet: number) { }
}

let a: Animal;
let b: Person;
let c: Animal;

a = b;//error
a = c;//OK
```

##### 比较泛型

```typescript
interface Empty<T> {
}
let x: Empty<number>;
let y: Empty<string>;

x = y;  // OK, because y matches structure of x

//泛型内没有属性时,相当于比较两个any类型

interface NotEmpty<T> {
    data: T;
}
let x: NotEmpty<number>;
let y: NotEmpty<string>;

x = y;  // Error, because x and y are not compatible

//泛型内有属性时,属性有了类型就不再兼容
```

## 2020.1.10

## 高级类型

##### 交叉类型:"&"

```typescript
//包含了所需的每个类型的所有成员
function extend<T, U>(first: T, second: U): T & U {
    let result = <T & U>{};
    for (let id in first) {
        (<any>result)[id] = (<any>first)[id];
    }
    for (let id in second) {
        if (!result.hasOwnProperty(id)) {
            (<any>result)[id] = (<any>second)[id];
        }
    }
    return result;
}

class Person {
    constructor(public name: string) { }
}
interface Loggable {
    log(): void;
}
class ConsoleLogger implements Loggable {
    log() {
        // ...
    }
}
var jim = extend(new Person("Jim"), new ConsoleLogger());
var n = jim.name;
jim.log();

//交叉类型jim包含了Person类的name属性和ConsoleLogger类的log()方法
```

##### 联合类型:"|"

```typescript
//包含了所需的类型中的共有成员
interface Bird {
    fly();
    layEggs();
}

interface Fish {
    swim();
    layEggs();
}

function getSmallPet(): Fish | Bird {
    // return something
}

let pet = getSmallPet();
pet.layEggs(); // okay
pet.swim();    // errors

联合类型pet只包含了Bird、Fish类所共有的layEggs()方法
```

##### 类型保护

```typescript
//用户自定义类型的保护: parameterName is Type
//定义一个函数,返回一个类型谓词
function isFish(pet: Fish | Bird): pet is Fish {
    return (<Fish>pet).swim !== undefined;
}

//调用isFish()并传入一个变量时会返回变量是否属于这个类型
if (isFish(pet)) {
    pet.swim();
}
else {
    pet.fly();
}
//*注意TypeScript不仅知道在 if分支里 pet是 Fish类型； 它还清楚在 else分支里，一定 不是 Fish类型，一定是 Bird类型


//原始类型的保护:typeof
//typeof类型保护可以不必抽成一个函数
function padLeft(value: string, padding: string | number) {
    if (typeof padding === "number") {
        return Array(padding + 1).join(" ") + value;
    }
    if (typeof padding === "string") {
        return padding + value;
    }
    throw new Error(`Expected string or number, got '${padding}'.`);
}


//instanceof类型保护:要求instanceof右侧是一个具体的构造函数
interface Padder {
    getPaddingString(): string
}

class SpaceRepeatingPadder implements Padder {
    constructor(private numSpaces: number) { }
    getPaddingString() {
        return Array(this.numSpaces + 1).join(" ");
    }
}

class StringPadder implements Padder {
    constructor(private value: string) { }
    getPaddingString() {
        return this.value;
    }
}

function getRandomPadder() {
    return Math.random() < 0.5 ?
        new SpaceRepeatingPadder(4) :
        new StringPadder("  ");
}

// 类型为SpaceRepeatingPadder | StringPadder
let padder: Padder = getRandomPadder();

if (padder instanceof SpaceRepeatingPadder) {
    padder; // 类型细化为'SpaceRepeatingPadder'
}
if (padder instanceof StringPadder) {
    padder; // 类型细化为'StringPadder'
}

```

##### --strictNullChecks标记

```typescript
//当你声明一个变量时，它不会自动地包含 null或 undefined。 你可以使用联合类型明确的包含它们
let s = "foo";
s = null; // 错误, 'null'不能赋值给'string'
let sn: string | null = "bar";
sn = null; // 可以

sn = undefined; // error, 'undefined'不能赋值给'string | null'

//对于可选参数和可选属性,会被自动添加变成 'type || undefined'
function f(x: number, y?: number) {
    return x + (y || 0);
}
f(1, 2);
f(1);
f(1, undefined);
f(1, null); // error, 'null' is not assignable to 'number | undefined'

class C {
    a: number;
    b?: number;
}
let c = new C();
c.a = 12;
c.a = undefined; // error, 'undefined' is not assignable to 'number'
c.b = 13;
c.b = undefined; // ok
c.b = null; // error, 'null' is not assignable to 'number | undefined'

//由于值可以是null的类型使用了联合类型,在需要去除null类型时,如果编译器不能够去除null或undefined,可以再标识符后加!手动使用类型断言去除
function foo(s:number | null){
    console.log(s.toString());//error,s有可能是null
}

function foo(s:number | null){
    console.log(s!.toString());//ok,手动去除了null和undefined
}
```

## 2020.1.13

##### 类型别名:给类型起一个新名字。并不会创建一个新类型,只是创建了一个新名字来引用该类型

```typescript
type Name = string;
type NameResolver = () => string;
type NameOrResolver = Name | NameResolver;
function getName(n: NameOrResolver): Name {
    if (typeof n === 'string') {
        return n;
    }
    else {
        return n();
    }
}
```

##### 字符串字面量类型:可以指定允许的值

```typescript
//字符串字面量类型与类型别名结合
type Easing = "ease-in" | "ease-out" | "ease-in-out";

class UIElement {
    animate(dx: number, dy: number, easing: Easing) {
        if (easing === "ease-in") {
            // ...
        }
        else if (easing === "ease-out") {
        }
        else if (easing === "ease-in-out") {
        }
        else {
            // error! should not pass null or undefined.
        }
    }
}

let button = new UIElement();
button.animate(0, 0, "ease-in");
button.animate(0, 0, "uneasy"); // error: "uneasy" is not allowed here
```

##### 数字字面量类型

```typescript
function rollDie(): 1 | 2 | 3 | 4 | 5 | 6 {
    // ...
}
```

##### 可辨识联合:将单例类型、联合类型、类型保护和类型别名合并

```typescript
interface Square {
    kind: "square";
    size: number;
}
interface Rectangle {
    kind: "rectangle";
    width: number;
    height: number;
}
interface Circle {
    kind: "circle";
    radius: number;
}

type Shape = Square | Rectangle | Circle;

function area(s: Shape) {
    switch (s.kind) {
        case "square": return s.size * s.size;
        case "rectangle": return s.height * s.width;
        case "circle": return Math.PI * s.radius ** 2;
    }
}
```

##### 多态的this类型

```typescript
class BasicCalculator {
    public constructor(protected value: number = 0) { }
    public currentValue(): number {
        return this.value;
    }
    public add(operand: number): this {
        this.value += operand;
        return this;
    }
    public multiply(operand: number): this {
        this.value *= operand;
        return this;
    }
    // ... other operations go here ...
}

//每个方法都返回this,实现连续调用

let v = new BasicCalculator(2)
            .multiply(5)
            .add(1)
            .currentValue();
```

##### keyof操作符:对于任意类型T,keyof T返回T上已知的公共属性名的联合

```typescript
interface Person {
    name: string;
    age: number;
}

let personProps: keyof Person; // 'name' | 'age'
```

##### T[K]索引访问操作符:编译器会实时返回对应的真实类型

```typescript
//getProperty里的 o: T和 name: K，意味着 o[name]: T[K]。 当你返回 T[K]的结果，编译器会实例化键的真实类型，因此 getProperty的返回值类型会随着你需要的属性改变。
let name: string = getProperty(person, 'name');
let age: number = getProperty(person, 'age');
let unknown = getProperty(person, 'unknown'); // error, 'unknown' is not in 'name' | 'age'
```

##### 映射类型:从旧类型中创建新类型

```typescript
type Readonly<T> = {
    readonly [P in keyof T]: T[P];
}
//将类型T中的所有属性变为只读

type Partial<T> = {
    [P in keyof T]?: T[P];
}
//将类型T中的所有属性变为可选
```

##### Symbols

```typescript
//一些众所周知的内置symbols

//Symbl.hasInstance
//构造器对象用来识别一个对象是否是其实例

let array:number[] = [];

array instanceof Array; //true
Array[Symbol.hasInstance](array); //true

//Symbol.isConcatSpreadable
//布尔值，表示当在一个对象上调用Array.prototype.concat时，这个对象的数组元素是否可展开

let x:number[] = [1];
let y:number[] = [2];
let boo = x.concat(y);//[1,2]

let x:number[] = [1];
let y:number[] = [2];
x[Symbol.isConcatSpreadable] = false;
let boo = x.concat(y); //[[1],2],x不能被展开

//Symbol.iterator
//返回对象的默认迭代器

let x:number[] = [1,2,3];
x[Symbol.iterator]//ƒ values() { [native code] }

//Symbol.match
//正则表达式用来匹配字符串

const regexp1 = /foo/;

console.log('/foo/'.startsWith(regexp1));//error,第一个参数不应是个正则表达式

regexp1[Symbol.match] = false;

console.log('/foo/'.startsWith(regexp1));
// ok,true

console.log('/baz/'.endsWith(regexp1));
// ok,false

//Symbol.replace
//指向一个方法，当对象被String.prototype.replace方法调用时，会返回该方法的返回值

const x = {};
x[Symbol.replace] = (...s) => console.log(s);
'Hello'.replace(x, 'World') // ["Hello", "World"]

//Symbol.search
//接受一个正则表达式,返回该正则表达式在字符串中匹配到的下标

class MySearch {
  constructor(value) {
    this.value = value;
  }
  [Symbol.search](string) {
    return string.indexOf(this.value);
  }
}
'foobar'.search(new MySearch('foo')) // 0

//Symbol.split
//用法与Symbol.search类似,在被String.prototype.split调用时返回该方法的返回值

//

//Symbol.species
//指向一个构造函数。创建衍生对象时，会使用该属性

class MyArray extends Array {
}

const a = new MyArray(1, 2, 3);
const b = a.map(x => x);
const c = a.filter(x => x > 1);

b instanceof MyArray // true
c instanceof MyArray // true

//b和c不仅是Array的实例,实际上也是myArray的衍生对象
//Symbol.species就是为了解决这个问题而提供的

//默认的Symbol.species属性
static get [Symbol.species]() {
  return this;
}

//修改后的Symbol.species属性
class MyArray extends Array {
  static get [Symbol.species]() { return Array; }
}

const a = new MyArray();
const b = a.map(x => x);

b instanceof MyArray // false
b instanceof Array // true

//b就不再是a的衍生对象了

//Symbol.toPrimitive
//指向一个方法,在该对象被转为原始类型的值时调用
//转换有3种模式:
//1.转换成数值  'number'
//2.转换成字符串  'string'
//3.可以是数值也可以是字符串  'default'

let obj = {
  [Symbol.toPrimitive](hint) {
    switch (hint) {
      case 'number':
        return 123;
      case 'string':
        return 'str';
      case 'default':
        return 'default';
      default:
        throw new Error();
     }
   }
};

2 * obj // 246
3 + obj // '3default'
obj == 'default' // true
String(obj) // 'str'

//Symbol.toStringTag
//指向一个方法,在该对象上调用Object.prototype.toString方法时,如果这个属性存在,它的返回值会出现在toString方法返回的字符串中
//可以用来定制[object Object]或[object Array]等object后面那个字符串的值

class Collection {
  get [Symbol.toStringTag]() {
    return 'xxx';
  }
}
let x = new Collection();
Object.prototype.toString.call(x) // "[object xxx]"
```

## 2020.02.26

##### 迭代器和生成器

```typescript
//for..of和for..in的区别:for..of迭代对象的值,for..in迭代对象的键

let list = [4, 5, 6];

for (let i in list) {
    console.log(i); // "0", "1", "2",
}

for (let i of list) {
    console.log(i); // "4", "5", "6"
}

//另一个区别是for..in可以操作任何对象,它提供了一种查看对象属性的方法。

let pets = new Set(["Cat", "Dog", "Hamster"]);
pets["species"] = "mammals";

for (let pet in pets) {
    console.log(pet); // "species"
}

for (let pet of pets) {
    console.log(pet); // "Cat", "Dog", "Hamster"
}
```

## 2020.02.27

##### export和import

语法与js类似,但在使用`export = `导出模块时,也必须使用`import = `来导入。