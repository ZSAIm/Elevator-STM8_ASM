# ElevatorController-STM8S_ASM
基于STM8S使用汇编编写的电梯运行模拟控制器。


# 关于项目

## 项目说明
该项目是大三时的STM8S单片机课程设计任务。


## 题目要求
> 题目四：电梯运行模拟控制器
>
> 设计一个电梯运行模拟控制器，其系统框图如图4所示：
>
> 图4 电梯运行模拟控制器框图
>
> * 2个灯显示当前电梯运行方向。
> * 8个LED灯显示电梯所处楼层。
> * 1位七段数码管，3个LED灯（显示当前电梯所处楼层与运行方向以及电梯门的状态）
> * 键盘以及对应的LED灯（1－8，开门，关门）每个数字按键对应一个LED灯，按下按键灯亮，执行完命令灯灭)
> * 8×2－2＝14个按键表示每层楼入口的电梯按键
>
>（以上是框图所包含内容）
>                      
> 功能要求：能够模拟控制一个8层楼梯的电梯的运行。具体要求如下：
>
> 1. 电梯平时没有接到命令时候或者执行完命令后停在1楼，门关闭.。
> 2. 电梯运行速度2秒一层楼
> 3. 电梯门在开启的情况下没有收到命令10秒中后自动关闭。在运动中门必须关闭，（最后3秒可以设置音响警告信号）
> 4. 一句话，电梯控制器满足实际电梯的运行要求，电梯在运行的时候可以最多记住8个命令。并且综合考虑公平性（先按键先执行）和有效性（完成任务的总的行走路径最短）来执行。
>
> 要求完成的内容：
> 1. 完成硬件电路的设计与安装调试（可借助单片机实验电路板），并用CAD软件画出原理电路图。
> 2. 画出流程图，编写并调试驱动程序。
> 3. 撰写设计报告。


## 成品图

![成品图](https://raw.githubusercontent.com/ZSAIm/ElevatorController-STM8S_ASM/master/Images/DebugProduct.jpg)