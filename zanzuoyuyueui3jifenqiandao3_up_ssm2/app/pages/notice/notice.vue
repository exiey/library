<template>
  <view class="notice-page">
    <!-- 导航栏 -->
    <u-navbar
        title="通知公告"
        :border="false"
        :placeholder="true"
        @leftClick="goBack()"
        :autoBack="false"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #1a1a1a;"
    ></u-navbar>

    <scroll-view :enable-flex="true" scroll-y class="svcontainer">
      <!-- 顶部欢迎/统计装饰 -->
      <view class="header-banner">
        <view class="banner-inner">
          <view class="banner-left">
            <text class="banner-title">重要资讯</text>
            <text class="banner-subtitle">掌握平台最新动态与通知</text>
          </view>
          <text class="banner-icon">📢</text>
        </view>
      </view>

      <!-- 原生实现的公告列表 -->
      <view class="notice-list">
        <view
            v-for="(item, index) in fobjlist"
            :key="index"
            class="notice-card"
            @click="toNoticeDetail(item.id)"
        >
          <view class="card-body">
            <!-- 如果公告有图片，显示左侧/顶部缩略图 -->
            <image
                v-if="item.img"
                :src="fileUrl + item.img"
                mode="aspectFill"
                class="notice-img"
            ></image>

            <view class="notice-content">
              <view class="title-row">
                <text class="notice-tag">公告</text>
                <text class="notice-title">{{ item.title }}</text>
              </view>

              <text class="notice-brief">{{ item.note }}</text>

              <view class="notice-footer">
                <view class="date-info">
                  <text class="calendar-icon">🕒</text>
                  <text>{{ item.ndate }}</text>
                </view>
                <text class="detail-link">阅读详情 →</text>
              </view>
            </view>
          </view>
        </view>

        <!-- 空状态展示 -->
        <view v-if="fobjlist.length === 0" class="empty-state">
          <text class="empty-emoji">📝</text>
          <text class="empty-text">暂无相关通知内容</text>
        </view>
      </view>

      <!-- 底部占位 -->
      <view class="safe-area-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import {
  listj,
  findj,
  savej,
  deletej,
  fileUrl
} from '@/common/config/api.js';
import {
  mapState,
  mapActions
} from 'vuex';

export default {
  data() {
    return {
      fileUrl: fileUrl,
      fobjlist: []
    };
  },
  onLoad(params) {
    this.loadNotice();
  },
  methods: {
    loadNotice() {
      listj({
        params: {
          table: 'notice',
          type: 1
        }
      }).then(res => {
        for (let s of res) {
            s.note = uni.itool.getSimpleText(s.note)
        }
        this.fobjlist = res || []
      }).catch(err => {
        console.error(err)
      })
    },
    toNoticeDetail(tid) {
      uni.redirectTo({
        url: '/pages/notice/noticedetail?tid=' + tid
      })
    },
    goBack() {
      uni.switchTab({
        url: '/pages/index/index'
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.notice-page {
  background-color: #f6f8fa;
  min-height: 100vh;
}

.svcontainer {
  height: calc(100vh - 44px);
}

/* 顶部装饰条 */
.header-banner {
  padding: 40rpx 30rpx;
  background: linear-gradient(135deg, #ffffff 0%, #eef2f3 100%);
  margin-bottom: 20rpx;

  .banner-inner {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .banner-left {
    .banner-title {
      font-size: 44rpx;
      font-weight: 800;
      color: #2c3e50;
      display: block;
    }
    .banner-subtitle {
      font-size: 24rpx;
      color: #7f8c8d;
      margin-top: 8rpx;
      display: block;
    }
  }

  .banner-icon {
    font-size: 60rpx;
    opacity: 0.8;
  }
}

/* 公告列表容器 */
.notice-list {
  padding: 0 24rpx;
}

/* 原生卡片样式 */
.notice-card {
  background-color: #ffffff;
  border-radius: 24rpx;
  margin-bottom: 24rpx;
  overflow: hidden;
  box-shadow: 0 4rpx 16rpx rgba(0, 0, 0, 0.04);
  border: 1rpx solid #f0f0f0;
  transition: transform 0.2s ease;

  &:active {
    transform: scale(0.98);
    background-color: #fafafa;
  }

  .card-body {
    display: flex;
    flex-direction: column; /* 默认纵向，如果有图可改为横向 */

    .notice-img {
      width: 100%;
      height: 280rpx;
      background-color: #eee;
    }

    .notice-content {
      padding: 24rpx;
    }
  }
}

.title-row {
  display: flex;
  align-items: center;
  margin-bottom: 16rpx;

  .notice-tag {
    background-color: #e3f2fd;
    color: #2196f3;
    font-size: 20rpx;
    padding: 4rpx 12rpx;
    border-radius: 8rpx;
    margin-right: 12rpx;
    font-weight: bold;
    flex-shrink: 0;
  }

  .notice-title {
    font-size: 32rpx;
    font-weight: bold;
    color: #333;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
}

.notice-brief {
  font-size: 26rpx;
  color: #666;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2; /* 限制两行预览 */
  overflow: hidden;
  margin-bottom: 20rpx;
}

.notice-footer {
  border-top: 1rpx solid #f5f5f5;
  padding-top: 20rpx;
  display: flex;
  justify-content: space-between;
  align-items: center;

  .date-info {
    display: flex;
    align-items: center;
    font-size: 22rpx;
    color: #999;

    .calendar-icon {
      margin-right: 8rpx;
      font-size: 24rpx;
    }
  }

  .detail-link {
    font-size: 24rpx;
    color: #2196f3;
    font-weight: 500;
  }
}

/* 空状态 */
.empty-state {
  padding: 100rpx 0;
  display: flex;
  flex-direction: column;
  align-items: center;

  .empty-emoji {
    font-size: 100rpx;
    margin-bottom: 20rpx;
    opacity: 0.5;
  }

  .empty-text {
    color: #999;
    font-size: 28rpx;
  }
}

.safe-area-bottom {
  height: env(safe-area-inset-bottom);
  padding-bottom: 40rpx;
}

/* Web端适配 */
@media screen and (min-width: 768px) {
  .notice-page {
    max-width: 600px;
    margin: 0 auto;
    border-left: 1rpx solid #eaeaea;
    border-right: 1rpx solid #eaeaea;
  }
}
</style>