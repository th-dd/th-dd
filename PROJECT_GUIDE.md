# th-dd 个人主页项目指南

> 本文档是 th-dd 个人主页项目的完整指南，面向用户、开发者和 AI 助手，帮助快速了解项目结构、使用方法、更新流程和贡献方式。

[English](#english-version) | 简体中文

---

## 📑 目录

- [项目简介](#项目简介)
- [快速开始](#快速开始)
- [技术栈](#技术栈)
- [项目结构](#项目结构)
- [核心组件说明](#核心组件说明)
- [国际化配置](#国际化配置)
- [主题系统](#主题系统)
- [字体配置](#字体配置)
- [背景与毛玻璃效果](#背景与毛玻璃效果)
- [README 显示组件](#readme-显示组件)
- [一言组件](#一言组件)
- [GitHub Actions 工作流](#github-actions-工作流)
- [部署配置](#部署配置)
- [使用指南](#使用指南)
- [更新指南](#更新指南)
- [贡献指南](#贡献指南)
- [常见问题](#常见问题)
- [许可证](#许可证)

---

## 项目简介

th-dd 是一个基于 Astro 构建的简洁个人主页项目，支持中英文国际化、深色/浅色模式切换、随机背景图片、毛玻璃效果、README 内容展示和一言随机句子等功能。

- **线上地址**：http://www.th-dd.top/
- **仓库地址**：https://github.com/th-dd/th-dd
- **Gitee 镜像**：https://gitee.com/ya2/ya2
- **许可证**：MIT License

---

## 快速开始

### 环境要求

- Node.js 24+
- pnpm 11+

### 安装与运行

```bash
# 克隆仓库
git clone https://github.com/th-dd/th-dd.git
cd th-dd

# 安装依赖
pnpm install

# 开发模式（访问 http://localhost:4321）
pnpm run dev

# 构建生产版本
pnpm run build

# 预览生产构建
pnpm run preview
```

---

## 技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| [Astro](https://astro.build) | ^6.4.8 | 静态站点生成器 |
| [@studiocms/ui](https://ui.studiocms.dev/) | ^1.2.0 | UI 组件库 |
| [@sipc.ink/tastro](https://github.com/SIPC/Tastro) | ^0.1.6 | 国际化工具 |
| [marked](https://marked.js.org/) | ^18.0.5 | Markdown 解析库 |
| [sharp](https://sharp.pixelplumbing.com/) | ^0.35.2 | 图片处理 |
| [Vite](https://vitejs.dev/) | ^8.0.16 | 构建工具 |
| [@astrojs/cloudflare](https://docs.astro.build/en/guides/integrations-guide/cloudflare/) | ^13.7.0 | Cloudflare 适配器（备用） |
| pnpm | 11+ | 包管理器 |

---

## 项目结构

```
th-dd/
├── .github/
│   └── workflows/
│       ├── astro.yml                    # Astro 构建部署到 GitHub Pages
│       ├── dependabot-auto-merge.yml    # Dependabot 自动合并 PR
│       ├── github-game.yml              # GitHub Game 每日更新
│       └── push-gitee.yml               # 推送代码到 Gitee 镜像
├── public/
│   ├── .assetsignore
│   ├── AaCute.ttf                       # 自定义字体文件
│   ├── avatar.jpg                       # 头像图片
│   ├── avatar-square.jpg                # 方形头像
│   ├── favicon.ico                      # 网站图标
│   └── favicon-black.ico                # 黑色图标
├── src/
│   ├── assets/
│   │   └── icon/
│   │       ├── github.svg               # GitHub 图标
│   │       ├── bilibili.svg             # Bilibili 图标
│   │       └── qq.svg                   # QQ 图标
│   ├── cards/                           # UI 卡片组件
│   │   ├── profile.astro                # 个人资料卡片
│   │   ├── time.astro                   # 时间卡片（紧凑版）
│   │   ├── about.astro                  # 关于我卡片
│   │   ├── links.astro                  # 链接卡片
│   │   ├── Readme.astro                 # README 显示组件
│   │   ├── Hitokoto.astro               # 一言组件
│   │   └── footer.astro                 # 页脚卡片
│   ├── i18n/                            # 国际化文件
│   │   ├── zh.json                      # 中文翻译
│   │   └── en.json                      # 英文翻译
│   └── pages/
│       └── index.astro                  # 主页入口
├── .gitattributes                       # Git 属性配置
├── .gitignore                           # Git 忽略配置
├── astro.config.mjs                     # Astro 配置
├── game.gif                             # GitHub Game 动图
├── LICENSE                              # MIT 许可证
├── package.json                         # 项目依赖
├── pnpm-lock.yaml                       # pnpm 锁文件
├── pnpm-workspace.yaml                  # pnpm 工作区配置
├── PROJECT_GUIDE.md                     # 本文档
├── README.md                            # 中文 README
├── README_en.md                         # 英文 README
├── tsconfig.json                        # TypeScript 配置
└── wrangler.jsonc                       # Cloudflare Workers 配置
```

---

## 核心组件说明

### 页面布局

页面采用双栏布局（电脑端）和单栏布局（手机端）：

```
电脑端布局：
┌─────────────┬──────────────────────┐
│  Profile    │                      │
│  Time       │      Readme          │
│  About      │      Hitokoto        │
│  Links      │      Footer          │
└─────────────┴──────────────────────┘

手机端布局：
┌─────────────┐
│  Profile    │
│  Time       │
│  About      │
│  Links      │
│  Readme     │
│  Hitokoto   │
│  Footer     │
└─────────────┘
```

### 组件清单

| 组件 | 文件 | 功能 |
|------|------|------|
| Profile | `src/cards/profile.astro` | 显示头像、昵称、描述 |
| Time | `src/cards/time.astro` | 实时显示当前时间（紧凑版） |
| About | `src/cards/about.astro` | 显示个人介绍 |
| Links | `src/cards/links.astro` | 显示社交链接按钮 |
| Readme | `src/cards/Readme.astro` | 显示 GitHub 仓库 README |
| Hitokoto | `src/cards/Hitokoto.astro` | 显示一言随机句子 |
| Footer | `src/cards/footer.astro` | 页脚，包含版权和备案信息 |

---

## 国际化配置

项目使用 `@sipc.ink/tastro` 进行国际化管理。

### 支持语言

- **简体中文** - 默认语言
- **English (en)** - 英语

### 语言切换机制

- 自动根据浏览器语言选择
- 通过 cookie 保存用户选择（`lang` 字段，有效期 1 年）
- 可在控制台调用 `window.setLang('en')` 或 `window.setLang('zh')` 切换

### 翻译文件位置

```
src/i18n/
├── zh.json    # 中文翻译
└── en.json    # 英文翻译
```

### 翻译文件结构

```json
{
  "profile": {
    "name": "叹号大帝",
    "description": "永远相信美好的事情即将发生"
  },
  "about": {
    "title": "关于我",
    "old": "一个喜欢折腾的人",
    "content": "喜欢研究 AI Agent 机器人..."
  },
  "links": { "title": "链接" },
  "time": { "title": "所在地时间" },
  "footer": {
    "site": "th-dd.top",
    "font": "MiSans"
  }
}
```

### 添加新语言

1. 在 `src/i18n/` 目录下创建新的 JSON 文件（如 `ja.json`）
2. 在 `src/pages/index.astro` 的 `initTastro` 配置中添加新语言
3. 重启开发服务器

---

## 主题系统

### 深色/浅色模式

项目支持深色和浅色两种主题模式。

### CSS 变量

```css
/* 深色模式（默认） */
:root {
    --bg-primary: #1a1a1a;
    --bg-card: rgba(20, 20, 20, 0.65);
    --bg-card-inner: rgba(40, 40, 40, 0.5);
    --text-primary: #ffffff;
    --text-secondary: #cccccc;
    --text-muted: #888888;
    --border-color: rgba(255, 255, 255, 0.1);
    --overlay-color: rgba(0, 0, 0, 0.15);
    --btn-bg: rgba(255, 255, 255, 0.1);
    --btn-text: #ffffff;
}

/* 浅色模式 */
:root.light {
    --bg-primary: #f0f0f0;
    --bg-card: rgba(255, 255, 255, 0.85);
    --bg-card-inner: rgba(230, 230, 230, 0.8);
    --text-primary: #1a1a1a;
    --text-secondary: #444444;
    --text-muted: #777777;
    --border-color: rgba(0, 0, 0, 0.1);
    --overlay-color: rgba(255, 255, 255, 0.3);
    --btn-bg: rgba(0, 0, 0, 0.08);
    --btn-text: #1a1a1a;
}
```

### 主题切换逻辑

- 通过点击右上角按钮切换
- 主题选择保存在 `localStorage` 的 `theme` 字段
- 通过 `html` 元素的 `light` class 控制主题

---

## 字体配置

### 当前字体

项目使用自定义字体 **AaCute**（位于 `public/AaCute.ttf`）。

### 字体定义

```css
@font-face {
    font-family: 'AaCute';
    src: url('/AaCute.ttf') format('truetype');
    font-weight: normal;
    font-style: normal;
    font-display: swap;
}

body {
    font-family: 'AaCute', -apple-system, BlinkMacSystemFont, sans-serif;
}
```

### 更换字体

1. 将新字体文件放入 `public/` 目录
2. 修改 `src/pages/index.astro` 中的 `@font-face` 定义
3. 修改 `font-family` 引用

---

## 背景与毛玻璃效果

### 背景图片

- **API 来源**：`https://api.yppp.net/api.php`
- **效果**：全屏固定背景，自动铺满覆盖
- **遮罩层**：半透明遮罩，提升文字可读性

### 毛玻璃效果

所有卡片组件使用毛玻璃效果：

```css
.glass-card {
    background: var(--bg-card) !important;
    backdrop-filter: blur(12px) !important;
    -webkit-backdrop-filter: blur(12px) !important;
    border-radius: 16px !important;
    border: 1px solid var(--border-color) !important;
}
```

---

## README 显示组件

### 功能

- 显示 GitHub 仓库的 README 内容
- 支持国际化（中文显示 `README.md`，英文显示 `README_en.md`）
- 使用 `marked` 库进行完整 Markdown 解析
- 多镜像源 fallback，解决国内访问问题

### 镜像源优先级

1. `https://cdn.jsdelivr.net/gh/th-dd/th-dd@main/` （jsdelivr CDN，国内可访问）
2. `https://gitee.com/ya2/ya2/raw/main/` （Gitee 镜像，国内可访问）
3. `https://raw.staticdn.net/th-dd/th-dd/main/` （staticdn 镜像）
4. `https://raw.githubusercontent.com/th-dd/th-dd/main/` （GitHub raw，需加速）

### 工作原理

1. 按优先级依次尝试每个镜像源
2. 每个源设置 5 秒超时
3. 成功获取后使用 `marked.parse()` 解析 Markdown
4. 所有源都失败时显示错误提示

---

## 一言组件

### 功能

- 调用 Hitokoto API 获取随机一言
- 显示一言内容和来源
- 支持刷新和复制功能

### API

- **接口**：`https://v1.hitokoto.cn`
- **文档**：https://developer.hitokoto.cn/sentence/

### 功能按钮

| 按钮 | 图标 | 功能 |
|------|------|------|
| 复制 | 📋 | 复制一言到剪贴板 |
| 刷新 | ↻ | 换一条一言 |

---

## GitHub Actions 工作流

### 1. astro.yml - 构建部署

- **触发**：push 到 main 分支
- **功能**：构建 Astro 站点并部署到 GitHub Pages
- **工具链**：pnpm 11 + Node.js 24
- **部署地址**：http://www.th-dd.top/

### 2. push-gitee.yml - Gitee 同步

- **触发**：push 到 main 分支
- **功能**：将代码同步到 Gitee 镜像
- **Gitee 地址**：https://gitee.com/ya2/ya2
- **依赖**：需要配置 `GITEE_SSH_KEY` secret

### 3. dependabot-auto-merge.yml - 依赖自动合并

- **触发**：Dependabot 创建的 PR
- **功能**：自动审批并合并 Dependabot 的 PR

### 4. github-game.yml - GitHub Game

- **触发**：每日定时（UTC 16:00）
- **功能**：更新 GitHub Game 动图
- **输出**：`game.gif`

---

## 部署配置

### Astro 配置 (`astro.config.mjs`)

```javascript
export default defineConfig({
  output: "static",           // 静态输出
  integrations: [studiocmsUi()],
  site: "https://www.th-dd.top",  // 站点地址
  image: {
    service: {
      entrypoint: 'astro/assets/services/sharp'  // 图片服务
    }
  }
});
```

### GitHub Pages 配置

- **构建类型**：GitHub Actions
- **自定义域名**：www.th-dd.top
- **HTTPS**：建议启用强制跳转

### Cloudflare 配置 (`wrangler.jsonc`)

- 用于 Cloudflare Workers 部署（备用方案）
- 兼容性日期：2026-01-04
- 启用 `nodejs_compat` 和 `global_fetch_strictly_public` 标志

---

## 使用指南

### 修改个人信息

1. **修改昵称和描述**：编辑 `src/i18n/zh.json` 和 `src/i18n/en.json` 中的 `profile` 字段
2. **修改关于我**：编辑 `about` 字段
3. **修改头像**：替换 `public/avatar.jpg` 文件

### 修改社交链接

编辑 `src/cards/links.astro`，修改链接地址和图标。

### 修改背景图片

编辑 `src/pages/index.astro`，修改 `.background-image` 的 `background-image` URL。

### 修改主题颜色

编辑 `src/pages/index.astro` 中的 CSS 变量（`:root` 和 `:root.light`）。

### 修改字体

1. 将字体文件放入 `public/` 目录
2. 修改 `src/pages/index.astro` 中的 `@font-face` 定义和 `font-family` 引用

---

## 更新指南

### 更新依赖

```bash
# 检查可更新的依赖
pnpm outdated

# 更新所有依赖
pnpm update

# 更新特定依赖
pnpm update astro
```

### 添加新组件

1. 在 `src/cards/` 目录下创建新的 `.astro` 文件
2. 使用 `glass-card` class 应用毛玻璃效果
3. 在 `src/pages/index.astro` 中导入并使用组件

### 添加新语言

1. 在 `src/i18n/` 目录下创建新的 JSON 文件
2. 在 `src/pages/index.astro` 的 `initTastro` 配置中添加新语言
3. 重启开发服务器

### 更新 README 显示内容

直接修改仓库根目录的 `README.md` 和 `README_en.md` 文件，页面会自动获取最新内容。

---

## 贡献指南

### 如何贡献

1. Fork 本仓库
2. 创建特性分支：`git checkout -b feature/your-feature`
3. 提交更改：`git commit -m 'Add some feature'`
4. 推送分支：`git push origin feature/your-feature`
5. 提交 Pull Request

### 代码规范

- 使用 TypeScript 严格模式
- 遵循 Astro 组件规范
- 保持代码简洁，添加必要注释
- 提交信息使用约定式提交格式（Conventional Commits）

### 提交信息格式

```
<type>: <description>

类型说明：
- feat: 新功能
- fix: 修复 bug
- docs: 文档更新
- style: 代码格式（不影响功能）
- refactor: 重构
- perf: 性能优化
- test: 测试相关
- chore: 构建工具或辅助工具变动
```

### 分支规范

- `main`：主分支，保持稳定可部署状态
- `feature/*`：特性分支
- `fix/*`：修复分支
- `docs/*`：文档分支

---

## 常见问题

### Q: README 显示不出来？

**A:** README 组件使用多镜像源 fallback，如果所有源都无法访问，会显示错误提示。请检查网络连接，或直接访问 GitHub 仓库查看。

### Q: 背景图片不显示？

**A:** 背景图片依赖 `https://api.yppp.net/api.php` API，如果该 API 不可用，背景会显示为默认深色。可以修改 `src/pages/index.astro` 中的背景图片 URL。

### Q: 一言获取失败？

**A:** 一言功能依赖 `https://v1.hitokoto.cn` API，如果该 API 不可用，会显示错误信息。点击刷新按钮重试。

### Q: 字体显示不正常？

**A:** 确认 `public/AaCute.ttf` 文件存在。如果更换字体，需要修改 `src/pages/index.astro` 中的 `@font-face` 定义。

### Q: 主题切换不生效？

**A:** 主题选择保存在 `localStorage` 中，清除浏览器缓存或使用隐私模式可能会重置主题。

### Q: 如何在本地开发？

**A:** 
```bash
pnpm install
pnpm run dev
```
访问 http://localhost:4321

### Q: 如何部署到自己的 GitHub Pages？

**A:**
1. Fork 本仓库
2. 修改 `astro.config.mjs` 中的 `site` 为你的域名
3. 在仓库 Settings → Pages 中选择 Source 为 GitHub Actions
4. 推送代码到 main 分支，自动触发部署

---

## 许可证

本项目基于 [MIT License](LICENSE) 开源。

Copyright (c) 2026 叹号大帝 (th-dd)

---

## English Version

### Project Overview

th-dd is a clean personal homepage built with Astro, supporting Chinese/English internationalization, dark/light mode, random background images, glassmorphism effects, README display, and random quotes (Hitokoto).

- **Live Site**: http://www.th-dd.top/
- **Repository**: https://github.com/th-dd/th-dd
- **Gitee Mirror**: https://gitee.com/ya2/ya2
- **License**: MIT License

### Quick Start

```bash
git clone https://github.com/th-dd/th-dd.git
cd th-dd
pnpm install
pnpm run dev    # Visit http://localhost:4321
```

### Tech Stack

- Astro 6.4.8+ (Static Site Generator)
- @studiocms/ui 1.2.0+ (UI Components)
- @sipc.ink/tastro 0.1.6+ (i18n)
- marked 18.0.5+ (Markdown Parser)
- sharp 0.35.2+ (Image Processing)
- pnpm 11+ (Package Manager)

### Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit changes: `git commit -m 'Add some feature'`
4. Push to branch: `git push origin feature/your-feature`
5. Submit a Pull Request

### License

MIT License - Copyright (c) 2026 叹号大帝 (th-dd)
