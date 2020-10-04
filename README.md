# UAV-HiRAP-Matlab
The standard alone version coded by matlab

![](imgs/splash.png)

Please download the executable file and User manual in "releases"

>  请从“release”中下载可运行文件

# Data Structure (draft usage)

List (Cell)

|      | ParListBox        | PicListBox | Kind | OnOff  |
| ---- | ----------------- | ---------- | ---- | ------ |
| type | str               | str        |      | strcut |
| 1    | ‘并行包1’存放图片 |            | 1    |        |
| 2    | ‘picname’大图切片 |            | 0    |        |
| 3    |                   |            |      |        |

存放图片，set(handles.PicLIstBox,’enable’,’on’)

PiclistBox里面，每点一幅图都在axes1里面显示

 

大图切片，set(handles.PicLIstBox,’enable’,’off’)

 

PicListBox(Cell)

|      | Filename | pathname | Mask |
| ---- | -------- | -------- | ---- |
| type | str      | str      | M*N  |
| 1    |          |          |      |
| 2    |          |          |      |

Pic2mat在进行计算的时候，再分别导入图片，转化完毕后在进行class分类

 

SlicePicListBox

|      | Filename    | pathname    | mask |      |
| ---- | ----------- | ----------- | ---- | ---- |
| type | preview.str | preview.str | -    |      |
| 1    | 1_1.str     | 1_1.str     |      |      |

 

OnOff(struct)

OnOff.Pic

​        OnOff.PicRead

​               OnOff.WorkPan

​        OnOff.PicClass

​        OnOff.PicNoise

OnOff.Tree

​        OnOff.TreeOpen(默认打开)

​        OnOff.TreeTraining

​               OnOff.PicCtrlPan

OnOff.Calcu

​        OnOff.DataPan