<h1 align="center">FlowBoard</h1>

<p align="center">
  <strong>AI 智能体项目工作空间。为 <a href="https://github.com/openclaw/openclaw">OpenClaw</a> 而构建。</strong>
</p>

<p align="center">
  <a href="https://github.com/rasimme/FlowBoard/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License"></a>
  <a href="https://github.com/rasimme/FlowBoard/releases"><img src="https://img.shields.io/badge/version-v4.0.0-orange.svg" alt="Version"></a>
  <a href="https://github.com/rasimme/FlowBoard"><img src="https://img.shields.io/github/stars/rasimme/FlowBoard?style=social" alt="Stars"></a>
</p>

<p align="center">
  <a href="#quick-start">快速开始</a> •
  <a href="#features">功能特性</a> •
  <a href="#-idea-canvas">创意画布</a> •
  <a href="#remote-access-telegram-mini-app">远程访问</a> •
  <a href="CHANGELOG.md">更新日志</a>
</p>

---

你的智能体每次会话都会丢失上下文。我在构建什么？我做了什么决策？下一个任务是什么？全都忘了。

**FlowBoard 解决这个问题。**

- **📂 按需获取项目上下文** — 激活项目，智能体立即获得目标、决策、任务和规格。懒加载以节省 token。
- **📋 双方使用的看板** — 智能体创建任务、编写规格、移动卡片、将工作拆解为子任务。你实时看到进度。
- **💡 创意画布** — 一起进行可视化头脑风暴。一键将连接的想法转换为带规格和子任务的任务。

![FlowBoard Kanban](docs/screenshot-kanban.png)

---

## 功能特性

### 📂 项目工作空间

激活项目，智能体立即获得所需的上下文 — 目标、范围、架构、决策、任务状态、规格。所有内容按需加载：智能体在需要时拉取所需内容，保持低 token 使用。在不同项目间切换而不丢失踪迹。

- 结构化工作空间：`PROJECT.md` → `DECISIONS.md` → `tasks.json` → `specs/`
- 懒加载 — 没有激活项目时零开销
- 会话交接 — 准确从中断处继续

### 📋 智能体原生看板

你的智能体通过 dashboard 使用的相同 REST API 操作看板。它创建任务、设置优先级、编写带验收标准的规格，并在工作时更新状态。

- 带工作流的任务：`open → in-progress → review → done`
- 带子任务和进度追踪的父任务
- 带验收标准和日志的规格文件
- 实时了解智能体在做什么

### 💡 创意画布

基于节点的头脑风暴空间。带连接的便签形成集群。一键将它们发送给你的智能体，智能体分析想法并创建：

![FlowBoard Canvas](docs/screenshot-canvas.png)

- **简单想法** → 带标题和优先级的任务
- **详细想法** → 任务 + 带验收标准的规格
- **复杂集群** → 父任务 + 带规格的子任务

可视化头脑风暴 → 结构化任务，零手动开销。

### 📁 文件浏览器

在不离开 dashboard 的情况下浏览、预览和编辑项目文件。带语法高亮的 Markdown 渲染、内联编辑和自动刷新。

![FlowBoard Files](docs/screenshot-files.png)

### 📱 Telegram Mini App

通过安全的隧道从 Telegram 远程访问 FlowBoard。通过 HMAC-SHA256 安全认证、移动端优化的 UI，支持 Cloudflare Tunnel、ngrok 或 Tailscale。

---

## 快速开始

### 1. 克隆并安装

```bash
git clone https://github.com/rasimme/FlowBoard.git
cd FlowBoard/dashboard
npm install
```

### 2. 设置工作空间

```bash
cp FlowBoard/files/ACTIVE-PROJECT.md ~/.openclaw/workspace/
cp -r FlowBoard/files/projects ~/.openclaw/workspace/
```

### 3. 添加智能体触发器

将项目触发器添加到 `~/.openclaw/workspace/AGENTS.md` 的顶部：

```bash
cat FlowBoard/snippets/AGENTS-trigger.md
# → 将该块粘贴到你的 AGENTS.md
```

### 4. 安装钩子

```bash
cp -r FlowBoard/hooks/project-context ~/.openclaw/hooks/
cp -r FlowBoard/hooks/session-handoff ~/.openclaw/hooks/
openclaw gateway restart
```

### 5. 启动 dashboard

```bash
node server.js
# 或使用 systemd（开机自动启动）：
cp templates/dashboard.service ~/.local/share/systemd/user/
systemctl --user enable --now dashboard
```

### 6. 创建你的第一个项目

打开 **http://localhost:18790** 并告诉你的智能体：

> "New project: my-app"

智能体创建文件夹结构、任务文件，并在 dashboard 中注册。

---

## 🐳 Docker 部署

FlowBoard 提供完整的 Docker 部署支持，便于容器化和可移植性。

### 前置要求

- Docker 20.10+
- Docker Compose 2.0+

### 使用 Docker 快速开始

#### 1. 克隆并构建

```bash
git clone https://github.com/rasimme/FlowBoard.git
cd FlowBoard
docker build -t flowboard:latest .
```

#### 2. 使用 Docker Compose 运行（推荐）

```bash
# 复制示例环境文件
cp .env.example .env

# 编辑 .env 配置
nano .env

# 启动服务
docker-compose up -d

# 访问 dashboard
open http://localhost:18790
```

#### 3. 挂载 OpenClaw 工作空间

**选项 A：主机路径映射**（推荐）

编辑 `docker-compose.yml`：

```yaml
volumes:
  - /Users/mac/.openclaw/workspace:/workspace
```

**选项 B：使用命名卷**

```bash
# 复制项目文件到卷
docker cp /path/to/your/PROJECT.md flowboard:/workspace/ACTIVE-PROJECT.md
docker cp -r /path/to/your/project flowboard:/workspace/projects/my-project
```

### Makefile 命令

```bash
make help          # 显示所有可用命令
make build         # 构建 Docker 镜像
make up            # 启动服务
make down          # 停止服务
make restart       # 重启服务
make logs          # 显示日志
make shell         # 打开容器 shell
make clean         # 删除容器和卷
make rebuild       # 重新构建并重启
```

### 生产环境部署

#### 1. 环境变量

查看 `.env.example` 了解所有可用配置选项。关键生产设置：

```bash
# 必需：工作空间
OPENCLAW_WORKSPACE=/workspace

# 可选：认证（强烈推荐用于远程访问）
TELEGRAM_BOT_TOKEN=your_bot_token
JWT_SECRET=openssl rand -hex 32
ALLOWED_USER_IDS=123456789

# 可选：隧道
TUNNEL_TOKEN=your_cloudflare_tunnel_token
```

#### 2. 健康检查

容器包含内置的健康检查：

```bash
docker ps --format "table {{.Status}}"
# 检查健康：STATUS 应为 "Up (healthy)"
```

#### 3. 资源限制

`docker-compose.yml` 中的默认资源限制：

- CPU：1.0 核心（限制）/ 0.5 核心（保留）
- 内存：512MB（限制）/ 256MB（保留）

根据需要调整。

#### 4. 安全最佳实践

- ✅ 非 root 用户（在 Dockerfile 中配置）
- ✅ 尽可能使用只读文件系统
- ✅ 资源限制防止资源耗尽
- ✅ JWT_SECRET 必须强（32+ 随机十六进制字符）
- ✅ 生产环境使用 HTTPS（使用 Nginx/Traefik 反向代理）

### 使用 Cloudflare Tunnel 远程访问

与 FlowBoard 并行运行 Cloudflare Tunnel：

```bash
docker-compose up -d

# 在另一个终端
cloudflared tunnel run --url http://localhost:18790
```

或将隧道集成到 `docker-compose.yml` 中（参见 `DOCKER_DEPLOY.md`）。

### 故障排除

完整的故障排除指南见 [DOCKER_DEPLOY.md](DOCKER_DEPLOY.md)。

---

## 画布 → 任务推广

创意画布推广功能需要 OpenClaw webhooks：

**1. 在 `~/.openclaw/openclaw.json` 中启用 webhooks**：
```json5
{
  hooks: {
    enabled: true,
    token: "your-secret-token",  // openssl rand -hex 16
    path: "/hooks"
  }
}
```

**2. 设置环境变量：**
```bash
OPENCLAW_HOOKS_TOKEN=your-secret-token
OPENCLAW_GATEWAY_URL=http://127.0.0.1:18789
# 推广通知的投递渠道（默认：last）
# 选项：last, telegram, whatsapp, discord, slack, signal, feishu
OPENCLAW_DELIVER_CHANNEL=feishu
# 可选：投递目标（Telegram 为聊天 ID，WhatsApp 为电话号码，Feishu 为用户 open_id）
OPENCLAW_DELIVER_TO=ou_b5b40e4f5b0e36a124fff581dc6c27d8  # 用于 Feishu
```

没有这些，除了画布推广外所有功能都能用。

---

## 命令

告诉你的智能体：

| 命令 | 功能 |
|---------|-------------|
| `Project: [Name]` | 激活项目（加载完整上下文） |
| `New project: [Name]` | 创建项目及文件夹结构 |
| `End project` | 停用，保存会话摘要 |
| `Projects` | 列出所有项目 |

智能体在工作时也会自主处理这些：

| 操作 | 发生什么 |
|--------|-------------|
| 创建任务 | 智能体调用 API，设置优先级，可选地编写规格 |
| 创建子任务 | 智能体将任务拆解为带父任务的子任务 |
| 更新状态 | 智能体将任务移动通过 `open → in-progress → review → done` |
| 编写规格 | 智能体创建 `specs/T-xxx-slug.md` 并带验收标准 |
| 画布推广 | 智能体接收集群笔记，决定任务结构 |

---

<details>
<summary><h2>远程访问（Telegram Mini App）</h2></summary>

FlowBoard 可以作为 Telegram Mini App 通过安全隧道远程访问。

### 设置隧道

任何隧道都可以。推荐：**Cloudflare Tunnel**（免费、稳定）。

```bash
cloudflared tunnel login
cloudflared tunnel create flowboard
cloudflared tunnel route dns flowboard dashboard.your-domain.com
cp templates/cloudflare-config.yml ~/.cloudflared/config.yml
# 编辑：替换 <TUNNEL_ID>, <USER>, <YOUR_DOMAIN>
cloudflared tunnel run flowboard
```

### 配置认证

```bash
JWT_SECRET=$(openssl rand -hex 32)

mkdir -p ~/.config/systemd/user/dashboard.service.d
cp templates/systemd-auth.conf.example \
   ~/.config/systemd/user/dashboard.service.d/auth.conf
# 编辑你的值：
# - TELEGRAM_BOT_TOKEN（来自 @BotFather）
# - JWT_SECRET
# - ALLOWED_USER_IDS（你的 Telegram 用户 ID）
# - DASHBOARD_ORIGIN（你的公共 URL）

systemctl --user daemon-reload
systemctl --user restart dashboard
```

### 注册 Telegram 按钮

1. 打开 @BotFather → `/setmenubutton`
2. 选择你的机器人
3. 发送你的公共 dashboard URL
4. 发送按钮标签（例如 "Dashboard"）

</details>

---

## 架构

```
~/.openclaw/workspace/
├── AGENTS.md                     # 智能体触发器
├── ACTIVE-PROJECT.md             # 当前项目状态
└── projects/
    ├── PROJECT-RULES.md          # 系统规则
    ├── _index.md                 # 项目注册表
    └── my-project/
        ├── PROJECT.md            # 目标、范围、状态、会话日志
        ├── DECISIONS.md          # 架构决策
        ├── tasks.json            # 任务（API 管理）
        ├── canvas.json           # 创意画布数据
        ├── context/              # 外部参考资料
        └── specs/                # 任务规格

~/FlowBoard/dashboard/            # Dashboard 服务
├── server.js                     # Express 5 API + 认证
├── index.html                    # SPA shell
├── js/                           # ES 模块（原生 JS，无构建步骤）
└── styles/                       # CSS（暗色主题）
```

**核心原则：**
- 🎯 **原生 JS** — 无框架、无构建步骤、无打包器
- 💾 **基于文件** — JSON + Markdown，无数据库
- ⚡ **懒加载** — 没有激活项目时零开销
- 🔒 **本地优先** — 一切在你的机器上运行
- 📡 **API 驱动** — Dashboard 和智能体使用相同的 REST API

---

## 贡献

欢迎贡献！指南见 [CONTRIBUTING.md](CONTRIBUTING.md)。

```bash
git checkout -b feat/your-feature
# 在 dev 分支上做更改
git commit -m "feat: your feature"
```

---

## 许可证

MIT © 2026

---

<p align="center">
  <strong>用 ❤️ 为 <a href="https://github.com/openclaw/openclaw">OpenClaw</a> 社区构建</strong>
</p>
