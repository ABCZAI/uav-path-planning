function [idx, C] = kmeans_clustering(data, n_UAV)
    % 自定义K-means算法
    max_iters = 100; % 最大迭代次数
    [idx, C] = custom_kmeans(data, n_UAV, max_iters);
    fprintf('K-means clustering completed with %d clusters.\n', n_UAV);
end

function [idx, C] = custom_kmeans(data, k, max_iters)
    % 初始化聚类中心
    [num_points, num_features] = size(data);
    C = data(randperm(num_points, k), :);
    idx = zeros(num_points, 1);
    
    for iter = 1:max_iters
        % 分配每个点到最近的聚类中心
        for i = 1:num_points
            distances = sum((C - data(i, :)).^2, 2);
            [~, idx(i)] = min(distances);
        end
        
        % 更新聚类中心
        new_C = zeros(k, num_features);
        for j = 1:k
            cluster_points = data(idx == j, :);
            if ~isempty(cluster_points)
                new_C(j, :) = mean(cluster_points, 1);
            else
                new_C(j, :) = data(randi(num_points), :); % 重新随机选择一个点作为中心
            end
        end
        
        % 检查收敛
        if all(new_C == C)
            break;
        end
        C = new_C;
    end
end 