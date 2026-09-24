# GitHub Pages + Supabase 部署说明

## 1. 创建 Supabase 项目

在 Supabase 新建项目，然后打开 SQL Editor，执行 `supabase-schema.sql`。

## 2. 创建评价人登录

在 Authentication → Users 中创建五个用户。建议邮箱使用：

- gzx@example.com（高泽雄）
- lsx@example.com（林少雄）
- ccr@example.com（蔡灿嵘）
- wsy@example.com（吴世友）
- cbh@example.com（陈炳煌）

正式版不建议继续使用“姓名 + 固定密码”作为公网认证方式。

## 3. 配置前端

复制 `supabase-config.example.js` 为 `supabase-config.js`，填写 Project URL 和 anon public key。不要提交 service_role key。

## 4. 发布 GitHub Pages

将网页和配置文件推送到 GitHub 仓库，在仓库 Settings → Pages 中选择 `Deploy from a branch`，选择 `main` 和 `/root`，保存后等待 GitHub Pages 发布。

## 5. 安全说明

Supabase 的 RLS 规则必须启用。评价数据由 Supabase 保存，GitHub Pages 只负责托管网页。若需要严格的“每位评价人只能查看自己的数据”或管理员汇总，需要再配置 Supabase Auth 用户元数据和更细的 RLS 策略。
