% 水桶排水问题 - 第一部分
% 桶底面直径: 2m, 高度: 3m
% 孔的直径: 2cm = 0.02m
% 水流速度: v = sqrt(2*g*h), g = 9.8 m/s^2
% 求水面高度与时间的关系

clear all;
close all;
clc;

% 参数设置
D = 2;           % 桶的直径 (m)
H0 = 3;          % 初始水面高度 (m)
d = 0.02;        % 孔的直径 (m)
g = 9.8;         % 重力加速度 (m/s^2)

% 计算面积
A_bucket = pi * (D/2)^2;     % 桶的底面积 (m^2)
A_hole = pi * (d/2)^2;       % 孔的面积 (m^2)

% 根据连续性方程: A_bucket * dh/dt = -A_hole * v
% 其中 v = sqrt(2*g*h)
% 所以: dh/dt = -(A_hole/A_bucket) * sqrt(2*g*h)
% 令 k = A_hole/A_bucket * sqrt(2*g)
k = (A_hole/A_bucket) * sqrt(2*g);

% 微分方程: dh/dt = -k * sqrt(h)
% 分离变量: dh/sqrt(h) = -k * dt
% 积分: 2*sqrt(h) = -k*t + C
% 初始条件: t=0 时 h=H0, 得 C = 2*sqrt(H0)
% 所以: sqrt(h) = sqrt(H0) - k*t/2
% h(t) = (sqrt(H0) - k*t/2)^2

% 计算水完全流出所需时间
t_empty = 2 * sqrt(H0) / k;

% 时间数组
t = linspace(0, t_empty, 1000);

% 计算高度
h = (sqrt(H0) - k*t/2).^2;

% 绘图
figure('Position', [100, 100, 800, 600]);
plot(t, h, 'b-', 'LineWidth', 2);
grid on;
xlabel('时间 (秒)', 'FontSize', 12);
ylabel('水面高度 (米)', 'FontSize', 12);
title('水桶排水 - 水面高度随时间变化', 'FontSize', 14);

% 添加关键信息
text_str = sprintf('桶直径: %.2f m\n桶高度: %.2f m\n孔直径: %.2f m\n排空时间: %.2f 秒 (%.2f 分钟)', ...
                   D, H0, d, t_empty, t_empty/60);
annotation('textbox', [0.15, 0.7, 0.3, 0.2], 'String', text_str, ...
           'FitBoxToText', 'on', 'BackgroundColor', 'white', 'EdgeColor', 'black');

% 保存图形
saveas(gcf, 'water_tank_part1.png');

% 显示结果
fprintf('===== 水桶排水问题 - 第一部分 =====\n');
fprintf('桶的直径: %.2f m\n', D);
fprintf('桶的高度: %.2f m\n', H0);
fprintf('孔的直径: %.4f m (%.2f cm)\n', d, d*100);
fprintf('桶的底面积: %.6f m^2\n', A_bucket);
fprintf('孔的面积: %.8f m^2\n', A_hole);
fprintf('系数 k: %.6f\n', k);
fprintf('水完全流出时间: %.2f 秒 (约 %.2f 分钟)\n', t_empty, t_empty/60);
fprintf('\n高度与时间的关系式:\n');
fprintf('h(t) = (sqrt(%.2f) - %.6f * t / 2)^2\n', H0, k);
fprintf('     = (%.4f - %.6f * t)^2\n', sqrt(H0), k/2);
fprintf('\n图形已保存为: water_tank_part1.png\n');
