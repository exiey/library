<!-- 资讯详情 - 现代沉浸式阅读风格 -->
<template>
  <view class="detail-container">
    <!-- 导航栏：保持原有逻辑，美化样式 -->
    <u-navbar
        title="资讯详情"
        :border="false"
        :placeholder="true"
        @leftClick="goBack"
        :autoBack="false"
        bgColor="#ffffff"
        titleStyle="font-weight: bold; color: #333;"
    ></u-navbar>

    <scroll-view scroll-y class="detail-scroll" :enable-flex="true">
      <view class="article-wrapper">
        <!-- 1. 标题区 -->
        <view class="header-section">
          <text class="article-title">{{ fobj.title || '载入中...' }}</text>
          <view class="meta-info">
            <text class="meta-icon">🕒</text>
            <text class="meta-text">{{ fobj.ndate || '日期获取中' }}</text>
            <text class="meta-tag">官方资讯</text>
          </view>
        </view>

        <!-- 2. 封面图区 -->
        <view class="image-section" v-if="fobj.img">
          <image
              class="article-banner"
              :src="fileUrl + fobj.img"
              mode="widthFix"
              @error="onImgError"
          ></image>
        </view>

        <!-- 3. 内容正文区 -->
        <view class="content-section">
          <view class="content-divider"></view>
          <!-- u-parse 渲染富文本内容 -->
          <view class="rich-text-container">
            <u-parse :content="fobj.note" :selectable="true" />
          </view>
        </view>

        <!-- 4. 底部装饰/版权 -->
        <view class="footer-notice">
          <text>—— 正文内容结束 ——</text>
        </view>
      </view>

      <!-- 安全区域占位 -->
      <view class="safe-area-bottom"></view>
    </scroll-view>
  </view>
</template>

<script>
import { listj, findj, fileUrl } from '@/common/config/api.js';
import { ideautil } from '@/common/commontools.js';
import { mapState, mapActions } from 'vuex';

export default {
  data() {
    return {
      tid: null,
      fileUrl: fileUrl,
      fobj: {}
    };
  },
  onLoad(params) {
    this.tid = params.tid;
    this.fobjDetail();
  },
  methods: {
    fobjDetail() {
      // 保留原业务逻辑
      findj({ params: { table: 'notice', id: this.tid } }).then(res => {
        if (res) {
          let note = ideautil.getHtmlNote(res.note);
          res.note = note;
          this.fobj = res;
        }
      }).catch(err => {
        console.error("资讯详情获取失败", err);
      });
    },
    goBack() {
      uni.navigateBack();
    },
    onImgError() {
      // 图片加载失败处理
      console.log("图片加载失败");
    }
  }
}
</script>

<style lang="scss" scoped>
/* 容器背景色 */
.detail-container {
  min-height: 100vh;
  background-color: #ffffff;
}

.detail-scroll {
  height: calc(100vh - 44px); /* 动态减去导航栏高度 */
}

.article-wrapper {
  padding: 30rpx 40rpx;
}

/* 标题区样式 */
.header-section {
  margin-bottom: 40rpx;
}

.article-title {
  font-size: 44rpx;
  color: #1a1a1a;
  line-height: 1.4;
  font-weight: 700;
  display: block;
  margin-bottom: 24rpx;
}

.meta-info {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
}

.meta-icon {
  font-size: 24rpx;
  margin-right: 8rpx;
}

.meta-text {
  font-size: 26rpx;
  color: #8e8e93;
  margin-right: 20rpx;
}

.meta-tag {
  font-size: 22rpx;
  color: #4facfe;
  background-color: rgba(79, 172, 254, 0.1);
  padding: 4rpx 16rpx;
  border-radius: 6rpx;
  font-weight: 500;
}

/* 图片区样式 */
.image-section {
  margin: 30rpx 0;
  border-radius: 20rpx;
  overflow: hidden;
  box-shadow: 0 8rpx 24rpx rgba(0, 0, 0, 0.05);
}

.article-banner {
  width: 100%;
  display: block; /* 消除图片底部空隙 */
}

/* 正文区样式 */
.content-section {
  margin-top: 40rpx;
}

.content-divider {
  width: 60rpx;
  height: 6rpx;
  background-color: #4facfe;
  margin-bottom: 40rpx;
  border-radius: 3rpx;
}

.rich-text-container {
  font-size: 32rpx;
  color: #334155;
  line-height: 1.8;
  letter-spacing: 0.5rpx;
}

/* 底部装饰 */
.footer-notice {
  margin-top: 80rpx;
  padding-bottom: 40rpx;
  text-align: center;
}

.footer-notice text {
  font-size: 24rpx;
  color: #cbd5e1;
}

.safe-area-bottom {
  height: env(safe-area-inset-bottom);
}

/* Web端自适应排版优化 */
@media screen and (min-width: 750px) {
  .article-wrapper {
    max-width: 700px;
    margin: 0 auto;
    padding: 60rpx 0;
  }

  .article-title {
    font-size: 56rpx;
  }

  .detail-container {
    background-color: #f8fafc;
  }

  .detail-scroll {
    background-color: #fff;
    max-width: 800px;
    margin: 0 auto;
    box-shadow: 0 0 20px rgba(0,0,0,0.05);
  }
}
</style>