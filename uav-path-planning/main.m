% 主函数

% 读取CSV文件中的数据
data = readmatrix('random_points.csv'); % 读取整个文件
data = data(2:end, :); % 跳过表头

% 设置K-means算法的参数
n_UAV = 6; % 默认分成6组

% 执行K-means聚类
[idx, C] = kmeans_clustering(data, n_UAV);

% 执行遗传算法路径规划
[bestPaths, bestCosts] = genetic_algorithm(data, idx, n_UAV);

% 绘制综合路径图
figure;
hold on;
colors = lines(n_UAV);
for k = 1:n_UAV
    clusterPoints = data(idx == k, :);
    bestPath = bestPaths{k};
    plot(clusterPoints(bestPath, 1), clusterPoints(bestPath, 2), '-o', 'Color', colors(k, :));
    plot(clusterPoints(bestPath(1), 1), clusterPoints(bestPath(1), 2), 'ro'); % 起点
end
title('Optimal Paths for All Clusters');
xlabel('X');
ylabel('Y');
hold off; 