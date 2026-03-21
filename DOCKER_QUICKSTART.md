# FlowBoard Docker 快速开始指南

## 5 分钟快速部署

### Step 1: 准备环境

```bash
# 1. 确保已安装 Docker 和 Docker Compose
docker --version
docker-compose --version

# 2. 克隆项目
git clone https://github.com/rasimme/FlowBoard.git
cd FlowBoard
```

### Step 2: 配置环境变量

```bash
# 复制环境变量模板
cp .env.example .env

# 编辑配置（使用你喜欢的编辑器）
nano .env
```

**最小配置：**

```bash
# 必需：工作空间路径
OPENCLAW_WORKSPACE=/workspace

# 可选：如果你想远程访问，设置认证
TELEGRAM_BOT_TOKEN=1234567890:ABCdefGHIjklMNOpqrsTUVwxyz
JWT_SECRET=$(openssl rand -hex 32)
ALLOWED_USER_IDS=123456789
```

### Step 3: 启动服务

```bash
# 使用 Docker Compose 启动（推荐）
docker-compose up -d

# 查看启动日志
docker-compose logs -f
```

### Step 4: 验证部署

```bash
# 检查容器状态
docker ps | grep flowboard

# 应该看到类似这样的输出：
# CONTAINER ID   IMAGE          STATUS          PORTS
# abc123456789   flowboard:latest   Up 2 minutes    0.0.0.0:18790->18790/tcp

# 健康检查
curl http://localhost:18790/api/health
# 应该返回: {"status":"ok"}

# 访问 Dashboard
open http://localhost:18790
```

### Step 5: 映射工作空间（如果需要）

如果你想让 FlowBoard 访问你的 OpenClau 工作空间：

**选项 A：修改 docker-compose.yml**

```yaml
volumes:
  openclaw_workspace:
    driver: local
  # 添加这行：
  - /Users/mac/.openclaw/workspace:/workspace
```

**选项 B：使用命名卷（独立运行）**

```bash
# 复制现有项目文件
docker cp /Users/mac/.openclaw/workspace/ACTIVE-PROJECT.md flowboard:/workspace/ACTIVE-PROJECT.md

# 复制整个项目目录
docker cp -r /Users/mac/.openclaw/workspace/projects flowboard:/workspace/
```

### 常用命令

```bash
# 查看日志
docker-compose logs -f

# 重启服务
docker-compose restart

# 停止服务
docker-compose down

# 进入容器
docker exec -it flowboard sh

# 完全清理（删除数据）
docker-compose down -v
```

### 使用 Makefile

```bash
make build      # 构建镜像
make up         # 启动服务
make down       # 停止服务
make logs       # 查看日志
make shell      # 进入容器
make clean      # 清理所有数据
make rebuild    # 重新构建并启动
```

## 远程访问配置

### Cloudflare Tunnel（推荐）

```bash
# 1. 安装 cloudflared
brew install cloudflared

# 2. 启动隧道
cloudflared tunnel --url http://localhost:18790

# 3. 或者集成到 docker-compose
# 将以下内容添加到 docker-compose.yml：
#
# cloudflared:
#   image: cloudflare/cloudflared:latest
#   container_name: flowboard-tunnel
#   command: tunnel run --url http://flowboard:18790
#   environment:
#     - TUNNEL_TOKEN=${TUNNEL_TOKEN}
```

### ngrok（备选）

```bash
# 安装 ngrok
brew install ngrok

# 启动隧道
ngrok http 18790
```

## 故障排查

### 问题：容器无法启动

```bash
# 查看详细日志
docker logs flowboard

# 检查端口占用
lsof -i :18790

# 检查 Docker 日志
docker system events --since 5m
```

### 问题：无法访问 Dashboard

1. 确认容器正在运行：`docker ps`
2. 确认端口映射正确
3. 检查防火墙设置
4. 尝试使用 `localhost:18790` 而不是 `127.0.0.1:18790`

### 问题：工作空间没有数据

```bash
# 检查卷挂载
docker inspect flowboard | jq -r '.[0].Mounts'

# 进入容器查看
docker exec -it flowboard sh
ls -la /workspace
```

## 生产环境建议

1. **使用反向代理**（Nginx/Traefik）
2. **启用 HTTPS**
3. **设置强 JWT_SECRET**
4. **配置资源限制**
5. **定期更新镜像**
6. **启用日志轮转**
7. **使用监控**（Prometheus/Grafana）

## 下一步

- 📖 阅读完整文档：[DOCKER_DEPLOY.md](DOCKER_DEPLOY.md)
- 📖 查看 README：[README.md](README.md)
- 🐳 了解 Docker 最佳实践

## 获取帮助

- FlowBoard GitHub Issues: https://github.com/rasimme/FlowBoard/issues
- OpenClaw 文档: https://docs.openclaw.ai
- Docker 文档: https://docs.docker.com
