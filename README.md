# SSGC 每周工作评价

GitHub Pages + Supabase 的每周工作评价网页。

## 文件

- `index.html`：前端页面
- `supabase-schema.sql`：Supabase 数据库表和 RLS 初始脚本
- `supabase-config.example.js`：前端安全配置模板
- `DEPLOY.md`：部署说明

## 安全

不要提交 Supabase `service_role` 或 Secret key。GitHub Pages 前端只能使用 publishable/anon key。
