import csv
import random

# 定义生成的点的数量
num_points = 100

# 定义x和y的范围
x_range = (1, 100)
y_range = (1, 100)

# 生成随机点
points = [(random.randint(*x_range), random.randint(*y_range)) for _ in range(num_points)]

# 写入CSV文件
with open('random_points.csv', mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['x', 'y'])  # 写入表头
    writer.writerows(points)     # 写入点数据

print("CSV文件 'random_points.csv' 已成功创建。") 