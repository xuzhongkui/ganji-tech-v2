# 华人帮 (CNAU) 完整开发文档

## 一、项目概述

### 1.1 项目信息
- **项目名称**: 华人帮 (China Aussies Helper)
- **域名**: cnau.com.au
- **类型**: 澳洲华人本地服务平台
- **主要功能**: 服务预约 + 二手交易 + 师傅展示

### 1.2 技术栈
```
前端:    Bootstrap 5 + 原生JavaScript
后端:    Node.js + Express
数据库:  MySQL (MariaDB)
部署:    Nginx + PM2
```

### 1.3 目录结构
```
/var/www/cnau/
├── index.html          # 首页
├── masters.html        # 师傅列表页
├── master/
│   └── [id].html      # 师傅详情页
├── user/
│   ├── login.html      # 用户登录
│   ├── register.html  # 用户注册
│   └── profile.html   # 用户中心
├── admin/
│   ├── login.html     # 管理员登录
│   └── dashboard.html # 管理后台
├── partnership.html   # 合伙申请
├── coupons.html       # 优惠券页
├── ranking.html       # 排行榜
├── second.html        # 二手市场
├── faq.html           # 常见问题
├── feedback.html      # 意见反馈
├── about.html         # 关于我们
├── server.js          # API服务 (端口3000)
├── uploads/           # 上传文件目录
│   ├── avatar/        # 头像
│   ├── banner/        # Banner图片
│   └── secondhand/    # 二手商品图片
└── images/            # 静态图片
```

---

## 二、数据库设计

### 2.1 用户表 (t_user)
```sql
CREATE TABLE t_user (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50),           -- 用户名
  phone VARCHAR(20) NOT NULL UNIQUE, -- 手机号(唯一)
  password VARCHAR(255) NOT NULL, -- 密码(加密存储)
  avatar VARCHAR(255),            -- 头像URL
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2.2 师傅表 (t_master)
```sql
CREATE TABLE t_master (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,          -- 关联用户ID
  real_name VARCHAR(50) NOT NULL, -- 真实姓名
  phone VARCHAR(20) NOT NULL,     -- 联系电话
  avatar VARCHAR(255),            -- 头像URL
  service_types VARCHAR(255),     -- 服务类型(多个用逗号分隔)
  bio TEXT,                      -- 个人简介
  rating DECIMAL(3,2) DEFAULT 0, -- 评分(0-5)
  status TINYINT DEFAULT 0,      -- 0:待审核 1:已认证 2:已封禁
  is_top TINYINT DEFAULT 0,      -- 是否置顶
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES t_user(id)
);
```

### 2.3 订单表 (t_order)
```sql
CREATE TABLE t_order (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_no VARCHAR(50) UNIQUE,    -- 订单号(唯一)
  user_id INT NOT NULL,          -- 用户ID
  master_id INT,                 -- 师傅ID(接单后)
  service_type VARCHAR(50),      -- 服务类型
  address VARCHAR(255),          -- 服务地址
  price DECIMAL(10,2),           -- 订单金额
  status TINYINT DEFAULT 0,     -- 0:待接单 1:已接单 2:进行中 3:已完成 4:已取消
  remark TEXT,                   -- 备注
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES t_user(id),
  FOREIGN KEY (master_id) REFERENCES t_master(id)
);
```

### 2.4 评价表 (t_review)
```sql
CREATE TABLE t_review (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,         -- 订单ID
  master_id INT NOT NULL,        -- 师傅ID
  user_id INT NOT NULL,         -- 用户ID
  rating TINYINT NOT NULL,      -- 评分(1-5)
  content TEXT,                 -- 评价内容
  reply TEXT,                   -- 师傅回复
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES t_order(id),
  FOREIGN KEY (master_id) REFERENCES t_master(id),
  FOREIGN KEY (user_id) REFERENCES t_user(id)
);
```

### 2.5 通知表 (t_notification)
```sql
CREATE TABLE t_notification (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,         -- 接收用户
  type VARCHAR(20),             -- 通知类型: order/re
  title VARCHARview/system(100),           -- 通知标题
  content TEXT,                 -- 通知内容
  data JSON,                   -- 附加数据
  is_read TINYINT DEFAULT 0,   -- 是否已读
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES t_user(id)
);
```

### 2.6 二手商品表 (t_secondhand)
```sql
CREATE TABLE t_secondhand (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,         -- 发布用户
  title VARCHAR(100) NOT NULL,  -- 商品标题
  description TEXT,             -- 商品描述
  price DECIMAL(10,2),         -- 价格
  image VARCHAR(255),           -- 图片URL
  contact VARCHAR(100),         -- 联系方式
  status TINYINT DEFAULT 1,    -- 1:上架 0:下架
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES t_user(id)
);
```

### 2.7 师傅置顶表 (t_master_top)
```sql
CREATE TABLE t_master_top (
  id INT PRIMARY KEY AUTO_INCREMENT,
  master_id INT NOT NULL,       -- 师傅ID
  start_date DATETIME,          -- 开始时间
  end_date DATETIME,            -- 结束时间
  status TINYINT DEFAULT 1,     -- 1:生效 0:过期
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (master_id) REFERENCES t_master(id)
);
```

### 2.8 优惠券表 (t_coupon)
```sql
CREATE TABLE t_coupon (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(100),           -- 优惠券名称
  discount DECIMAL(10,2),       -- 减免金额
  min_amount DECIMAL(10,2),    -- 最低消费
  valid_until DATETIME,         -- 有效期
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2.9 用户优惠券表 (t_user_coupon)
```sql
CREATE TABLE t_user_coupon (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,         -- 用户ID
  coupon_id INT NOT NULL,       -- 优惠券ID
  used TINYINT DEFAULT 0,        -- 是否已使用
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES t_user(id),
  FOREIGN KEY (coupon_id) REFERENCES t_coupon(id)
);
```

### 2.10 收藏表 (t_favorite)
```sql
CREATE TABLE t_favorite (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,         -- 用户ID
  master_id INT NOT NULL,        -- 师傅ID
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES t_user(id),
  FOREIGN KEY (master_id) REFERENCES t_master(id),
  UNIQUE(user_id, master_id)     -- 唯一约束
);
```

### 2.11 Banner表 (t_banner)
```sql
CREATE TABLE t_banner (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(100),            -- 标题
  image VARCHAR(255) NOT NULL,   -- 图片URL
  link VARCHAR(255),             -- 跳转链接
  position VARCHAR(20),          -- 位置: home/master
  sort_order INT DEFAULT 0,      -- 排序
  status TINYINT DEFAULT 1,      -- 1:显示 0:隐藏
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2.12 服务类型表 (t_service)
```sql
CREATE TABLE t_service (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,    -- 服务名称
  icon VARCHAR(50),              -- 图标
  sort_order INT DEFAULT 0,     -- 排序
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 2.13 系统设置表 (t_settings)
```sql
CREATE TABLE t_settings (
  id INT PRIMARY KEY,
  commission INT DEFAULT 10,      -- 平台抽成比例(%)
  phone VARCHAR(20),              -- 客服电话
  email VARCHAR(100),             -- 客服邮箱
  new_user_coupon INT            -- 新用户优惠券ID
);
```

---

## 三、API接口文档

### 3.1 用户模块

#### 3.1.1 用户注册
```
POST /api/user/register
Content-Type: application/json

请求:
{
  "phone": "0400000000",
  "password": "123456",
  "username": "用户名(可选)"
}

响应(成功):
{
  "success": true,
  "message": "注册成功",
  "userId": 1
}

响应(失败):
{
  "success": false,
  "message": "手机号已注册"
}
```

#### 3.1.2 用户登录
```
POST /api/user/login
Content-Type: application/json

请求:
{
  "phone": "0400000000",
  "password": "123456"
}

响应(成功):
{
  "success": true,
  "user": {
    "id": 1,
    "username": "用户名",
    "phone": "0400000000",
    "avatar": "头像URL"
  },
  "token": "jwt token"
}
```

#### 3.1.3 获取用户信息
```
GET /api/user/info
Header: Authorization: Bearer <token>

响应:
{
  "success": true,
  "user": {...}
}
```

#### 3.1.4 修改密码
```
POST /api/user/change-password
Content-Type: application/json
Header: Authorization: Bearer <token>

请求:
{
  "oldPassword": "旧密码",
  "newPassword": "新密码"
}
```

### 3.2 师傅模块

#### 3.2.1 师傅注册/申请
```
POST /api/master/register
Content-Type: application/json
Header: Authorization: Bearer <token>

请求:
{
  "realName": "真实姓名",
  "phone": "电话",
  "serviceTypes": ["搬家", "清洁"],
  "bio": "个人简介"
}
```

#### 3.2.2 师傅登录
```
POST /api/master/login
Content-Type: application/json

请求:
{
  "phone": "0400000000",
  "password": "123456"
}
```

#### 3.2.3 师傅列表
```
GET /api/master/list?type=搬家&status=1&page=1&limit=10

参数:
- type: 服务类型(可选)
- status: 状态 1=已认证(可选)
- page: 页码
- limit: 每页数量

响应:
{
  "success": true,
  "masters": [
    {
      "id": 1,
      "realName": "张师傅",
      "avatar": "头像URL",
      "serviceTypes": "搬家,清洁",
      "rating": 4.8,
      "bio": "简介"
    }
  ],
  "total": 100
}
```

#### 3.2.4 师傅详情
```
GET /api/master/:id

响应:
{
  "success": true,
  "master": {
    "id": 1,
    "realName": "张师傅",
    "phone": "0400000000",
    "avatar": "头像URL",
    "serviceTypes": "搬家,清洁",
    "rating": 4.8,
    "bio": "个人简介",
    "cases": [
      {"title": "案例1", "image": "图片URL"},
      {"title": "案例2", "image": "图片URL"}
    ]
  }
}
```

#### 3.2.5 师傅置顶
```
POST /api/master/top
Content-Type: application/json
Header: Authorization: Bearer <token>

请求:
{
  "masterId": 1,
  "days": 7  -- 置顶天数
}
```

### 3.3 订单模块

#### 3.3.1 创建订单
```
POST /api/order/create
Content-Type: application/json
Header: Authorization: Bearer <token>

请求:
{
  "serviceType": "搬家",
  "address": "悉尼市区",
  "price": 100,
  "remark": "需要搬运钢琴"
}

响应:
{
  "success": true,
  "orderId": 1,
  "orderNo": "CN20260221123456"
}
```

#### 3.3.2 订单列表
```
GET /api/order/list?status=0&page=1&limit=10

参数:
- status: 订单状态(可选) 0:待接单 1:已接单 2:进行中 3:已完成 4:已取消

响应:
{
  "success": true,
  "orders": [...]
}
```

#### 3.3.3 师傅接单
```
POST /api/order/accept
Content-Type: application/json
Header: Authorization: Bearer <token>

请求:
{
  "orderId": 1
}
```

#### 3.3.4 完成订单
```
POST /api/order/complete
Content-Type: application/json
Header: Authorization: Bearer <token>

请求:
{
  "orderId": 1
}
```

### 3.4 评价模块

#### 3.4.1 提交评价
```
POST /api/review/create
Content-Type: application/json
Header: Authorization: Bearer <token>

请求:
{
  "orderId": 1,
  "masterId": 1,
  "rating": 5,
  "content": "服务很好"
}
```

### 3.5 二手市场

#### 3.5.1 商品列表
```
GET /api/secondhand/list?page=1&limit=10

响应:
{
  "success": true,
  "items": [
    {
      "id": 1,
      "title": "二手冰箱",
      "price": 200,
      "image": "图片URL"
    }
  ]
}
```

#### 3.5.2 发布商品
```
POST /api/secondhand/create
Content-Type: application/json
Header: Authorization: Bearer <token>

请求:
{
  "title": "商品标题",
  "description": "商品描述",
  "price": 200,
  "image": "图片URL",
  "contact": "联系方式"
}
```

### 3.6 收藏模块

#### 3.6.1 添加收藏
```
POST /api/favorite/add
Content-Type: application/json
Header: Authorization: Bearer <token>

请求:
{
  "masterId": 1
}
```

#### 3.6.2 收藏列表
```
GET /api/favorite/list
Header: Authorization: Bearer <token>
```

### 3.7 优惠券

#### 3.7.1 领取优惠券
```
POST /api/coupon/claim
Content-Type: application/json
Header: Authorization: Bearer <token>

请求:
{
  "couponId": 1
}
```

#### 3.7.2 我的优惠券
```
GET /api/coupon/my
Header: Authorization: Bearer <token>
```

### 3.8 管理员后台

#### 3.8.1 管理员登录
```
POST /api/admin/login
Content-Type: application/json

请求:
{
  "username": "admin",
  "password": "admin123"
}

响应:
{
  "success": true,
  "admin": {
    "id": 1,
    "username": "admin"
  }
}
```

#### 3.8.2 首页统计
```
GET /api/admin/order/stats
Header: Authorization: <admin_token>

响应:
{
  "success": true,
  "total": 100,      -- 总订单
  "pending": 10,     -- 待接单
  "completed": 80,   -- 已完成
  "revenue": 10000   -- 总收入
}
```

#### 3.8.3 师傅列表(管理)
```
GET /api/admin/master/list?status=0

参数:
- status: 0:待审核 1:已认证 2:已封禁
```

#### 3.8.4 审核师傅
```
POST /api/admin/master/verify
Content-Type: application/json
Header: Authorization: <admin_token>

请求:
{
  "masterId": 1,
  "action": "approve"  -- approve/ban
}
```

#### 3.8.5 Banner管理
```
GET /api/admin/banner/list
POST /api/admin/banner/add
POST /api/admin/banner/delete
POST /api/admin/banner/toggle
```

---

## 四、前端页面

### 4.1 首页 (index.html)
```
主要功能:
1. Banner轮播 (3-5张图片)
2. 服务类型导航 (9个服务)
3. 推荐师傅 (6个师傅卡片)
4. 最新订单展示
5. 搜索框

布局:
┌─────────────────────────┐
│     Banner 轮播        │
├─────────────────────────┤
│ 搬家 | 清洁 | 园林 | IT... │  <- 服务类型
├─────────────────────────┤
│     推荐师傅           │
│ [师傅1] [师傅2] [师傅3] │
├─────────────────────────┤
│     最新订单           │
└─────────────────────────┘
```

### 4.2 师傅列表页 (masters.html)
```
参数: ?type=搬家

功能:
1. 服务类型筛选
2. 师傅列表(卡片式)
3. 分页
```

### 4.3 师傅详情页 (master/[id].html)
```
功能:
1. 师傅头像、姓名、评分
2. 服务类型标签
3. 个人简介
4. 案例展示(图片)
5. 用户评价列表
6. 收藏按钮
7. 在线预约按钮
```

### 4.4 用户中心 (user/profile.html)
```
功能:
1. 个人资料编辑
2. 我的订单
3. 我的优惠券
4. 收藏的师傅
5. 二手商品管理
```

### 4.5 管理后台 (admin/dashboard.html)
```
功能:
1. 首页统计
2. 订单管理
3. 师傅管理
4. 用户管理
5. 服务类型管理
6. Banner管理
7. 通知管理
8. 系统设置
```

---

## 五、开发步骤

### 5.1 第一步：环境搭建
```bash
# 1. 安装Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs

# 2. 安装MySQL
sudo apt install mariadb-server

# 3. 安装Nginx
sudo apt install nginx

# 4. 创建项目目录
mkdir -p /var/www/cnau
```

### 5.2 第二步：数据库初始化
```sql
-- 创建数据库
CREATE DATABASE cnau DEFAULT CHARACTER SET utf8mb4;

-- 执行建表SQL(参考第二部分)
```

### 5.3 第三步：后端开发
```bash
# 1. 初始化项目
cd /var/www/cnau
npm init -y
npm install express mysql2 bcryptjs jsonwebtoken cors multer

# 2. 创建server.js
# 3. 实现所有API接口
```

### 5.4 第四步：前端开发
```bash
# 1. 创建HTML页面
# 2. 引入Bootstrap 5
# 3. 实现页面交互
# 4. 调用API
```

### 5.5 第五步：部署配置
```bash
# 1. 配置Nginx
# 2. 设置SSL证书
# 3. 启动服务
pm2 start server.js
```

---

## 六、常见问题

### 6.1 图片上传失败
- 检查uploads目录权限
- 检查multer配置

### 6.2 API返回404
- 检查路由是否正确
- 检查端口是否正确

### 6.3 数据库连接失败
- 检查MySQL服务状态
- 检查用户名密码
- 检查数据库名称

### 6.4 CORS跨域错误
- 检查cors配置
- 检查请求头
