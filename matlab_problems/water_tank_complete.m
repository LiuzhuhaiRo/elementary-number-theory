% 水桶排水问题 - 完整解决方案
% 
% 问题描述:
% 现有一满桶水，桶底面直径为2m，高3m. 
% 现在其底面圆心处开一圆形小孔，直径为2cm，
% 设水流出的速度v与水的高度h之间的关系为v=sqrt(2gh)，
% 其中g=9.8m/s^2
% 
% (1) 求这桶水水面高度与时间的关系，并给出图示
% (2) 若在开孔的同时，从桶口以500cm^3/s的速度注水，求水面高度变化的规律
%
% 作者: MATLAB 解决方案
% 日期: 2025

clear all;
close all;
clc;

fprintf('================================================================\n');
fprintf('               水桶排水问题 - 完整解决方案\n');
fprintf('================================================================\n\n');

%% 参数设置
D = 2;           % 桶的直径 (m)
H0 = 3;          % 初始水面高度 (m)
d = 0.02;        % 孔的直径 (m)
g = 9.8;         % 重力加速度 (m/s^2)
Q_in = 500e-6;   % 注水速率 (500 cm^3/s = 500e-6 m^3/s)

% 计算面积
A_bucket = pi * (D/2)^2;     % 桶的底面积 (m^2)
A_hole = pi * (d/2)^2;       % 孔的面积 (m^2)

fprintf('问题参数:\n');
fprintf('  桶的直径: %.2f m\n', D);
fprintf('  桶的高度: %.2f m\n', H0);
fprintf('  孔的直径: %.4f m (%.2f cm)\n', d, d*100);
fprintf('  重力加速度: %.2f m/s^2\n', g);
fprintf('  桶的底面积: %.6f m^2\n', A_bucket);
fprintf('  孔的面积: %.8f m^2\n', A_hole);
fprintf('\n');

%% ============================================================
%% 第一部分: 仅排水（无注水）
%% ============================================================

fprintf('================================================================\n');
fprintf('第一部分: 仅排水（无注水）\n');
fprintf('================================================================\n\n');

% 推导过程:
% 根据连续性方程: A_bucket * dh/dt = -A_hole * v
% 其中 v = sqrt(2*g*h) (托里拆利定律)
% 因此: dh/dt = -(A_hole/A_bucket) * sqrt(2*g*h)
% 令 k = (A_hole/A_bucket) * sqrt(2*g)
% 得到微分方程: dh/dt = -k * sqrt(h)
%
% 分离变量: dh/sqrt(h) = -k * dt
% 积分: 2*sqrt(h) = -k*t + C
% 初始条件: t=0 时 h=H0, 得 C = 2*sqrt(H0)
% 因此: sqrt(h) = sqrt(H0) - k*t/2
% 最终解析解: h(t) = (sqrt(H0) - k*t/2)^2

k = (A_hole/A_bucket) * sqrt(2*g);
t_empty = 2 * sqrt(H0) / k;

fprintf('推导结果:\n');
fprintf('  系数 k = (A_hole/A_bucket) * sqrt(2*g) = %.6f\n', k);
fprintf('  水完全流出时间: %.2f 秒 (约 %.2f 分钟)\n', t_empty, t_empty/60);
fprintf('\n解析解:\n');
fprintf('  h(t) = (sqrt(%.2f) - %.6f * t / 2)^2\n', H0, k);
fprintf('       = (%.4f - %.6f * t)^2  米\n', sqrt(H0), k/2);
fprintf('\n');

% 计算数值解
t1 = linspace(0, t_empty, 1000);
h1 = (sqrt(H0) - k*t1/2).^2;

%% ============================================================
%% 第二部分: 排水 + 注水
%% ============================================================

fprintf('================================================================\n');
fprintf('第二部分: 排水 + 注水\n');
fprintf('================================================================\n\n');

fprintf('注水速率: %.6f m^3/s (%.2f cm^3/s)\n\n', Q_in, Q_in*1e6);

% 推导过程:
% A_bucket * dh/dt = Q_in - A_hole * v
% 其中 v = sqrt(2*g*h)
% 因此: dh/dt = Q_in/A_bucket - (A_hole/A_bucket) * sqrt(2*g*h)
% 令 a = Q_in/A_bucket, k = (A_hole/A_bucket) * sqrt(2*g)
% 得到微分方程: dh/dt = a - k * sqrt(h)
%
% 平衡状态 (dh/dt = 0):
% 0 = a - k * sqrt(h_eq)
% h_eq = (a/k)^2

a = Q_in / A_bucket;
h_eq = (a/k)^2;

fprintf('推导结果:\n');
fprintf('  系数 a = Q_in/A_bucket = %.8f m/s\n', a);
fprintf('  系数 k = %.6f (与第一部分相同)\n', k);
fprintf('  平衡高度 h_eq = (a/k)^2 = %.6f m\n', h_eq);
fprintf('\n微分方程:\n');
fprintf('  dh/dt = %.8f - %.6f * sqrt(h)\n', a, k);
fprintf('\n');

% 使用 ode45 求解微分方程
ode_func = @(t, h) a - k * sqrt(max(h, 0));
t_span = [0, 3000];
[t2, h2] = ode45(ode_func, t_span, H0);

% 分析
fprintf('分析:\n');
if h_eq < H0
    fprintf('  平衡高度 (%.4f m) < 初始高度 (%.2f m)\n', h_eq, H0);
    fprintf('  水面将从 %.2f m 逐渐下降到 %.4f m\n', H0, h_eq);
    fprintf('  原因: 注水速率 < 排水速率\n');
elseif h_eq > H0
    fprintf('  平衡高度 (%.4f m) > 初始高度 (%.2f m)\n', h_eq, H0);
    fprintf('  水面将从 %.2f m 逐渐上升到 %.4f m\n', H0, h_eq);
    fprintf('  原因: 注水速率 > 排水速率\n');
else
    fprintf('  平衡高度 (%.4f m) = 初始高度 (%.2f m)\n', h_eq, H0);
    fprintf('  水面将保持在 %.2f m\n', H0);
    fprintf('  原因: 注水速率 = 排水速率\n');
end
fprintf('\n');

%% ============================================================
%% 绘图
%% ============================================================

% 创建综合对比图
figure('Position', [100, 100, 1400, 900]);

% 子图1: 第一部分 - 仅排水
subplot(2, 2, 1);
plot(t1, h1, 'b-', 'LineWidth', 2);
grid on;
xlabel('时间 (秒)', 'FontSize', 11);
ylabel('水面高度 (米)', 'FontSize', 11);
title('第一部分: 仅排水', 'FontSize', 13, 'FontWeight', 'bold');
text_str1 = sprintf('排空时间: %.1f s\n(约%.1f分钟)', t_empty, t_empty/60);
text(t_empty*0.6, H0*0.7, text_str1, 'FontSize', 10, ...
     'BackgroundColor', 'white', 'EdgeColor', 'black');
ylim([0, H0*1.1]);

% 子图2: 第一部分 - 前100秒详细变化
subplot(2, 2, 2);
idx1 = t1 <= 100;
plot(t1(idx1), h1(idx1), 'b-', 'LineWidth', 2);
grid on;
xlabel('时间 (秒)', 'FontSize', 11);
ylabel('水面高度 (米)', 'FontSize', 11);
title('第一部分: 前100秒详细变化', 'FontSize', 13, 'FontWeight', 'bold');
ylim([min(h1(idx1))*0.95, H0*1.05]);

% 子图3: 第二部分 - 完整时间范围
subplot(2, 2, 3);
plot(t2, h2, 'b-', 'LineWidth', 2);
hold on;
plot(t2, ones(size(t2))*h_eq, 'r--', 'LineWidth', 1.5);
plot(t2, ones(size(t2))*H0, 'g--', 'LineWidth', 1);
grid on;
xlabel('时间 (秒)', 'FontSize', 11);
ylabel('水面高度 (米)', 'FontSize', 11);
title('第二部分: 排水+注水', 'FontSize', 13, 'FontWeight', 'bold');
legend('实际高度', '平衡高度', '初始高度', 'Location', 'best', 'FontSize', 9);
ylim([0, max(H0, h_eq)*1.1]);

% 子图4: 第二部分 - 前600秒详细变化
subplot(2, 2, 4);
idx2 = t2 <= 600;
plot(t2(idx2), h2(idx2), 'b-', 'LineWidth', 2);
hold on;
plot(t2(idx2), ones(sum(idx2),1)*h_eq, 'r--', 'LineWidth', 1.5);
plot(t2(idx2), ones(sum(idx2),1)*H0, 'g--', 'LineWidth', 1);
grid on;
xlabel('时间 (秒)', 'FontSize', 11);
ylabel('水面高度 (米)', 'FontSize', 11);
title('第二部分: 前600秒详细变化', 'FontSize', 13, 'FontWeight', 'bold');
legend('实际高度', '平衡高度', '初始高度', 'Location', 'best', 'FontSize', 9);
ylim([0, max(H0, h_eq)*1.1]);

% 添加总标题 (sgtitle 在某些版本的 Octave 中不可用，使用 axes 替代)
try
    sgtitle('水桶排水问题 - 完整解决方案', 'FontSize', 16, 'FontWeight', 'bold');
catch
    % 对于不支持 sgtitle 的版本，使用 annotation
    annotation('textbox', [0.35 0.97 0.3 0.03], 'String', '水桶排水问题 - 完整解决方案', ...
               'FontSize', 16, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
               'HorizontalAlignment', 'center');
end

% 保存图形
saveas(gcf, 'water_tank_complete.png');

fprintf('================================================================\n');
fprintf('结果已保存\n');
fprintf('================================================================\n');
fprintf('图形文件: water_tank_complete.png\n');
fprintf('\n程序运行完成！\n');
