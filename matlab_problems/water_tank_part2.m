% 水桶排水问题 - 第二部分
% 在排水的同时，以 500 cm^3/s 的速度从桶口注水
% 求水面高度变化的规律

clear all;
close all;
clc;

% 参数设置
D = 2;           % 桶的直径 (m)
H0 = 3;          % 初始水面高度 (m)
d = 0.02;        % 孔的直径 (m)
g = 9.8;         % 重力加速度 (m/s^2)
Q_in = 500e-6;   % 注水速率 (500 cm^3/s = 500e-6 m^3/s)

% 计算面积
A_bucket = pi * (D/2)^2;     % 桶的底面积 (m^2)
A_hole = pi * (d/2)^2;       % 孔的面积 (m^2)

% 微分方程: A_bucket * dh/dt = Q_in - A_hole * v
% 其中 v = sqrt(2*g*h)
% 所以: dh/dt = Q_in/A_bucket - (A_hole/A_bucket) * sqrt(2*g*h)
% 令 a = Q_in/A_bucket, k = (A_hole/A_bucket) * sqrt(2*g)
% dh/dt = a - k * sqrt(h)

a = Q_in / A_bucket;
k = (A_hole/A_bucket) * sqrt(2*g);

% 平衡高度 (dh/dt = 0 时的高度)
% 0 = a - k * sqrt(h_eq)
% sqrt(h_eq) = a/k
h_eq = (a/k)^2;

% 定义微分方程
ode_func = @(t, h) a - k * sqrt(max(h, 0));

% 使用 ode45 求解
t_span = [0, 3000];  % 时间范围 (秒)
[t, h] = ode45(ode_func, t_span, H0);

% 绘图
figure('Position', [100, 100, 1200, 500]);

% 子图1: 完整时间范围
subplot(1, 2, 1);
plot(t, h, 'b-', 'LineWidth', 2);
hold on;
plot(t, ones(size(t))*h_eq, 'r--', 'LineWidth', 1.5);
plot(t, ones(size(t))*H0, 'g--', 'LineWidth', 1);
grid on;
xlabel('时间 (秒)', 'FontSize', 12);
ylabel('水面高度 (米)', 'FontSize', 12);
title('水面高度随时间变化 (带注水)', 'FontSize', 14);
legend('实际高度', '平衡高度', '初始高度', 'Location', 'best');
ylim([0, max(H0, h_eq)*1.1]);

% 子图2: 前600秒的详细变化
subplot(1, 2, 2);
idx = t <= 600;
plot(t(idx), h(idx), 'b-', 'LineWidth', 2);
hold on;
plot(t(idx), ones(sum(idx),1)*h_eq, 'r--', 'LineWidth', 1.5);
plot(t(idx), ones(sum(idx),1)*H0, 'g--', 'LineWidth', 1);
grid on;
xlabel('时间 (秒)', 'FontSize', 12);
ylabel('水面高度 (米)', 'FontSize', 12);
title('前600秒的水面高度变化', 'FontSize', 14);
legend('实际高度', '平衡高度', '初始高度', 'Location', 'best');
ylim([0, max(H0, h_eq)*1.1]);

% 保存图形
saveas(gcf, 'water_tank_part2.png');

% 分析结果
fprintf('===== 水桶排水问题 - 第二部分 (带注水) =====\n');
fprintf('桶的直径: %.2f m\n', D);
fprintf('初始水面高度: %.2f m\n', H0);
fprintf('孔的直径: %.4f m (%.2f cm)\n', d, d*100);
fprintf('注水速率: %.6f m^3/s (%.2f cm^3/s)\n', Q_in, Q_in*1e6);
fprintf('桶的底面积: %.6f m^2\n', A_bucket);
fprintf('孔的面积: %.8f m^2\n', A_hole);
fprintf('\n系数:\n');
fprintf('a = Q_in/A_bucket = %.8f m/s\n', a);
fprintf('k = (A_hole/A_bucket) * sqrt(2*g) = %.6f\n', k);
fprintf('\n平衡高度 h_eq = (a/k)^2 = %.6f m\n', h_eq);
fprintf('\n分析:\n');
if h_eq < H0
    fprintf('平衡高度 (%.4f m) < 初始高度 (%.2f m)\n', h_eq, H0);
    fprintf('水面高度将从 %.2f m 逐渐下降到平衡高度 %.4f m\n', H0, h_eq);
    fprintf('说明: 注水速率小于排水速率，水位最终会稳定在较低位置\n');
elseif h_eq > H0
    fprintf('平衡高度 (%.4f m) > 初始高度 (%.2f m)\n', h_eq, H0);
    fprintf('水面高度将从 %.2f m 逐渐上升到平衡高度 %.4f m\n', H0, h_eq);
    fprintf('说明: 注水速率大于排水速率，水位最终会稳定在较高位置\n');
else
    fprintf('平衡高度 (%.4f m) = 初始高度 (%.2f m)\n', h_eq, H0);
    fprintf('水面高度将保持在初始高度 %.2f m\n', H0);
    fprintf('说明: 注水速率等于排水速率，水位保持不变\n');
end

% 找到达到平衡高度95%的时间
h_target = h_eq + 0.05 * abs(H0 - h_eq);
if H0 > h_eq
    idx_95 = find(h <= h_target, 1);
else
    idx_95 = find(h >= h_target, 1);
end
if ~isempty(idx_95)
    fprintf('\n达到接近平衡状态(误差<5%%)的时间: %.2f 秒 (约 %.2f 分钟)\n', t(idx_95), t(idx_95)/60);
end

fprintf('\n微分方程:\n');
fprintf('dh/dt = %.8f - %.6f * sqrt(h)\n', a, k);
fprintf('\n图形已保存为: water_tank_part2.png\n');

% 创建详细的时间-高度表格（前60秒，每5秒）
fprintf('\n===== 水面高度随时间变化表（前60秒）=====\n');
fprintf('时间(秒)\t高度(米)\t变化率(m/s)\n');
fprintf('----------------------------------------\n');
for i = 0:5:60
    [~, idx] = min(abs(t - i));
    if idx <= length(h) && idx > 1
        dh_dt = (h(idx) - h(idx-1)) / (t(idx) - t(idx-1));
        fprintf('%6.1f\t\t%.6f\t%.8f\n', t(idx), h(idx), dh_dt);
    elseif idx <= length(h)
        fprintf('%6.1f\t\t%.6f\t%.8f\n', t(idx), h(idx), a - k * sqrt(h(idx)));
    end
end
