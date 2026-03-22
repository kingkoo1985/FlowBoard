# FlowBoard 设计指南

与 OpenClaw Gateway Dashboard 保持 UI 一致性的参考指南。

## 设计系统起源

FlowBoard 遵循 **OpenClaw Gateway Dashboard** 的设计语言。
Gateway 使用编译的 SPA (control-ui)，配备 Lucide 图标、CSS 自定义属性和暗色优先方法。FlowBoard 在原生 CSS + JS 模块中镜像这些模式。

## 排版

| Token | 值 |
|-------|-------|
| `--font-body` | Space Grotesk，系统回退字体 |
| `--mono` | JetBrains Mono，系统等宽字体 |
| Display weight | 600–700 |
| Body weight | 400–500 |
| Mono weight | 400–500 |

## 色彩调色板

### 核心色

| Token | 值 | 用途 |
|-------|-------|-------|
| `--bg` | `#12141a` | 页面背景 |
| `--bg-elevated` | `#1a1d25` | 悬浮表面 |
| `--bg-hover` | `#262a35` | 悬停状态 |
| `--card` | `#181b22` | 卡片背景 |
| `--text` | `#e4e4e7` | 主要文本 |
| `--text-strong` | `#fafafa` | 标题、强调 |
| `--muted` | `#71717a` | 次要文本、图标 |
| `--border` | `#27272a` | 默认边框 |
| `--border-strong` | `#3f3f46` | 悬停边框 |

### 强调色

| Token | 值 | 用途 |
|-------|-------|-------|
| `--accent` | `#ff5c5c` | 主要强调色（OpenClaw 红） |
| `--accent-hover` | `#ff7070` | 强调色悬停 |
| `--accent-subtle` | `rgba(255, 92, 92, 0.15)` | 强调色背景 |
| `--accent-2` | `#14b8a6` | 次要强调色（青色） |

### 语义色

| Token | 值 | 用途 |
|-------|-------|-------|
| `--ok` | `#22c55e` | 成功、低优先级 |
| `--ok-subtle` | `rgba(34, 197, 94, 0.12)` | 成功背景 |
| `--warn` | `#f59e0b` | 警告、中优先级 |
| `--warn-subtle` | `rgba(245, 158, 11, 0.12)` | 警告背景 |
| `--danger` | `#ef4444` | 错误、高优先级 |
| `--danger-subtle` | `rgba(239, 68, 68, 0.12)` | 错误背景 |
| `--info` | `#3b82f6` | 信息状态 |

## 边框圆角

| Token | 值 | 用途 |
|-------|-------|-------|
| `--radius-sm` | `6px` | 小元素（药丸、徽章） |
| `--radius` / `--radius-md` | `8px` | 默认（卡片、输入框） |
| `--radius-lg` | `12px` | 大容器 |
| `--radius-full` | `9999px` | 完全圆角（药丸、圆点） |

## 图标

**库：** Lucide (https://lucide.dev)
**风格：** 基于描边，与 Gateway Dashboard 一致。

| 属性 | 值 |
|----------|-------|
| ViewBox | `0 0 24 24` |
| 渲染大小 | 14–18px（视上下文而定） |
| Fill | `none` |
| Stroke | `currentColor` |
| Stroke width | `1.5px` |
| Stroke linecap | `round` |
| Stroke linejoin | `round` |

### 图标模板
```html
<svg width="14" height="14" viewBox="0 0 24 24" fill="none"
  stroke="currentColor" stroke-width="1.5"
  stroke-linecap="round" stroke-linejoin="round">
  <path d="..."/>
</svg>
```

### 使用中的图标
- **删除：** 垃圾桶图标（14px，在任务卡片中）
- **规格文件：** 文本文件图标（14px，在任务元数据中）
- **添加规格：** 文件加号图标（14px，悬停时显示为幽灵状态）

## 按钮

### 标准按钮
```css
padding: 6px 10px; /* btn-sm */
font-size: 11px;
border-radius: var(--radius);
```

### 图标按钮（Gateway：`.btn--icon`）
```css
width: 26–36px; height: 26–36px;
display: inline-flex; align-items: center; justify-content: center;
border: 1px solid var(--border);
background: #ffffff0f;
border-radius: var(--radius-sm);
```
悬停：`background: #ffffff1f; border-color: var(--border-strong);`

### 幽灵按钮
默认状态：透明、不可见。
悬停：微妙边框 + 背景渐显。
用于：卡片上的添加操作（在父元素悬停时出现）。

## 卡片

```css
background: var(--card);
border: 1px solid var(--border);
border-radius: var(--radius);
```
悬停：`border-color: var(--border-strong);`

## 药丸 / 徽章

```css
padding: 4px 10px;
border-radius: var(--radius-full);
font-size: 11px;
font-weight: 500;
```
使用语义色表示优先级药丸（`--ok`、`--warn`、`--danger` + subtle bg）。

## 交互模式

### 悬停
- 卡片：边框颜色过渡到 `--border-strong`
- 按钮：背景移动（`#ffffff0f` → `#ffffff1f`）
- 幽灵元素：不透明度渐显（0 → 0.5 → 1）
- 过渡：`var(--duration-fast)`（150ms）

### 弹出框
```css
position: absolute;
width: max-content;
background: var(--card);
border: 1px solid var(--border);
border-radius: var(--radius);
box-shadow: 0 12px 28px rgba(0,0,0,.35);
z-index: 100;
animation: popIn var(--duration-fast);
```

### 通知消息
位置：右下角。3 秒后自动关闭。
类型：info（默认）、success（绿色）、error（红色）。

## 滚动条

自定义滚动条实现（`.cscroll-*` 类）。
轨道：透明。滑块：`var(--border)`，悬停：`var(--border-strong)`。
宽度：8px。边框圆角：完全圆角。

## 响应式

断点：`900px`
- 以下：折叠项目侧边栏，隐藏文件树
- 移动端：单列布局

## 语言

**所有 UI 文本使用英语** — 标签、按钮、通知、占位符、标签页名称。
项目内容（任务、规格、文档）可以使用任何语言。

## 共享组件（`utils.js`）

所有可复用的 UI 组件位于 `js/utils.js`。模块按需导入。

### ICONS
中心 SVG 图标注册表。所有图标遵循 Lucide 模板（14px，基于描边）。

```js
import { ICONS } from './utils.js';
// ICONS.trash — 垃圾桶/删除图标
```

**添加新图标：** 将图标添加到 utils.js 中的 `ICONS` 对象。使用 https://lucide.dev 上的 Lucide SVG，并使用上方图标部分的模板。

### renderDeleteBtn(onclick, title)
渲染一致的删除按钮，带有垃圾桶图标。使用 `.delete-btn` CSS 类（不透明度 0，在父元素悬停时显示，悬停时显示红色）。

```js
import { renderDeleteBtn } from './utils.js';
renderDeleteBtn("window.handleDelete('id')", '删除项目')
```

### toast(message, type)
右下角通知。类型：`'info'`（默认）、`'success'`、`'error'`。3 秒后自动关闭。

### showModal(title, body, onConfirm, confirmLabel, confirmClass)
确认对话框，带有遮罩层。点击取消、Escape 或遮罩层时关闭。用于破坏性操作，而不是使用 `confirm()`。

### 新组件约定
- **共享 UI 助手** → `utils.js`（按钮、模态框、图标、格式化器）
- **模块特定渲染** → 保留在 `kanban.js` 或 `file-explorer.js` 中
- **经验法则：** 如果两个模块需要相同的 UI 元素 → 提取到 utils.js

---

*基于 OpenClaw Gateway Dashboard (control-ui)，分析日期 2026-02-19。更新日期 2026-02-26。*
