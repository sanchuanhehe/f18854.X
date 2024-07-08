# 资料总结

## 脚位图

![image-20240708222957235](./assets/image-20240708222957235.png)

## 常用汇编语言

### 数据传输指令

1. **`MOVLW k`**
   - 含义：将立即数`k`加载到工作寄存器`WREG`。
   - 常用地方：初始化工作寄存器以备后续操作。
   - 示例：`MOVLW 0x07`

2. **`MOVWF f`**
   - 含义：将`WREG`中的值移动到寄存器`f`。
   - 常用地方：将工作寄存器的值存储到特定寄存器中。
   - 示例：`MOVWF PORTA`

3. **`MOVF f, d`**
   - 含义：将寄存器`f`的值移动到目标寄存器`d`中。
   - 常用地方：在寄存器之间传递数据。
   - 示例：`MOVF INDF0, W`

### 算术运算指令
4. **`ADDLW k`**
   - 含义：将立即数`k`加到工作寄存器`WREG`中。
   - 常用地方：进行简单的数值运算。
   - 示例：`ADDLW 0x05`

5. **`ADDWF f, d`**
   - 含义：将工作寄存器`WREG`的值加到寄存器`f`中，并将结果存储到目标寄存器`d`。
   - 常用地方：累加操作。
   - 示例：`ADDWF COUNT, F`

6. **`SUBLW k`**
   - 含义：将立即数`k`从工作寄存器`WREG`中减去。
   - 常用地方：进行简单的数值减法运算。
   - 示例：`SUBLW 0x05`

7. **`SUBWF f, d`**
   - 含义：将工作寄存器`WREG`中的值从寄存器`f`中减去，并将结果存储到目标寄存器`d`。
   - 常用地方：累减操作。
   - 示例：`SUBWF COUNT, F`

### 逻辑运算指令
8. **`ANDLW k`**
   - 含义：将立即数`k`与工作寄存器`WREG`的值进行逻辑与运算。
   - 常用地方：掩码操作。
   - 示例：`ANDLW 0x0F`

9. **`ANDWF f, d`**
   - 含义：将工作寄存器`WREG`的值与寄存器`f`的值进行逻辑与运算，并将结果存储到目标寄存器`d`中。
   - 常用地方：掩码操作。
   - 示例：`ANDWF PORTA, F`

10. **`IORLW k`**
    - 含义：将立即数`k`与工作寄存器`WREG`的值进行逻辑或运算。
    - 常用地方：设置特定位。
    - 示例：`IORLW 0x0F`

11. **`IORWF f, d`**
    - 含义：将工作寄存器`WREG`的值与寄存器`f`的值进行逻辑或运算，并将结果存储到目标寄存器`d`中。
    - 常用地方：设置特定位。
    - 示例：`IORWF PORTA, F`

12. **`XORLW k`**
    - 含义：将立即数`k`与工作寄存器`WREG`的值进行逻辑异或运算。
    - 常用地方：翻转特定位。
    - 示例：`XORLW 0xFF`

13. **`XORWF f, d`**
    - 含义：将工作寄存器`WREG`的值与寄存器`f`的值进行逻辑异或运算，并将结果存储到目标寄存器`d`中。
    - 常用地方：翻转特定位。
    - 示例：`XORWF PORTA, F`

### 控制指令
14. **`GOTO k`**
    - 含义：无条件跳转到程序存储器的`k`地址。
    - 常用地方：实现程序流程控制。
    - 示例：`GOTO START`

15. **`CALL k`**
    - 含义：调用子程序`k`，保存返回地址。
    - 常用地方：调用子程序。
    - 示例：`CALL DELAY`

16. **`RETURN`**
    - 含义：从子程序返回。
    - 常用地方：子程序结束后返回主程序。
    - 示例：`RETURN`

17. **`RETFIE`**
    - 含义：从中断返回，并使能全局中断。
    - 常用地方：中断服务程序结束时返回。
    - 示例：`RETFIE`

18. **`NOP`**
    - 含义：无操作，执行一个机器周期。
    - 常用地方：延时、占位。
    - 示例：`NOP`

### 位操作指令
19. **`BCF f, b`**
    - 含义：清除寄存器`f`中第`b`位。
    - 常用地方：复位特定位。
    - 示例：`BCF PORTA, 0`

20. **`BSF f, b`**
    - 含义：设置寄存器`f`中第`b`位。
    - 常用地方：设置特定位。
    - 示例：`BSF PORTA, 0`

21. **`BTG f, b`**
    - 含义：翻转寄存器`f`中第`b`位。
    - 常用地方：切换特定位。
    - 示例：`BTG PORTA, 0`

### 条件指令
22. **`BTFSC f, b`**
    - 含义：如果寄存器`f`中第`b`位清零，跳过下一条指令。
    - 常用地方：条件跳转。
    - 示例：`BTFSC PORTA, 0`

23. **`BTFSS f, b`**
    - 含义：如果寄存器`f`中第`b`位置位，跳过下一条指令。
    - 常用地方：条件跳转。
    - 示例：`BTFSS PORTA, 0`

### 数据移动指令
24. **`CLRF f`**
    - 含义：清除寄存器`f`的内容（将其设为0）。
    - 常用地方：初始化寄存器。
    - 示例：`CLRF PORTA`

25. **`CLRW`**
    - 含义：清除工作寄存器`WREG`的内容（将其设为0）。
    - 常用地方：初始化工作寄存器。
    - 示例：`CLRW`

## 常用寄存器及其用法

### 常用寄存器

1. **WREG（工作寄存器）**
   - 用法：作为一个通用的工作寄存器，存储操作数和运算结果。
   - 示例：`MOVLW 0x07` (将立即数7加载到WREG)

2. **STATUS（状态寄存器）**
   - 用法：存储运算结果的状态信息，包括零位、进位位、数字进位位、掉电位、超时位，以及选择内存银行的RP0和RP1位。
   - 示例：`BCF STATUS, RP0` (清除RP0位，选择Bank 0)

3. **PORTA, PORTB, PORTC（端口寄存器）**
   - 用法：控制I/O引脚的状态，读写端口数据。
   - 示例：`MOVWF PORTA` (将WREG的值写入PORTA)

4. **TRISA, TRISB, TRISC（数据方向寄存器）**
   - 用法：设置I/O引脚的方向（输入或输出）。
   - 示例：`BCF TRISA, 0` (将PORTA的第0位设置为输出)

5. **FSR0L, FSR0H（文件选择寄存器）**
   - 用法：作为间接地址寄存器，用于间接访问数据存储器。
   - 示例：`MOVLW 0x07` `MOVWF FSR0L` (将立即数7加载到FSR0L)

6. **INDF0（间接寻址寄存器）**
   - 用法：通过FSR0L和FSR0H指向的地址进行数据访问。
   - 示例：`MOVF INDF0, W` (将FSR0指向的地址的值移动到WREG)

7. **PCL（程序计数器低位）**
   - 用法：控制程序流，通过修改PCL实现跳转。
   - 示例：`MOVLW 0x05` `MOVWF PCL` (跳转到程序计数器的地址5)

8. **PCLATH（程序计数器高位）**
   - 用法：存储程序计数器的高位，与PCL一起控制跳转地址。
   - 示例：`MOVLW 0x02` `MOVWF PCLATH` (设置程序计数器高位为2)

### 示例用法

#### 初始化和配置I/O引脚

```asm
; 初始化PORTA的第0位为输出，并设置其初始状态为低
BCF STATUS, RP0        ; 选择Bank 0
CLRF PORTA             ; 清除PORTA寄存器

BSF STATUS, RP0        ; 选择Bank 1
BCF TRISA, 0           ; 设置PORTA的第0位为输出

BCF STATUS, RP0        ; 回到Bank 0
```

#### 使用间接寻址访问数据

```asm
; 将立即数7存入一个地址
MOVLW 0x07
MOVWF FSR0L            ; 设置FSR0L寄存器
MOVLW 0x70
MOVWF FSR0H            ; 设置FSR0H寄存器

MOVLW 0x55
MOVWF INDF0            ; 通过FSR0指向的地址，将立即数0x55写入该地址
```

#### 控制LED点亮

```asm
; 设置RB0引脚为输出，并点亮LED
BCF STATUS, RP0        ; 选择Bank 0
CLRF PORTB             ; 清除PORTB寄存器

BSF STATUS, RP0        ; 选择Bank 1
BCF TRISB, 0           ; 设置RB0为输出

BCF STATUS, RP0        ; 回到Bank 0
BSF PORTB, 0           ; 设置RB0为高电平，点亮LED
```

### 使用状态寄存器进行条件判断

```asm
; 检查WREG是否为零
MOVLW 0x00
MOVWF WREG             ; 将WREG设置为0

BTFSC STATUS, Z        ; 检查零位，如果为零则跳过下一条指令
GOTO NotZero           ; 如果不为零，则跳转到NotZero
```



## 点灯实验思路

为了在PIC16(L)F18854上实现点亮LED的实验，可以按照以下步骤进行设计和编程：

### 实验步骤

1. **选择合适的引脚**：选择一个引脚用于连接LED。假设使用RB0引脚。

2. **配置引脚为输出模式**：需要配置RB0引脚为输出模式，以便能够控制LED的亮灭。

3. **设置引脚为高电平**：通过将RB0引脚设置为高电平，点亮连接到该引脚的LED。

4. **进入死循环保持LED亮**：保持程序在一个无限循环中运行，确保LED保持亮。

### 汇编语言代码实现

```asm
#include <xc.inc>

    psect   init, class=CODE, delta=2
    psect   end_init, class=CODE, delta=2
    psect   powerup, class=CODE, delta=2
    psect   cinit,class=CODE,delta=2
    psect   functab,class=ENTRY,delta=2
    psect   idloc,class=IDLOC,delta=2,noexec
    psect   eeprom_data,class=EEDATA,delta=2,space=3,noexec
    psect   intentry, class=CODE, delta=2
    psect   reset_vec, class=CODE, delta=2

    global _main, reset_vec, start_initialization

psect config, class=CONFIG, delta=2
    dw  0xDFEC
    dw  0xF7FF
    dw  0xFFBF
    dw  0xEFFE
    dw  0xFFFF

psect reset_vec
reset_vec:
    ljmp    _main

psect cinit
start_initialization:

psect   CommonVar, class=COMMON, space=1, delta=1
charcase: ds 1h

psect intentry
intentry:
    retfie

psect   main,class=CODE,delta=2

global _main
_main:

; 配置RB0引脚为输出
    bcf STATUS, RP0         ; 选择BANK 0
    clrf PORTB              ; 清空PORTB寄存器
    bsf STATUS, RP0         ; 选择BANK 1
    bcf TRISB, 0            ; 设置RB0为输出
    bcf STATUS, RP0         ; 回到BANK 0

; 点亮RB0引脚上的LED
    bsf PORTB, 0            ; 设置RB0为高电平，点亮LED

; 死循环保持LED亮
loop:
    goto loop

end reset_vec
```

### 代码详解

1. **包含头文件**：
   ```asm
   #include <xc.inc>
   ```
   包含头文件以使用XC编译器的预定义宏和寄存器定义。

2. **定义程序段**：
   ```asm
   psect   init, class=CODE, delta=2
   ...
   psect   reset_vec, class=CODE, delta=2
   ```
   定义了不同的程序段，用于代码组织和存储。

3. **声明全局变量和复位向量**：
   ```asm
   global _main, reset_vec, start_initialization
   ```
   声明全局符号，使它们在其他文件中可见。

4. **配置位定义**：
   ```asm
   psect config, class=CONFIG, delta=2
   dw  0xDFEC
   ...
   dw  0xFFFF
   ```
   定义配置位，具体配置根据芯片的需求和应用而定。

5. **复位向量**：
   ```asm
   psect reset_vec
   reset_vec:
       ljmp    _main
   ```
   定义复位向量，在复位时跳转到`_main`函数。

6. **配置GPIO引脚为输出**：
   ```asm
   bcf STATUS, RP0         ; 选择BANK 0
   clrf PORTB              ; 清空PORTB寄存器
   bsf STATUS, RP0         ; 选择BANK 1
   bcf TRISB, 0            ; 设置RB0为输出
   bcf STATUS, RP0         ; 回到BANK 0
   ```
   选择合适的BANK来访问TRISB和PORTB寄存器，设置RB0为输出。

7. **点亮LED**：
   ```asm
   bsf PORTB, 0            ; 设置RB0为高电平，点亮LED
   ```
   将RB0设置为高电平，点亮连接到该引脚的LED。

8. **死循环保持LED亮**：
   ```asm
   loop:
       goto loop
   ```
   进入死循环，保持LED亮。

### 总结

这个实验通过配置GPIO引脚为输出并设置其电平，实现了控制LED的亮灭。汇编语言代码详细展示了如何使用指令配置和控制PIC16(L)F18854的引脚，从而实现对硬件的直接控制。通过这个实验，你可以更好地理解微控制器的基本操作和汇编语言的应用。