<template>
  <view class="page-container">
    <!-- 导航栏：增加背景色和下边距 -->
    <u-navbar
        :title="ptitle"
        :border="false"
        :placeholder="true"
        @leftClick="goBack"
        :autoBack="false"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #333;"
    ></u-navbar>

    <scroll-view :enable-flex="true" scroll-y class="svcontainer">
      <!-- 顶部装饰与统计区 -->
      <view class="header-banner">
        <view class="banner-content">
          <view class="text-group">
            <text class="main-title">社区交流</text>
            <text class="sub-title">分享生活，发现精彩 ✨</text>
          </view>
          <view class="stat-badge">
            <text class="num">{{ fobjList.length }}</text>
            <text class="unit">篇内容</text>
          </view>
        </view>
      </view>

      <!-- 操作区域：新增按钮 -->
      <view class="action-section">
        <view class="btn-wrapper" @click="postsMg('')">
          <text class="btn-icon">✍️</text>
          <text class="btn-text">发布新动态</text>
        </view>
      </view>

      <!-- 列表区域 -->
      <view class="list-wrapper">
        <view v-if="fobjList.length > 0" class="list-inner">
          <imglist
              :imgSize="2"
              titleName="title"
              @clickItem='postsMg'
              :dataList='fobjList'
              tName="username"
              sName='ndate'
          ></imglist>
        </view>

        <!-- 空状态处理 -->
        <view v-else class="empty-state">
          <text class="empty-icon">📂</text>
          <text class="empty-text">暂无数据，快去发布吧~</text>
        </view>
      </view>

      <!-- 底部占位 -->
      <view class="safe-area-inset-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listj, findj, savej, fileUrl } from '@/common/config/api.js';
import {mapState, mapActions} from 'vuex';
import imgList from '@/components/img-list.vue';
import { ideautil, yewuutil } from '@/common/commontools.js';

export default {
  components: {
    imgList
  },
  data() {
    return {
      fobjList: [],
      ftype: 1,
      ptitle: "我的交流论坛"
    };
  },
  onLoad(params) {
    let uid = this.userInfo.id
    this.ftype = params.type || "1"
    this.ptitle = "我的交流论坛"
    this.loadData(uid);
  },
  methods: {
    ...mapActions(['updateUserInfo']),
    loadData(uid) {
      listj({
        params: {
          table: 'posts',
          uid: uid,
          type: this.ftype
        }
      }).then(res => {
        this.fobjList = res || []
      }).catch(err => {
        console.error(err)
      })
    },
    postsMg(id) {
      console.log("------------------>:aid:" + id)
      // 统一跳转逻辑
      uni.redirectTo({
        url: `./postsmg?totype=2&type=${this.ftype}&tid=${id || ''}`
      })
    },
    goBack() {
      uni.switchTab({
        url: '/pages/me/me'
      })
    }
  },
  computed: {
    ...mapState(['userInfo'])
  }
}
</script>

<style lang="scss" scoped>
/* 容器背景色，增加清新感 */
.page-container {
  background-color: #f7f8fa;
  min-height: 100vh;
}

.svcontainer {
  height: calc(100vh - 44px); /* 减去顶部高度 */
  display: flex;
  flex-direction: column;
}

/* 顶部 Banner 样式 */
.header-banner {
  padding: 40rpx 30rpx;
  background: linear-gradient(135deg, #ffffff 0%, #eef2f3 100%);
  border-bottom-left-radius: 40rpx;
  border-bottom-right-radius: 40rpx;
  margin-bottom: 30rpx;
  box-shadow: 0 4rpx 20rpx rgba(0, 0, 0, 0.05);

  .banner-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .text-group {
    .main-title {
      font-size: 44rpx;
      font-weight: 800;
      color: #2c3e50;
      display: block;
      margin-bottom: 8rpx;
    }
    .sub-title {
      font-size: 24rpx;
      color: #7f8c8d;
    }
  }

  .stat-badge {
    background-color: #ffffff;
    padding: 15rpx 25rpx;
    border-radius: 20rpx;
    display: flex;
    flex-direction: column;
    align-items: center;
    box-shadow: 0 2rpx 10rpx rgba(0,0,0,0.03);

    .num {
      font-size: 36rpx;
      font-weight: bold;
      color: #3b82f6;
    }
    .unit {
      font-size: 20rpx;
      color: #94a3b8;
    }
  }
}

/* 新增按钮美化 */
.action-section {
  padding: 0 30rpx;
  margin-bottom: 30rpx;

  .btn-wrapper {
    background: #3b82f6;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24rpx;
    border-radius: 24rpx;
    box-shadow: 0 10rpx 20rpx rgba(59, 130, 246, 0.3);
    transition: transform 0.2s ease;

    &:active {
      transform: scale(0.98);
      opacity: 0.9;
    }

    .btn-icon {
      font-size: 32rpx;
      margin-right: 12rpx;
    }

    .btn-text {
      color: #ffffff;
      font-size: 30rpx;
      font-weight: 600;
      letter-spacing: 2rpx;
    }
  }
}

/* 列表包装器 */
.list-wrapper {
  padding: 0 20rpx;

  .list-inner {
    background-color: transparent;
    /* 穿透修改内部组件样式(可选) */
    ::v-deep .imglist-item {
      background: #ffffff;
      border-radius: 20rpx;
      margin-bottom: 20rpx;
      overflow: hidden;
      box-shadow: 0 2rpx 12rpx rgba(0,0,0,0.04);
    }
  }
}

/* 空状态样式 */
.empty-state {
  padding-top: 100rpx;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;

  .empty-icon {
    font-size: 100rpx;
    margin-bottom: 20rpx;
    filter: grayscale(0.5);
  }

  .empty-text {
    color: #94a3b8;
    font-size: 28rpx;
  }
}

/* 适配刘海屏 */
.safe-area-inset-bottom {
  height: var(--window-bottom);
  padding-bottom: env(safe-area-inset-bottom);
}

/* Web端适配：限制最大宽度防止拉伸过宽 */
@media screen and (min-width: 768px) {
  .page-container {
    max-width: 600px;
    margin: 0 auto;
    border-left: 1px solid #eee;
    border-right: 1px solid #eee;
  }
}
</style>