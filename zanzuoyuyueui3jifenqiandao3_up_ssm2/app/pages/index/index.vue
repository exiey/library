<!-- 首页 - 蓝色现代风格（修复 Swiper 与样式优化） -->
<template>
  <view class="page-container">
    <!-- 自定义导航栏 -->
    <u-navbar
        title="首页"
        leftIconSize="0"
        :border="false"
        :placeholder="true"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #333;"
    ></u-navbar>

    <scroll-view scroll-y class="content-scroll">

      <!-- 1. 顶部轮播图展示区 - 关键修复：增加 v-if -->
      <view class="swiper-section" v-if="noticelist.length > 0">
        <swiper
            class="main-swiper"
            :circular="true"
            :indicator-dots="true"
            :autoplay="true"
            :interval="4000"
            :duration="800"
            indicator-active-color="#4facfe"
            indicator-color="rgba(255,255,255,0.6)"
        >
          <swiper-item v-for="(item, index) in noticelist" :key="index" @click="noticedetail(item.id)">
            <view class="swiper-item-wrapper">
              <image
                  class="swiper-img"
                  :src="fileUrl + item.img"
                  mode="aspectFill"
                  @error="imageError(index)"
              ></image>
              <!-- 遮罩层：让文字更清晰 -->
              <view class="swiper-title-mask">
                <text class="swiper-title">{{ item.title }}</text>
              </view>
            </view>
          </swiper-item>
        </swiper>
      </view>
      <!-- 轮播图加载中的占位图 -->
      <view class="swiper-section" v-else>
        <view class="swiper-placeholder"></view>
      </view>

      <!-- 2. 金刚区网格菜单 -->
      <view class="menu-card">
        <view class="grid-layout">
          <view class="grid-item" @tap="navigateTo('/pages/roomsite/room')">
            <view class="icon-box bg-light-blue">
              <text class="emoji-icon">✨</text>
            </view>
            <text class="grid-label">为我推荐</text>
          </view>

          <view class="grid-item" @tap="navigateTo('/pages/notice/notice')">
            <view class="icon-box bg-light-green">
              <text class="emoji-icon">📢</text>
            </view>
            <text class="grid-label">公告通知</text>
          </view>

          <view class="grid-item" @tap="navigateTo('/pages/paihangbang/paihangbang')">
            <view class="icon-box bg-light-orange">
              <text class="emoji-icon">🏆</text>
            </view>
            <text class="grid-label">排行榜</text>
          </view>

          <view class="grid-item" @tap="navigateTo('/pages/posts/posts')">
            <view class="icon-box bg-light-purple">
              <text class="emoji-icon">💬</text>
            </view>
            <text class="grid-label">论坛交流</text>
          </view>
        </view>
      </view>

      <!-- 3. 原生实现资讯列表区 -->
      <view class="section-header">
        <view class="section-title">
          <view class="title-line"></view>
          <text>最新资讯</text>
        </view>
        <text class="more-text" @tap="toNotice">查看更多</text>
      </view>

      <view class="notice-list">
        <view
            class="notice-item"
            v-for="(item, index) in noticelist"
            :key="index"
            @tap="noticedetail(item.id)"
            hover-class="item-hover"
        >
          <image class="notice-cover" :src="fileUrl + item.img" mode="aspectFill"></image>
          <view class="notice-content">
            <view class="notice-top">
              <text class="notice-title">{{ item.title }}</text>
              <text class="notice-desc">{{ item.note || '暂无描述' }}</text>
            </view>
            <view class="notice-footer">
              <view class="notice-tag">精选动态</view>
              <text class="notice-arrow">详情 →</text>
            </view>
          </view>
        </view>

        <!-- 空状态处理 -->
        <view v-if="noticelist.length === 0" class="empty-box">
          <text class="empty-icon">📂</text>
          <text class="empty-text">暂无相关资讯</text>
        </view>
      </view>

      <view class="safe-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listj, findj, fileUrl } from '@/common/config/api.js'
import { ideautil, yewuutil } from '@/common/commontools.js'
import { mapState, mapActions } from 'vuex'

export default {
  data() {
    return {
      fileUrl: fileUrl,
      noticelist: []
    }
  },
  onLoad() {
    this.checkLogin();
    this.fetchNotice();
  },
  methods: {
    ...mapActions(['updateUserInfo', 'logout']),

    // 登录检查逻辑
    checkLogin() {
      let username = this.userInfo && this.userInfo.username
      let passwd = this.userInfo && this.userInfo.passwd
      let openid = this.userInfo && this.userInfo.openid

      if (openid) {
        findj({ params: { table: 'user', openid: openid } }).then(res => {
          if (res) this.updateUserInfo(res)
          else this.toLogin()
        }).catch(() => this.toLogin())
      } else if (username && passwd) {
        findj({ params: { table: 'user', username, passwd } }).then(res => {
          if (res) this.updateUserInfo(res)
          else this.toLogin()
        }).catch(() => this.toLogin())
      } else {
        this.toLogin()
      }
    },

    toLogin() {
      this.updateUserInfo({});
      yewuutil.toLogin();
    },

    fetchNotice() {
      listj({ params: { table: 'notice', type: 1 } }).then(res => {
        if (res) {
          const processed = res.map(s => {
            return {
              ...s,
              note: uni.itool ? uni.itool.getSimpleText(s.note) : s.note.replace(/<[^>]+>/g, '')
            }
          });
          this.noticelist = processed.slice(0, 5);
        }
      })
    },

    imageError(index) {
      console.error("图片加载失败:", this.noticelist[index].img);
    },

    navigateTo(url) {
      uni.navigateTo({ url });
    },

    noticedetail(id) {
      uni.navigateTo({ url: '/pages/notice/noticedetail?tid=' + id })
    },

    toNotice() { uni.navigateTo({ url: "/pages/notice/notice" }) },
  },
  computed: {
    ...mapState(['userInfo'])
  }
}
</script>

<style scoped lang="scss">
.page-container {
  min-height: 100vh;
  background-color: #f8fafc;
}

.content-scroll {
  height: calc(100vh - 44px);
}

/* 1. 轮播图样式美化 */
.swiper-section {
  padding: 24rpx;
  background-color: #fff;
}

.main-swiper {
  height: 360rpx; /* 稍微加高一点 */
  border-radius: 24rpx;
  overflow: hidden;
  box-shadow: 0 12rpx 30rpx rgba(0, 0, 0, 0.1);
  /* 强制兼容某些平台的圆角 */
  transform: translateY(0);
}

.swiper-item-wrapper {
  position: relative;
  width: 100%;
  height: 100%;
  background-color: #f1f5f9; /* 加载前的底色 */
}

.swiper-img {
  width: 100%;
  height: 100%;
  display: block;
}

.swiper-title-mask {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  padding: 60rpx 24rpx 24rpx;
  background: linear-gradient(to top, rgba(0,0,0,0.6) 0%, transparent 100%);
  pointer-events: none;
}

.swiper-title {
  color: #ffffff;
  font-size: 30rpx;
  font-weight: 600;
  letter-spacing: 1rpx;
}

.swiper-placeholder {
  height: 360rpx;
  background-color: #f1f5f9;
  border-radius: 24rpx;
}

/* 2. 金刚区 */
.menu-card {
  margin: 0 24rpx 24rpx;
  background: #fff;
  border-radius: 32rpx;
  padding: 36rpx 0;
  box-shadow: 0 4rpx 20rpx rgba(0,0,0,0.02);
}

.grid-layout {
  display: flex;
  justify-content: space-around;
}

.grid-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  &:active { opacity: 0.7; }
}

.icon-box {
  width: 100rpx;
  height: 100rpx;
  border-radius: 30rpx;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 16rpx;
}

.emoji-icon { font-size: 48rpx; }
.bg-light-blue { background: linear-gradient(135deg, #eef7ff, #e0f2fe); }
.bg-light-green { background: linear-gradient(135deg, #f0fdf4, #dcfce7); }
.bg-light-orange { background: linear-gradient(135deg, #fff7ed, #ffedd5); }
.bg-light-purple { background: linear-gradient(135deg, #f5f3ff, #ede9fe); }

.grid-label {
  font-size: 26rpx;
  color: #1e293b;
  font-weight: 500;
}

/* 3. 列表标题 */
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20rpx 32rpx 10rpx;
}

.section-title {
  display: flex;
  align-items: center;
  font-size: 34rpx;
  font-weight: 800;
  color: #1e293b;
}

.title-line {
  width: 8rpx;
  height: 32rpx;
  background: linear-gradient(#4facfe, #00f2fe);
  border-radius: 4rpx;
  margin-right: 16rpx;
}

.more-text { font-size: 24rpx; color: #94a3b8; }

/* 资讯列表项 */
.notice-list {
  padding: 20rpx 24rpx;
}

.notice-item {
  display: flex;
  background-color: #ffffff;
  border-radius: 28rpx;
  padding: 24rpx;
  margin-bottom: 24rpx;
  box-shadow: 0 8rpx 20rpx rgba(0, 0, 0, 0.02);
  border: 1rpx solid #f1f5f9;
}

.item-hover {
  background-color: #f8fafc;
}

.notice-cover {
  width: 180rpx;
  height: 180rpx;
  border-radius: 20rpx;
  flex-shrink: 0;
  background-color: #f1f5f9;
}

.notice-content {
  flex: 1;
  margin-left: 28rpx;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.notice-title {
  font-size: 32rpx;
  font-weight: 700;
  color: #1e293b;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 1;
  overflow: hidden;
}

.notice-desc {
  font-size: 26rpx;
  color: #64748b;
  margin-top: 10rpx;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  overflow: hidden;
}

.notice-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 12rpx;
}

.notice-tag {
  font-size: 20rpx;
  color: #3b82f6;
  background: #eff6ff;
  padding: 4rpx 16rpx;
  border-radius: 10rpx;
  font-weight: 600;
}

.notice-arrow {
  font-size: 24rpx;
  color: #3b82f6;
  font-weight: 500;
}

.empty-box {
  padding: 120rpx 0;
  display: flex;
  flex-direction: column;
  align-items: center;
}
.empty-icon { font-size: 100rpx; opacity: 0.2; }
.empty-text { color: #cbd5e1; font-size: 28rpx; margin-top: 20rpx;}

.safe-bottom { height: 80rpx; }

/* 适配 PC Web 端 */
@media screen and (min-width: 768px) {
  .page-container {
    max-width: 600px;
    margin: 0 auto;
    border-left: 1rpx solid #e2e8f0;
    border-right: 1rpx solid #e2e8f0;
  }
}
</style>