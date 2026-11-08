# AGENTS.md — th-dd 个人主页

> 给 AI 编码代理的项目说明。旧的 `PROJECT_GUIDE.md` 已整体过期，已删除；本文件是唯一事实来源。
> 事实核定：2026-11-08（改动与本文件在同一次提交里彼此对齐）。动手前先读本文，再读你要修改的文件本体。

## 这是什么

叹号大帝（th-dd）的个人主页，Astro 静态站：零后端、零数据库、零用户系统。
卡片式双栏布局 + 随机背景图 + 毛玻璃 + 中英双语 + 一言（Hitokoto）+ README 展示。

| 项 | 值 |
| --- | --- |
| 线上 | https://www.th-dd.top （GitHub Pages，自定义域名） |
| Gitee 镜像 | https://gitee.com/ya2/ya2 （`th-dd` → `ya2`） |
| 本地 dev | http://localhost:4520 |
| 本地 preview | http://localhost:4521 |
| 分支 | 只有 `main`，直接往 `main` 提交 |
| 许可 | MIT，© 2026 叹号大帝 |

技术栈固定，别换：Astro 7.4.7（`output: "static"`）、Vite 8.3.6、`@studiocms/ui` 1.2.2（卡片用它的组件与样式）、`@sipc.ink/tastro` 0.1.6（i18n）、`marked` 18.1.3、`sharp` 0.35.5。大版本 / 框架不换；补丁版本跟着 dependabot 走，改完顺手把这里的版本号同步。

## 硬约束

1. **只做最小改动**，跟现有写法对齐：源码注释是中文，新注释也用中文。
2. **不动技术选型**：不换框架、不引 CSS 框架 / 状态库 / 别的 UI 组件库、不上 SSR（`output` 保持 `static`）。
3. **卡片样式走变量**：高度、玻璃、圆角、边框全部用 `--bg-card` / `--border-color` 这些 CSS 变量；虚化强度同理走 `--bg-blur` / `--card-blur`，别写死 px。`index.astro` 里那段 `!important` 是压 studioCMS 主题用的，**别去掉**，去掉主题切换就失效。
4. **i18n 双语成对**：`src/i18n/zh.json` 与 `en.json` 键名必须完全一致，加一个键就两边一起加（缺键时另一语言渲染空）。键名被 `t()` 直接引用，别重命名。
5. **别动部署事实**：域名、`site`、Pages 设置、`GITEE_*` / `GH_PAT` 三个 secret 名、镜像映射关系。
6. **别把 token / 密钥写进代码**，只在 workflow 里用 `secrets.*`。
7. **文案保持口语**，别改写成书面语；「永远相信美好的事情即将发生」这类签名句别动。

## 目录地图

```
src/pages/index.astro      唯一页面：布局、全局 CSS、主题变量、主题切换脚本
src/cards/profile.astro    头像卡片（studioCMS 的 User 组件，头像 import 自 public/avatar.jpg 走 sharp）
src/cards/time.astro       实时时钟
src/cards/about.astro      关于我（del 旧签名 + content）
src/cards/Readme.astro     README 展示，构建期服务端抓取，带镜像回退与折叠
src/cards/Hitokoto.astro   一言，v1.hitokoto.cn
src/cards/footer.astro     页脚：年份 / 站点 / 字体 / 萌ICP备20261666号
src/cards/links.astro      社交链接按钮——**目前未启用**（见下）
src/i18n/{zh,en}.json      全部文案
src/assets/icon/*.svg      GitHub / Bilibili / QQ 图标
public/                    静态资源：字体、头像、favicon、game.webp、profile-night-green.svg（3D 贡献图）及其光栅版 .webp
.github/workflows/         astro.yml 部署 · push-gitee.yml 镜像 · update-gh-stats.yml 每日换图
astro.config.mjs           site / image(sharp) / studiocmsUi
wrangler.jsonc             Cloudflare Workers 部署配置（未接 adapter，见「现状缺口」）
```

## 布局

左栏 `Profile · Time · About`，右栏 `Readme · Hitokoto · Footer`；容器 `max-width: 768px`，`grid-template-columns: minmax(0,1fr) minmax(0,2fr)`，≤768px 折成单栏。卡片和网格项都带 `min-width: 0`，别去掉：README 里带 `width` 的图会把轨道撑宽、窄屏横向溢出。

README 卡片里的图：位图 `max-width: min(100%, 480px)`，游戏动图锁 420（源只有 420 宽，放大就糊），**3D 图在站点上用光栅版 `profile-night-green.webp`**（`width: 100%`、限高 420px），别换回 SVG：`<img>` 里的 SVG 每次重绘都要重新光栅化，实测滚动两秒主线程 **15,124ms**，光栅版 **~90ms**。README 给 GitHub 看的仍是 SVG。

选 **night-green** 而不是 night-rainbow 的原因：rainbow 的柱子配色全靠 `@keyframes` 色环动画、每个 `<rect>` 还带不同的 `animation-delay`（空间彩虹波），librsvg/rsvg 不跑 CSS 动画，光栅出来要么全黑、要么只能固化成单色/乱色；night-green 是纯静态 `fill`，光栅结果与 SVG 完全一致。
新增卡片：建 `src/cards/x.astro` → 根节点带 `glass-card` → 在 `index.astro` 对应 `column-left` / `column-right` 里 import 并使用。

## 现状缺口（别被误导）

- `links.astro` 是死代码：`index.astro` 第 3 行 import 与第 55 行 `<Links />` 都被注释掉了，页面上没有社交链接卡片。要恢复就取消那两处注释（`.link-btn` 的全局 CSS 还在 `index.astro` 里，能直接用）。
- `wrangler.jsonc` 指向 `dist/_worker.js/index.js`，但 `astro.config.mjs` 没装 `@astrojs/cloudflare`，纯静态构建**不产生** `_worker.js`。想走 Workers 得先加压入 adapter。
- 没有 `README_en.md`：英文 README 就是 `README.md`，中文是 `README_zh-cn.md`。
- 本地 `README*.md` 优先于所有镜像；镜像顺序 raw → `ghp.th-dd.top` 自建镜像 → gitee → jsDelivr，第 5 个 `raw.staticdn.net` 已注释（打不开）。
- 无 lint、无 test、无 formatter，也没有装 `@astrojs/check`。唯一的闸门是 `pnpm build`。
- 构建必刷 `Astro.request.headers` 警告，是既有状态，不是本次改动引入的（见「常用命令」）。

## 常用命令

```bash
pnpm install
pnpm dev      # 4520，带 HMR
pnpm build    # 必须 exit 0，等价于 CI 的构建步骤
pnpm preview  # 4521，验产物
```

提交前跑 `pnpm build`，别只靠 dev 的热更新看效果。构建成功只代表不报错，样式问题还得开页面看。

注意：`Readme.astro` 构建期**先读本地 `README*.md`**（内容永远与仓库一致，且不依赖网络），读不到才按镜像顺序 `fetch`。断网且本地缺文件时卡片才会渲染「加载失败」——别把这种情况当成改坏了。

构建会刷一串 `Astro.request.headers ... is not available on prerendered pages` 的 WARN：tastro 的 `useTastro(Astro.request)` 在静态页上拿不到请求头，语言回退到默认值，功能不受影响。**别为了消警告把 `output` 改成 `server`**。

## 实现约定要点

- **主题**：深色默认，`html.light` 切浅色，选择存 `localStorage.theme`（只认 `"light"`）。变量定义在 `index.astro` 的 `:root` 和 `:root.light`，两者的键必须一一对应。
- **字体**：`AaCute`，页面加载子集化后的 `public/AaCute.woff2`（约 1.7 MB，限 GB2312 常用字 + ASCII + 标点），`public/AaCute.ttf`（11.6 MB，全字集）只作老浏览器兜底与子集化源文件，别删。`@font-face` 在 `index.astro` 的 `is:global` 样式里。**别给 woff2 加 preload**：1.7 MB 的预载会抢在 CSS 前面，实测首屏 FCP 从 ~248ms 涨到 300–700ms，用 `font-display: swap` 让它自己二次进场更划算。改了文案出现生僻字要重新子集化：`pyftsubset public/AaCute.ttf --text-file=<字符集文件> --flavor=woff2 --output-file=public/AaCute.woff2 --no-hinting --desubroutinize`。页脚 `footer.font` 链接指向 MiSans 官网（小米澎湃字体）。
- **背景**：`https://api.yppp.net/api`，`.background-image` 铺满 + `--bg-blur` 虚化（配 `scale(1.02)` 盖住模糊露边）+ `.background-overlay` 遮罩。卡片玻璃单独走 `--card-blur`（比背景低，省合成）。接口挂了就只剩深色底，不是代码 bug。
- **一言**：`https://v1.hitokoto.cn`，按钮为复制 / 换一条。
- **语言**：`initTastro({ defaultLang: "zh", languages: { en, zh } })` 在 `index.astro`，`<title>` 按 `lang` 切换（zh 叹号大帝 / en thdd）。tastro 用 cookie `lang`，控制台 `window.setLang("en")` 可强切。
- **折叠状态**：README 折叠存 `localStorage.readme-collapsed`，点整条 header 也会触发切换。
- **页脚**：萌ICP备 20261666 的链接全站只有这一处，别删。
- **public/.assetsignore** 目前只列了 `_worker.js`、`_routes.json`，是给 Workers 部署排除用的。

## 工作流与部署

- `astro.yml`：push 到 `main` 或手动触发 → `pnpm install` + `pnpm astro build --site/--base`（取 Pages 输出）→ 上传产物 → 部署 Pages。Node 24 + pnpm 11，与 CI 保持一致，别随手升。
- `push-gitee.yml`：push / 每日 UTC 16:00 / 手动 → `Yikun/hub-mirror-action` 把 `th-dd`（→`ya2`）和 `thTag/docs` 镜像到 Gitee。
- `update-gh-stats.yml`：每日 UTC 16:00 → 用 `gh-space-shooter` 生成 `public/game.webp`、用 `github-profile-3d-contrib` 生成 `public/profile-*.svg`，然后自动提交。**这两个文件是机器产物，别手改**。
- 生成完还有一步 **光栅化 3D 图**：`rsvg-convert` + Pillow 把 `public/profile-night-green.svg` 转成同图 `profile-night-green.webp`（900 宽），站点卡片用光栅版，原因见「实现约定要点」。这步**没有** `continue-on-error`：失败就让整个 job 失败、不提交，避免「新 SVG 配旧光栅图」；步骤开头先删旧 webp，失败时站点退回 SVG。Pillow 固定版本。
- 同一步里还有 **Pillow 压缩**：把 `game.webp` 重编码到 420 宽、q50，帧数/时长/策略不动（860 宽 6.4 MB → 420 宽 2.0 MB）。三条硬约束：① 只能用 Pillow，**别换 sharp**——libwebp 编码器有 16383 px 高度上限，1561 帧的竖条会被它判 `Processed image is too large`；② Pillow 读不到 webp 的逐帧 duration，脚本里默认写死 25 ms（=40fps），**改 `fps` 输入时要同步改这个默认值**；③ 压完若不到原来的 90% 就丢弃压缩结果、保留原图，步骤带 `continue-on-error`，压缩失败不许阻断每日更新。
- `.github/dependabot.yml`：每周给 npm 和 github-actions 各开一组 PR（已分组降噪）。**没有自动合并 workflow**，PR 需要人合并；合并后若 `pnpm-lock.yaml` 冲突，重新 `pnpm install` 生成再提交。

## 提交规范

Conventional Commits + 中文描述，例如 `fix: 修正浅色模式边框`、`chore: 更新依赖`。历史用过的前缀：`feat:` / `fix:` / `chore:` / `docs:`。一次提交只做一件事。

## 已知待办

1. 社交链接卡片是否恢复（`links.astro`）。
2. `wrangler.jsonc` 要不要真正接上 `@astrojs/cloudflare`，还是删掉。
3. 补 lint / 类型检查（`@astrojs/check`），把闸门从「能构建」提到「能过检」。
