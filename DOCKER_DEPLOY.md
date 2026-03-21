# FlowBoard Docker 部署指南

本文档提供 FlowBoard 项目的完整 Docker 部署方案。

## 📋 前置要求

- Docker 20.10+
- Docker Compose 2.0+

## 🚀 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/rasimme/FlowBoard.git
cd FlowBoard
```

### 2. 准备配置文件

创建 `.env` 文件（可选，用于环境变量）：

```bash
cat > .env <<EOF
# Telegram Mini App 认证（可选）
TELEGRAM_BOT_TOKEN=your_bot_token
JWT_SECRET=your_jwt_secret_here
ALLOWED_USER_IDS=123456789
DASHBOARD_ORIGIN=https://dashboard.yourdomain.com
LOCAL_HOSTNAME=dashboard.yourdomain.com
AUTH_ALWAYS=false

# OpenClaw Hooks 令牌（可选，用于项目切换唤醒事件）
OPENCLAW_HOOKS_TOKEN=your_webhook_secret
EOF
```

### 3. 启动服务

```bash
# 使用 Docker Compose（推荐）
docker-compose up -d

# 或使用 Docker 命令
docker build -t flowboard .
docker run -d \
  --name flowboard \
  -p 18790:18790 \
  -v /path/to/openclaw/workspace:/workspace \
  flowboard
```

### 4. 访问 Dashboard

打开浏览器访问：`http://localhost:18790`

## 📁 目录映射

默认情况下，Docker 容器会创建一个命名卷 `openclaw_workspace`。你可以将其映射到宿主机的 OpenClaw 工作空间：

### 方案 A：映射到 OpenClau 工作空间（推荐）

修改 `docker-compose.yml`：

```yaml
volumes:
  # 注释掉命名卷
  # openclaw_workspace:
  #   driver: local

  # 添加宿主机映射
  - /Users/mac/.openclaw/workspace:/workspace
```

或者使用 Docker 命令：

```bash
docker run -d \
  --name flowboard \
  -p 18790:18790 \
  -v /Users/mac/.openclaw/workspace:/workspace \
  flowboard
```

### 方案 B：使用命名卷（独立运行）

```bash
# 查看卷位置
docker volume inspect openclaw_workspace

# 复制文件到卷中
docker cp /path/to/your/PROJECT.md flowboard:/workspace/ACTIVE-PROJECT.md
docker cp -r /path/to/your/project flowboard:/workspace/projects/my-project
```

## 🔧 环境变量说明

| 变量 | 必需 | 默认值 | 说明 |
|------|-------|---------|------|
| `FLOWBOARD_PORT` | 否 | 18790 | 服务器监听端口 |
| `FLOWBOARD_HOST` | 否 | 0.0.0.0 | 服务器绑定地址 |
| `OPENCLAW_WORKSPACE` | 是 | /workspace | OpenClaw 工作空间路径 |
| `OPENCLAW_GATEWAY_PORT` | 否 | 15988 | OpenClaw Gateway 端口 |
| `OPENCLAW_HOOKS_TOKEN` | 否 | - | Webhook 令牌 |
| `TELEGRAM_BOT_TOKEN` | 否 | - | Telegram Bot Token |
| `JWT_SECRET` | 否 | - | JWT 签名密钥 |
| `ALLOWED_USER_IDS` | 否 | - | 允许的用户 ID（逗号分隔） |
| `DASHBOARD_ORIGIN` | 否 | - | Dashboard 允许的来源 |
| `LOCAL_HOSTNAME` | 否 | - | 本地主机名（LAN 访问） |
| `AUTH_ALWAYS` | 否 | false | 是否始终启用认证 |
| `NODE_ENV` | 否 | production | Node 环境 |

## 🌐 远程访问（Cloudflare Tunnel）

如果你想通过公网访问 Dashboard（例如配合 Telegram Mini App）：

### 使用 Docker 运行 Cloudflare Tunnel

```bash
# 1. 安装 cloudflared（宿主机）
brew install cloudflared

# 2. 启动 tunnel
cloudflared tunnel --url http://localhost:18790

# 或使用配置文件
cloudflared tunnel run flowboard
```

### 使用 Docker Compose 集成

创建 `docker-compose.override.yml`：

```yaml
version: '3.8'

services:
  flowboard:
    # ... 其他配置 ...

  cloudflared:
    image: cloudflare/cloudflared:latest
    container_name: flowboard-tunnel
    restart: unless-stopped
    command: tunnel run --url http://flowboard:18790
    environment:
      - TUNNEL_TOKEN=${TUNNEL_TOKEN}
    networks:
      - flowboard-network
```

## 🛠 常用命令

### 查看日志

```bash
docker-compose logs -f flowboard
# 或
docker logs -f flowboard
```

### 进入容器

```bash
docker exec -it flowboard sh
```

### 停止服务

```bash
docker-compose down
# 或
docker stop flowboard
```

### 重启服务

```bash
docker-compose restart
# 或
docker restart flowboard
```

### 清理数据

```bash
docker-compose down -v  # 删除卷
# 或
docker volume rm openclaw_workspace
```

## 📦 构建和推送镜像

### 构建镜像

```bash
docker build -t flowboard:latest .
docker build -t flowboard:v3.0.0 .
```

### 推送到 Docker Hub

```bash
docker tag flowboard:latest yourusername/flowboard:latest
docker push yourusername/flowboard:latest
```

### 推送到 GitHub Container Registry

```bash
docker tag flowboard:latest ghcr.io/yourusername/flowboard:latest
docker push ghcr.io/yourusername/flowboard:latest
```

## 🔒 安全建议

1. **使用非 root 用户**：Dockerfile 已配置非 root 用户
2. **设置强 JWT_SECRET**：使用 `openssl rand -hex 32` 生成
3. **限制资源**：docker-compose.yml 中已设置资源限制
4. **使用 HTTPS**：生产环境请反向代理（Nginx/Traefik）
5. **定期更新镜像**：及时更新到最新版本

## 🐛 故障排查

### 问题：容器无法启动

```bash
# 查看详细日志
docker logs flowboard

# 检查端口占用
lsof -i :18790
```

### 问题：无法访问 Dashboard

1. 检查端口映射：`docker ps` 查看 `PORTS` 列
2. 检查防火墙：确保 18790 端口开放
3. 检查网络：`docker network ls` 和 `docker network inspect`

### 问题：文件丢失

- 确保正确挂载了卷或宿主机目录
- 检查容器内的路径：`docker exec flowboard ls -la /workspace`

## 📚 更多信息

- FlowBoard GitHub: https://github.com/rasimme/FlowBoard
- OpenClaw 文档: https://docs.openclaw.ai
- Docker 文档: https://docs.docker.com
