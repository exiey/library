<!-- 个人中心 - 蓝色现代风格 -->
<template>
  <view class="page-container">
    <!-- 1. 顶部沉浸式背景 -->
    <view class="profile-header-bg">
      <view class="wave-decoration"></view>
    </view>

    <view class="main-content">
      <!-- 2. 用户核心信息卡片 -->
      <view class="user-card shadow-blur">
        <view class="user-info-row">
          <view class="avatar-box">
            <image :src="fileUrl + userInfo.img" mode="aspectFill" class="avatar-img"></image>
          </view>
          <view class="user-meta">
            <text class="user-name">{{ userInfo.username || '未登录' }}</text>
            <view class="trust-badge">
              <text class="trust-icon">🛡️</text>
              <text class="trust-text">信誉分: {{ jifen }}</text>
            </view>
          </view>
          <view class="edit-icon" @tap="toUserDetail">⚙️</view>
        </view>

        <!-- 3. 统计数据栏 -->
        <view class="stats-row">
          <view class="stats-item">
            <text class="stats-num color-blue">{{ zhengchang }}</text>
            <text class="stats-label">正常签到</text>
          </view>
          <view class="stats-divider"></view>
          <view class="stats-item">
            <text class="stats-num color-orange">{{ chidao }}</text>
            <text class="stats-label">迟到记录</text>
          </view>
          <view class="stats-divider"></view>
          <view class="stats-item">
            <text class="stats-num color-red">{{ queka }}</text>
            <text class="stats-label">违规缺卡</text>
          </view>
        </view>
      </view>

      <!-- 4. 功能菜单列表 -->
      <view class="menu-section shadow-sm">
        <view class="menu-item" @tap="toUserDetail">
          <view class="menu-left">
            <text class="menu-icon bg-blue-light">👤</text>
            <text class="menu-text">个人资料</text>
          </view>
          <text class="menu-arrow">➜</text>
        </view>
<!--        <view class="menu-item" @tap="toGoods">
          <view class="menu-left">
            <text class="menu-icon bg-blue-light">💥</text>
            <text class="menu-text">虚拟饰品兑换</text>
          </view>
          <text class="menu-arrow">➜</text>
        </view>
        <view class="menu-item" @tap="toMyBill">
          <view class="menu-left">
            <text class="menu-icon bg-blue-light">🩷</text>
            <text class="menu-text">我的兑换</text>
          </view>
          <text class="menu-arrow">➜</text>
        </view>-->

<!--        <view class="menu-item" @tap="toDesk">
          <view class="menu-left">
            <text class="menu-icon bg-pink-light">🏓</text>
            <text class="menu-text">我的桌面</text>
          </view>
          <text class="menu-arrow">➜</text>
        </view>-->

        <view class="menu-item" @tap="toAddress">
          <view class="menu-left">
            <text class="menu-icon bg-green-light">📇</text>
            <text class="menu-text">联系人管理</text>
          </view>
          <text class="menu-arrow">➜</text>
        </view>

        <view class="menu-item" @tap="toPostsList">
          <view class="menu-left">
            <text class="menu-icon bg-purple-light">✍️</text>
            <text class="menu-text">我的发帖</text>
          </view>
          <text class="menu-arrow">➜</text>
        </view>
      </view>

      <!-- 5. 退出登录 -->
      <view class="logout-section" @tap="logOut">
        <view class="logout-btn">
          <text>退出当前账号</text>
        </view>
      </view>
    </view>

    <view class="safe-bottom-pad"></view>
  </view>
</template>

<script>
import { listj, findj, fileUrl, savej } from '@/common/config/api.js'
import { mapState, mapActions } from 'vuex'
import { ideautil, yewuutil } from '@/common/commontools.js'

export default {
  data() {
    return {
      fileUrl: fileUrl,
      favcount: 0,
      zhengchang: 0,
      chidao: 0,
      queka: 0,
      money: 0,
      jifen:0
    };
  },
  onShow() {
    this.jifen = this.userInfo.jifen || 0;
    this.money = this.userInfo.money || 0;
    this.qdtongji();
  },
  methods: {
    ...mapActions(['updateUserInfo', 'logout']),

    qdtongji() {
      let xyf = 10;
      let chidao = 0;
      let zhengchang = 0;
      let queka = 0;

      listj({ params: { table: 'yuyue', uid: this.userInfo.id } }).then(res => {
        if (res && res.length) {
          for (let s of res) {
            if (s.statecn == '已签到') {
              if (s.typecn == '迟到') {
                chidao += 1;
                xyf -= 1;
              } else {
                zhengchang += 1;
                xyf += 1;
              }
            } else if (s.statecn == '违规') {
              queka += 1;
              xyf -= 2;
            }
          }
        }
        this.chidao = chidao;
        this.zhengchang = zhengchang;
        this.queka = queka;
        this.jifen = xyf;

        // 同步到数据库
        savej({ params: { table: 'user', jifen: xyf, id: this.userInfo.id } }).then(() => {
          this.userInfo.jifen = xyf;
          this.updateUserInfo(this.userInfo);
        });
      });
    },

    toUserDetail() { uni.navigateTo({ url: '/pages/me/medetail' }) },
    toMyFavs() { uni.navigateTo({ url: '/pages/favs/favs' }) },
    toAddress() { uni.navigateTo({ url: '/pages/address/address' }) },
    toPostsList() { uni.navigateTo({ url: '/pages/posts/postslist' }) },
    toDesk(){
      uni.navigateTo({
        url: '/pages/me/desktop'
      })
    },

    toGoods(){
        uni.itool.nto({
            url:'/pages/good/goodview'
        })
    },
    toMyBill(){
        uni.itool.nto({
            url:'/pages/bill/bill'
        })
    },

    logOut() {
      uni.showModal({
        title: '提示',
        content: '确定退出登录吗？',
        success: (res) => {
          if (res.confirm) {
            this.updateUserInfo("");
            yewuutil.toLogin();
          }
        }
      });
    }
  },
  computed: {
    ...mapState(['userInfo'])
  }
};
</script>

<style lang="scss" scoped>
.page-container {
  min-height: 100vh;
  background-color: #f4f7fa;
}

/* 顶部背景 */
.profile-header-bg {
  height: 400rpx;
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  position: relative;
  border-bottom-left-radius: 60rpx;
  border-bottom-right-radius: 60rpx;
}

.wave-decoration {
  position: absolute;
  bottom: 0;
  width: 100%;
  height: 60rpx;
  background: rgba(255, 255, 255, 0.1);
  border-top-left-radius: 100%;
  border-top-right-radius: 100%;
}

/* 主体内容 */
.main-content {
  padding: 0 32rpx;
  margin-top: -160rpx;
  position: relative;
  z-index: 10;
}

/* 用户卡片 */
.user-card {
  background: #ffffff;
  border-radius: 32rpx;
  padding: 40rpx;
  box-shadow: 0 10rpx 40rpx rgba(0, 0, 0, 0.05);
  margin-bottom: 32rpx;
}

.user-info-row {
  display: flex;
  align-items: center;
  margin-bottom: 40rpx;
}

.avatar-box {
  width: 120rpx;
  height: 120rpx;
  border: 4rpx solid #ffffff;
  border-radius: 50%;
  overflow: hidden;
  box-shadow: 0 4rpx 15rpx rgba(0,0,0,0.1);
}

.avatar-img {
  width: 100%;
  height: 100%;
}

.user-meta {
  flex: 1;
  margin-left: 30rpx;
}

.user-name {
  font-size: 40rpx;
  font-weight: bold;
  color: #333;
  display: block;
  margin-bottom: 8rpx;
}

.trust-badge {
  display: inline-flex;
  align-items: center;
  background: #f0f7ff;
  padding: 4rpx 20rpx;
  border-radius: 100rpx;
}

.trust-icon { font-size: 24rpx; margin-right: 8rpx; }
.trust-text { font-size: 24rpx; color: #4facfe; font-weight: bold; }

.edit-icon { font-size: 40rpx; color: #999; }

/* 统计栏 */
.stats-row {
  display: flex;
  justify-content: space-around;
  align-items: center;
  padding-top: 30rpx;
  border-top: 1rpx solid #f1f5f9;
}

.stats-item {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.stats-num {
  font-size: 36rpx;
  font-weight: bold;
  margin-bottom: 8rpx;
}

.stats-label {
  font-size: 22rpx;
  color: #94a3b8;
}

.stats-divider {
  width: 1rpx;
  height: 40rpx;
  background-color: #e2e8f0;
}

.color-blue { color: #4facfe; }
.color-orange { color: #f59e0b; }
.color-red { color: #ef4444; }

/* 菜单列表 */
.menu-section {
  background: #ffffff;
  border-radius: 32rpx;
  padding: 10rpx 0;
  margin-bottom: 32rpx;
}

.menu-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 30rpx 40rpx;
  transition: background 0.2s;
}

.menu-item:active { background-color: #f8fafc; }

.menu-left {
  display: flex;
  align-items: center;
}

.menu-icon {
  width: 64rpx;
  height: 64rpx;
  border-radius: 20rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 32rpx;
  margin-right: 24rpx;
}

.menu-text {
  font-size: 30rpx;
  color: #334155;
  font-weight: 500;
}

.menu-arrow {
  font-size: 24rpx;
  color: #cbd5e1;
}

/* 菜单图标背景 */
.bg-blue-light { background-color: #eff6ff; }
.bg-pink-light { background-color: #fff1f2; }
.bg-green-light { background-color: #f0fdf4; }
.bg-purple-light { background-color: #f5f3ff; }

/* 退出登录 */
.logout-section {
  margin-top: 40rpx;
}

.logout-btn {
  background-color: #ffffff;
  height: 100rpx;
  border-radius: 24rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #ef4444;
  font-size: 30rpx;
  font-weight: bold;
  box-shadow: 0 4rpx 15rpx rgba(239, 68, 68, 0.05);
}

.logout-btn:active { opacity: 0.8; background-color: #fef2f2; }

.safe-bottom-pad { height: 60rpx; }

/* 阴影库 */
.shadow-sm { box-shadow: 0 2rpx 10rpx rgba(0,0,0,0.02); }
.shadow-blur { box-shadow: 0 10rpx 40rpx rgba(0,0,0,0.05); }

/* Web端适配 */
@media screen and (min-width: 750px) {
  .main-content {
    max-width: 500px;
    margin: -160rpx auto 0;
  }
  .profile-header-bg {
    max-width: 500px;
    margin: 0 auto;
  }
}
</style>