function [bestPaths, bestCosts] = genetic_algorithm(data, idx, n_UAV)
    % 遗传算法参数
    populationSize = 150;
    numGenerations = 300;
    initialMutationRate = 0.2;
    finalMutationRate = 0.05;
    eliteCount = 5;

    % 初始化结果存储
    bestPaths = cell(n_UAV, 1);
    bestCosts = zeros(n_UAV, 1);
    totalCosts = zeros(numGenerations, 1);
    clusterCosts = zeros(numGenerations, n_UAV);

    % 对每个聚类进行路径规划
    for k = 1:n_UAV
        clusterPoints = data(idx == k, :);
        numPoints = size(clusterPoints, 1);

        % 初始化种群
        population = zeros(populationSize, numPoints);
        for i = 1:populationSize
            population(i, :) = randperm(numPoints);
        end

        % 迭代遗传算法
        bestCost = inf;
        for gen = 1:numGenerations
            % 计算适应度
            costs = zeros(populationSize, 1);
            for i = 1:populationSize
                path = population(i, :);
                costs(i) = calculatePathCost(clusterPoints, path);
            end

            % 选择最优个体
            [minCost, minIdx] = min(costs);
            if minCost < bestCost
                bestCost = minCost;
                bestPath = population(minIdx, :);
            end

            % 累加总成本
            totalCosts(gen) = totalCosts(gen) + bestCost;
            clusterCosts(gen, k) = bestCost;

            % 精英保留
            [~, sortedIdx] = sort(costs);
            newPopulation = population(sortedIdx(1:eliteCount), :);

            % 选择、交叉和变异
            for i = eliteCount+1:2:populationSize
                % 选择父母
                parent1 = selectParent(population, costs);
                parent2 = selectParent(population, costs);

                % 多点交叉
                [child1, child2] = multiPointCrossover(parent1, parent2);

                % 自适应变异率
                diversity = std(costs) / mean(costs);
                mutationRate = initialMutationRate - (initialMutationRate - finalMutationRate) * (gen / numGenerations) * diversity;

                % 变异
                child1 = mutate(child1, mutationRate);
                child2 = mutate(child2, mutationRate);

                % 添加到新种群
                newPopulation = [newPopulation; child1; child2];
            end
            population = newPopulation(1:populationSize, :);
        end

        % 存储最优路径和成本
        bestPaths{k} = bestPath;
        bestCosts(k) = bestCost;

        % 输出每个聚类的遗传算法完成信息
        fprintf('Genetic algorithm completed for cluster %d with best cost: %.2f\n', k, bestCost);
    end

    % 绘制每个聚类的成本图
    figure;
    for k = 1:n_UAV
        subplot(2, 3, k);
        plot(1:numGenerations, clusterCosts(:, k), '-b');
        title(sprintf('Cluster %d Cost Over Generations', k));
        xlabel('Generation');
        ylabel('Cost');
    end

    % 输出总的最佳成本
    fprintf('Total best cost: %.2f\n', sum(bestCosts));

    % 绘制总成本图
    figure;
    plot(1:numGenerations, totalCosts, '-b');
    title('Total Cost Over Generations');
    xlabel('Generation');
    ylabel('Total Cost');
end

% 辅助函数：计算路径成本
function cost = calculatePathCost(points, path)
    cost = 0;
    for i = 1:length(path)-1
        cost = cost + norm(points(path(i), :) - points(path(i+1), :));
    end
    cost = cost + norm(points(path(end), :) - points(path(1), :)); % 回到起点
end

% 辅助函数：选择父母
function parent = selectParent(population, costs)
    idx = randsample(1:length(costs), 1, true, 1./costs);
    parent = population(idx, :);
end

% 辅助函数：多点交叉
function [child1, child2] = multiPointCrossover(parent1, parent2)
    n = length(parent1);
    points = sort(randperm(n-1, 2));
    child1 = [parent1(1:points(1)), setdiff(parent2, parent1(1:points(1)), 'stable')];
    child2 = [parent2(1:points(1)), setdiff(parent1, parent2(1:points(1)), 'stable')];
end

% 辅助函数：变异
function mutant = mutate(individual, mutationRate)
    mutant = individual;
    if rand < mutationRate
        idx = randperm(length(individual), 2);
        mutant(idx) = mutant(fliplr(idx));
    end
end 