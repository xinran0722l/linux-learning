## pyecharts

如果想要做出数据可视化效果图，可以借助pyecharts模块完成

[pytecharts画廊链接](https://gallery.pyecharts.org)

#### 折线图

```py
#导入Line功能构建折线图对象
from pyecharts.charts import Line

#得到折线图对象
line = Line()

#添加x轴数据
line.add_xaxis(["China","USA","England"])

#添加y轴数据
line.add_yaxis("GDP",[30,20,10])

#设置全局配置项
line.set_global_opts(
    title_opts = TitleOpts(title="GDP展示",pos_left="center",pos_bottom="1%"),
    legend_opts = LegendOpts(is_show=True),
    toolbox_opts = ToolboxOpts(is_show=True),   #工具箱(右上)
    visualmap_opts = VisualMapOpts(is_show=True)    #视觉显示(左下)
)

#生成图表,运行成功后，会在./下出现html文件
line.render()
```
- 未使用```set_global_opts```全局配置前的折线图
![line_chart](../images/python/chart/line_chart.png)

- 使用```set_global_opts```全局配置后的折线图
![line_chart_global](../images/python/chart/line_chart_setglobal.png)
 
