# 图书馆座位预约系统

这是一个包含后端管理端、`uni-app` 前端源码以及微信小程序构建产物的完整项目，主题是“图书馆 / 自习室座位预约”。仓库内同时保留了 Java 后端、后台静态页面和小程序端代码，适合本地直接运行、二次开发或用于毕设项目整理。

## 项目概览

- 后端：`Spring Boot 2.5.5` + `MyBatis` + `MySQL`
- 移动端：`uni-app` 源码，依赖 `uview-ui` 与 `tuniao-ui`
- 小程序端：已编译的微信小程序目录 `mp-weixin`
- 管理端：后端 `static` 目录下的 HTML 页面，启动后可直接访问

从代码和数据库结构来看，当前项目主要覆盖这些功能：

- 用户登录、注册、个人信息维护
- 自习室 / 房间管理
- 座位管理
- 时段管理
- 座位预约、预约记录、评价
- 公告、帖子、回复
- 商品、账单、地址、钱包、优惠券等扩展模块
- 微信小程序登录、手机号获取、扫码相关能力

## 目录结构

```text
library/
├─ zanzuoyuyueui3jifenqiandao3_up_ssm2/   # 主项目目录
│  ├─ src/main/java/                      # Spring Boot 后端源码
│  ├─ src/main/resources/
│  │  ├─ application.properties           # 数据库、端口、微信配置
│  │  └─ static/                          # 后台管理页面静态资源
│  ├─ app/                                # uni-app 前端源码
│  └─ pom.xml                             # Maven 配置
├─ mp-weixin/                             # 已编译微信小程序代码
├─ zanzuoyuyueui3jifenqiandao3_up_ssm2.sql # 数据库初始化脚本
└─ README.md
```

## 环境要求

- JDK 8
- Maven 3.6+
- MySQL 5.7 / 8.0
- HBuilderX
  用于运行 `uni-app` 源码
- 微信开发者工具
  用于打开 `mp-weixin` 目录或调试微信小程序

## 技术栈

### 后端

- Spring Boot 2.5.5
- MyBatis
- MySQL Connector 8.0.30
- Fastjson
- Hutool
- ZXing
- Tess4J

### 前端

- uni-app
- uView UI
- Tuniao UI

## 数据库初始化

1. 在 MySQL 中创建数据库：

```sql
CREATE DATABASE zanzuoyuyueui3jifenqiandao3_up_ssm2 DEFAULT CHARACTER SET utf8mb4;
```

2. 导入根目录 SQL 文件：

```bash
mysql -u root -p zanzuoyuyueui3jifenqiandao3_up_ssm2 < zanzuoyuyueui3jifenqiandao3_up_ssm2.sql
```

3. 按需修改后端配置文件：

文件位置：[`zanzuoyuyueui3jifenqiandao3_up_ssm2/src/main/resources/application.properties`](/d:/code/design/library/zanzuoyuyueui3jifenqiandao3_up_ssm2/src/main/resources/application.properties)

默认配置如下：

```properties
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/zanzuoyuyueui3jifenqiandao3_up_ssm2?nullCatalogMeansCurrent=true&useSSL=false&useUnicode=true&characterEncoding=UTF-8
spring.datasource.username=root
spring.datasource.password=
server.port=8088
```

## 启动后端

进入后端目录：

```bash
cd zanzuoyuyueui3jifenqiandao3_up_ssm2
```

使用 Maven 启动：

```bash
mvn spring-boot:run
```

或者先打包再运行：

```bash
mvn clean package
java -jar target/ideassm-1.0.jar
```

启动成功后，默认访问地址：

- 后端服务：`http://localhost:8088`
- 管理端登录页：`http://localhost:8088/login.html`
- 管理端首页：`http://localhost:8088/index.html`

## 管理端页面

后端 `static` 目录下已经包含一套后台页面，常见页面包括：

- `login.html`
- `index.html`
- `user.html`
- `roomsite.html`
- `yuyue.html`
- `shiduan.html`
- `notice.html`
- `shop.html`

这些页面启动后可直接由 Spring Boot 提供静态访问。

## 小程序 / uni-app 说明

项目里同时有两套前端形态：

- `zanzuoyuyueui3jifenqiandao3_up_ssm2/app`
  这是 `uni-app` 源码，建议用于二次开发
- `mp-weixin`
  这是已经编译出来的微信小程序工程，可直接用微信开发者工具打开

### 运行 uni-app 源码

1. 使用 HBuilderX 打开目录：

```text
zanzuoyuyueui3jifenqiandao3_up_ssm2/app
```

2. 安装依赖：

```bash
npm install
```

3. 运行到微信开发者工具，或直接编译到 `mp-weixin`

### 直接打开小程序构建产物

用微信开发者工具打开：

```text
mp-weixin
```

### 小程序后端地址配置

前端默认请求地址来自：

[`zanzuoyuyueui3jifenqiandao3_up_ssm2/app/common/config/api.js`](/d:/code/design/library/zanzuoyuyueui3jifenqiandao3_up_ssm2/app/common/config/api.js)

默认值为：

```js
let rootIp = 'localhost:8088'
```

小程序中还提供了服务端地址设置页：

- `pages/login/rootip`

可以在页面里手动修改 IP 和端口，例如：

- 本机调试：`127.0.0.1:8088`
- 局域网调试：`192.168.x.x:8088`

如果是手机真机调试，通常不能继续使用 `localhost`，需要改成电脑在局域网中的实际 IP。

## 主要数据表

数据库脚本中可以确认的核心表包括：

- `wct_user`
- `wct_room`
- `wct_site`
- `wct_shiduan`
- `wct_yuyue`
- `wct_notice`
- `wct_posts`
- `wct_replay`
- `wct_good`
- `wct_bill`
- `wct_address`
- `wct_shop`
- `wct_type`
- `wct_type2`
- `wct_blog`

其中和“图书馆座位预约”最相关的是：

- `wct_room`
  自习室 / 房间
- `wct_site`
  座位
- `wct_shiduan`
  可预约时段
- `wct_yuyue`
  预约记录
- `wct_user`
  用户信息

## 示例账号

SQL 初始化数据里包含一些测试账号，例如：

- 管理员：`admin / admin`
- 普通用户：`user1 / 111111`
- 普通用户：`user2 / 111111`

如果你导入的是当前仓库里的 SQL，通常可以直接用这些账号做联调测试。

## 接口说明

后端主要接口集中在：

- `/database/*`
- `/home/*`

其中 `/database` 控制器提供了这类能力：

- 通用列表查询：`/database/list`
- 单条查询：`/database/find`
- 分页查询：`/database/listPage`
- 新增 / 更新：`/database/save`
- 删除：`/database/delete`
- 文件上传：`/database/upload`
- 登录：`/database/login`
- 微信登录：`/database/wxlogin`
- 微信手机号获取：`/database/getWxPhoneNumber`

这个项目的后端风格偏“通用表驱动接口”，前端通过传递 `table` 参数访问不同业务表。

## 开发建议

- 先跑通后端和数据库，再调小程序端
- 真机调试时，把小程序里的 `rootIp` 改成电脑局域网 IP
- 如果只想看业务流程，优先关注：
  - `wct_room`
  - `wct_site`
  - `wct_shiduan`
  - `wct_yuyue`
- 如果要做二次开发，建议以 `app/` 为前端主源码，不要直接改 `mp-weixin/` 编译产物

## 已知注意事项

- `application.properties` 中已经写入微信 `app_id` 和 `app_secret`，正式部署前建议自行替换
- 管理端和部分前端代码存在中文乱码现象，通常与原始文件编码有关，不影响基本梳理结构
- 项目中包含一些通用模块和扩展业务，不一定都属于“图书馆座位预约”核心功能
- 后端开放了较多通用 SQL / 表操作接口，二次上线前建议补充鉴权和安全限制

## 后续可整理方向

- 补充接口文档
- 梳理角色权限与菜单关系
- 分离“核心预约功能”和“扩展商城/社区功能”
- 统一前后端编码格式，修复中文乱码
- 增加本地开发、测试、部署脚本

